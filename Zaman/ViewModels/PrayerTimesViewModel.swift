//
//  PrayerTimesViewModel.swift
//  Zaman
//
//  Created by Danyal Faheem on 25/01/2026.
//

import Foundation
import Combine
import SwiftUI
import CoreLocation

@MainActor
class PrayerTimesViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var prayerTimes: [PrayerTime] = []
    @Published var countries: [Country] = []
    @Published var selectedCountry: Country?
    @Published var selectedCity: City?
    @Published var selectedCountryCode: String = "AE"
    @Published var selectedCityName: String = "Dubai"
    @Published var isLoading = false
    @Published var error: String?
    @Published var upcomingEvent: UpcomingEvent?
    @Published var menuBarTitle: String = ""
    @Published var showCountdown = false
    @Published var currentHijriDate: String = ""
    
    // MARK: - Computed Properties
    var currentCities: [City] {
        selectedCountry?.cities ?? []
    }
    
    var currentLocationText: String {
        if let city = selectedCity, let country = selectedCountry {
            let timezoneDiff = getTimezoneDifference(for: city)
            if timezoneDiff.isEmpty {
                return "\(city.name), \(country.name)"
            } else {
                return "\(city.name), \(country.name) (\(timezoneDiff))"
            }
        }
        return "Select location"
    }
    
    private func getTimezoneDifference(for city: City) -> String {
        guard let cityTimezone = TimeZone(identifier: city.timezone) else {
            return ""
        }
        
        let systemTimezone = TimeZone.current
        let now = Date()
        
        let cityOffset = cityTimezone.secondsFromGMT(for: now)
        let systemOffset = systemTimezone.secondsFromGMT(for: now)
        
        let differenceInSeconds = cityOffset - systemOffset
        
        // If same timezone, don't show anything
        if differenceInSeconds == 0 {
            return ""
        }
        
        let hours = abs(differenceInSeconds) / 3600
        let minutes = (abs(differenceInSeconds) % 3600) / 60
        
        let sign = differenceInSeconds > 0 ? "+" : "-"
        
        if minutes == 0 {
            return "\(sign)\(hours)h"
        } else {
            return "\(sign)\(hours)h \(minutes)m"
        }
    }
    
    var hijriDate: String {
        return currentHijriDate.isEmpty ? "" : currentHijriDate
    }
    
    var gregorianDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }
    
    // MARK: - Services
    private let apiService = PrayerAPIService.shared
    private let settings = SettingsManager.shared
    private let notificationManager = NotificationManager.shared
    private let locationManager = LocationManager.shared
    
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    private var midnightTimer: Timer?
    private var isChangingLocation = false
    private var lastRefreshDate: Date?
    
    // MARK: - Constants
    private let countdownThreshold: TimeInterval = 15 * 60 // 15 minutes
    
    // MARK: - Initialization
    init() {
        startTimer()
        setupSettingsObservers()
        setupLocationObserver()
        setupMidnightTimer()
        setupSystemWakeObserver()
    }
    
    deinit {
        timer?.invalidate()
        midnightTimer?.invalidate()
        cancellables.removeAll()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Settings Observers
    private func setupSettingsObservers() {
        // Observe changes to display settings and update accordingly
        settings.$showAdhanCountdown
            .dropFirst() // Skip initial value
            .sink { [weak self] _ in
                Task { @MainActor in
                    self?.updateUpcomingEvent()
                    self?.updateMenuBarTitle()
                }
            }
            .store(in: &cancellables)
        
        settings.$showIqamaCountdown
            .dropFirst() // Skip initial value
            .sink { [weak self] _ in
                Task { @MainActor in
                    self?.updateUpcomingEvent()
                    self?.updateMenuBarTitle()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Location Observer
    private func setupLocationObserver() {
        locationManager.$currentLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                Task { @MainActor in
                    await self?.handleLocationUpdate(location)
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleLocationUpdate(_ location: CLLocation) async {
        // Only use location if user hasn't manually selected a city
        guard !settings.hasManuallySelectedLocation else {
            return
        }
        
        // Get all cities from all countries
        let allCities = countries.flatMap { $0.cities }
        
        // Find nearest city
        if let nearestCity = locationManager.findNearestCity(from: allCities, location: location),
           let country = countries.first(where: { $0.id == nearestCity.countryCode }) {
            
            selectedCountry = country
            selectedCountryCode = country.id
            selectedCity = nearestCity
            selectedCityName = nearestCity.name
            
            // Save location but don't mark as manual
            settings.selectLocation(countryCode: country.id, cityName: nearestCity.name, isManual: false)
            
            // Fetch prayer times for the detected location
            await fetchPrayerTimes()
        }
    }
    
    // MARK: - Timer
    private func startTimer() {
        // Update every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.checkAndRefreshIfNeeded()
                self?.updateUpcomingEvent()
                self?.updateMenuBarTitle()
            }
        }
        timer?.tolerance = 0.1
    }
    
    // MARK: - Midnight Timer
    private func setupMidnightTimer() {
        scheduleMidnightTimer()
    }
    
    private func scheduleMidnightTimer() {
        // Calculate time until next midnight
        let calendar = Calendar.current
        let now = Date()
        
        guard let midnight = calendar.nextDate(after: now,
                                               matching: DateComponents(hour: 0, minute: 0),
                                               matchingPolicy: .nextTime) else {
            return
        }
        
        let timeInterval = midnight.timeIntervalSince(now)
        
        // Schedule timer to fire at midnight
        midnightTimer?.invalidate()
        midnightTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
            Task { @MainActor in
                await self?.refreshAtMidnight()
            }
        }
    }
    
    private func refreshAtMidnight() async {
        print("Midnight refresh triggered")
        await fetchPrayerTimes()
        // Schedule next midnight timer
        scheduleMidnightTimer()
    }
    
    // MARK: - System Wake Observer
    private func setupSystemWakeObserver() {
        // Observe when system wakes from sleep
        NotificationCenter.default.addObserver(
            forName: NSWorkspace.didWakeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                await self?.handleSystemWake()
            }
        }
        
        // Observe when app becomes active
        NotificationCenter.default.addObserver(
            forName: NSApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                await self?.handleAppBecomeActive()
            }
        }
    }
    
    private func handleSystemWake() async {
        print("System wake detected")
        await checkAndRefreshIfNeeded(force: true)
    }
    
    private func handleAppBecomeActive() async {
        await checkAndRefreshIfNeeded()
    }
    
    private func checkAndRefreshIfNeeded(force: Bool = false) async {
        let calendar = Calendar.current
        let now = Date()
        
        // Check if we need to refresh (new day or forced)
        if force || lastRefreshDate == nil || !calendar.isDate(now, inSameDayAs: lastRefreshDate ?? .distantPast) {
            print("Refreshing prayer times for new day")
            await fetchPrayerTimes()
        }
    }
    
    // MARK: - Data Loading
    func loadData() async {
        isLoading = true
        error = nil
        
        do {
            // Fetch countries and cities
            let fetchedCountries = try await apiService.fetchCountriesAndCities()
            self.countries = fetchedCountries
            
            // Request location to auto-detect nearest city
            locationManager.requestLocation()
            
            // Set initial selection based on settings
            if let country = fetchedCountries.first(where: { $0.id == settings.selectedCountryCode }) {
                selectedCountry = country
                selectedCountryCode = country.id
                if let city = country.cities.first(where: { $0.name == settings.selectedCityName }) {
                    selectedCity = city
                    selectedCityName = city.name
                } else if let firstCity = country.cities.first {
                    selectedCity = firstCity
                    selectedCityName = firstCity.name
                }
            } else if let firstCountry = fetchedCountries.first {
                selectedCountry = firstCountry
                selectedCountryCode = firstCountry.id
                if let firstCity = firstCountry.cities.first {
                    selectedCity = firstCity
                    selectedCityName = firstCity.name
                }
            }
            
            // Fetch prayer times
            await fetchPrayerTimes()
            
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func fetchPrayerTimes() async {
        guard let city = selectedCity else { return }
        
        isLoading = true
        
        do {
            let result = try await apiService.fetchPrayerTimes(
                cityName: city.name,
                countryCode: city.countryCode
            )
            
            prayerTimes = result.prayerTimes
            currentHijriDate = result.hijriDate
            
            // Track last refresh date
            lastRefreshDate = Date()
            
            // Update settings
            settings.selectLocation(countryCode: city.countryCode, cityName: city.name)
            settings.lastFetchDate = Date()
            
            // Schedule notifications
            notificationManager.scheduleNotifications(for: prayerTimes, settings: settings)
            
            // Update upcoming event
            updateUpcomingEvent()
            updateMenuBarTitle()
            
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Location Selection
    func onCountryChanged(_ countryCode: String) {
        guard !isChangingLocation else { return }
        guard let country = countries.first(where: { $0.id == countryCode }) else { return }
        
        isChangingLocation = true
        
        selectedCountry = country
        selectedCountryCode = countryCode
        selectedCity = country.cities.first
        selectedCityName = country.cities.first?.name ?? ""
        
        isChangingLocation = false
        
        Task {
            await fetchPrayerTimes()
        }
    }
    
    func onCityChanged(_ cityName: String) {
        guard !isChangingLocation else { return }
        guard let city = currentCities.first(where: { $0.name == cityName }) else { return }
        
        selectedCity = city
        selectedCityName = cityName
        
        Task {
            await fetchPrayerTimes()
        }
    }
    
    func selectCountry(_ country: Country) {
        selectedCountry = country
        selectedCountryCode = country.id
        selectedCity = country.cities.first
        selectedCityName = country.cities.first?.name ?? ""
        
        Task {
            await fetchPrayerTimes()
        }
    }
    
    func selectCity(_ city: City) {
        selectedCity = city
        selectedCityName = city.name
        
        Task { @MainActor in
            await fetchPrayerTimes()
        }
    }
    
    // MARK: - Upcoming Event Calculation
    func updateUpcomingEvent() {
        let now = Date()
        var allEvents: [UpcomingEvent] = []
        
        for prayerTime in prayerTimes {
            // Skip sunrise
            if prayerTime.type == .sunrise { continue }
            
            // Check if we're in the Adhan display period (60 seconds after Adhan time)
            let adhanDisplayEnd = prayerTime.adhanTime.addingTimeInterval(60)
            
            if now >= prayerTime.adhanTime && now < adhanDisplayEnd {
                // We're in the 60-second Adhan display period
                if settings.showAdhanCountdown {
                    allEvents.append(UpcomingEvent(type: .adhan(prayerTime.type), time: prayerTime.adhanTime))
                }
            } else if prayerTime.adhanTime > now {
                // Adhan hasn't happened yet
                if settings.showAdhanCountdown {
                    allEvents.append(UpcomingEvent(type: .adhan(prayerTime.type), time: prayerTime.adhanTime))
                }
            }
            
            // Add Iqama event only if it's after the Adhan display period
            if let iqamaTime = prayerTime.iqamaTime {
                if iqamaTime > now && now >= adhanDisplayEnd && settings.showIqamaCountdown {
                    allEvents.append(UpcomingEvent(type: .iqama(prayerTime.type), time: iqamaTime))
                }
            }
        }
        
        // Sort by time and get the next upcoming event
        allEvents.sort { $0.time < $1.time }
        upcomingEvent = allEvents.first
        
        // Determine if countdown should be shown
        if let upcoming = upcomingEvent {
            let timeRemaining = upcoming.timeRemaining(from: now)
            
            // For Adhan: only show if it's upcoming (not during the 60-second display)
            if case .adhan(let prayer) = upcoming.type {
                if now >= upcoming.time && now < upcoming.time.addingTimeInterval(60) {
                    // During Adhan display period - no countdown
                    showCountdown = false
                } else {
                    // Before Adhan - show countdown if within threshold and enabled
                    showCountdown = settings.showAdhanCountdown && timeRemaining <= countdownThreshold && timeRemaining > 0
                }
            } else {
                // For Iqama - always show countdown if within threshold and enabled
                showCountdown = settings.showIqamaCountdown && timeRemaining <= countdownThreshold && timeRemaining > 0
            }
        } else {
            showCountdown = false
        }
    }
    
    // MARK: - Menu Bar Title
    func updateMenuBarTitle() {
        guard let upcoming = upcomingEvent else {
            menuBarTitle = ""
            return
        }
        
        let now = Date()
        let timeRemaining = upcoming.timeRemaining(from: now)
        
        // Check if we're in the Adhan display period (60 seconds)
        if case .adhan(let prayer) = upcoming.type {
            if now >= upcoming.time && now < upcoming.time.addingTimeInterval(60) {
                // During Adhan - just display "{Prayer} Adhan" for 60 seconds if enabled
                if settings.showAdhanCountdown {
                    menuBarTitle = "\(prayer.rawValue) Adhan"
                } else {
                    menuBarTitle = ""
                }
                return
            }
        }
        
        if timeRemaining <= 0 {
            menuBarTitle = ""
            return
        }
        
        // Only show countdown within threshold and if enabled
        if timeRemaining <= countdownThreshold {
            let prayer = upcoming.prayerType
            let eventType = upcoming.isIqama ? "Iqama" : "Adhan"
            let isEnabled = upcoming.isIqama ? settings.showIqamaCountdown : settings.showAdhanCountdown
            
            if isEnabled {
                let timeString = upcoming.formattedTimeRemaining(from: now)
                menuBarTitle = "\(timeString): \(prayer.rawValue) \(eventType)"
            } else {
                menuBarTitle = ""
            }
        } else {
            menuBarTitle = ""
        }
    }
    
    // MARK: - Refresh
    func refresh() async {
        await fetchPrayerTimes()
    }
}
