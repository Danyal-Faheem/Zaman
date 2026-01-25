//
//  SettingsManager.swift
//  Zaman
//
//  Created by Danyal Faheem on 25/01/2026.
//

import Foundation
import ServiceManagement
import Combine

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    // MARK: - Keys
    private enum Keys {
        static let selectedCountryCode = "selectedCountryCode"
        static let selectedCityName = "selectedCityName"
        static let adhanNotificationsEnabled = "adhanNotificationsEnabled"
        static let iqamaNotificationsEnabled = "iqamaNotificationsEnabled"
        static let launchAtLogin = "launchAtLogin"
        static let lastFetchDate = "lastFetchDate"
        static let showAdhanCountdown = "showAdhanCountdown"
        static let showIqamaCountdown = "showIqamaCountdown"
        static let hasManuallySelectedLocation = "hasManuallySelectedLocation"
    }
    
    // MARK: - Published Properties
    @Published var selectedCountryCode: String {
        didSet {
            UserDefaults.standard.set(selectedCountryCode, forKey: Keys.selectedCountryCode)
        }
    }
    
    @Published var selectedCityName: String {
        didSet {
            UserDefaults.standard.set(selectedCityName, forKey: Keys.selectedCityName)
        }
    }
    
    @Published var adhanNotificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(adhanNotificationsEnabled, forKey: Keys.adhanNotificationsEnabled)
        }
    }
    
    @Published var iqamaNotificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(iqamaNotificationsEnabled, forKey: Keys.iqamaNotificationsEnabled)
        }
    }
    
    @Published var launchAtLogin: Bool {
        didSet {
            UserDefaults.standard.set(launchAtLogin, forKey: Keys.launchAtLogin)
            updateLaunchAtLogin(launchAtLogin)
        }
    }
    
    @Published var showAdhanCountdown: Bool {
        didSet {
            UserDefaults.standard.set(showAdhanCountdown, forKey: Keys.showAdhanCountdown)
        }
    }
    
    @Published var showIqamaCountdown: Bool {
        didSet {
            UserDefaults.standard.set(showIqamaCountdown, forKey: Keys.showIqamaCountdown)
        }
    }
    
    var hasManuallySelectedLocation: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.hasManuallySelectedLocation)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.hasManuallySelectedLocation)
        }
    }
    
    var lastFetchDate: Date? {
        get {
            UserDefaults.standard.object(forKey: Keys.lastFetchDate) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.lastFetchDate)
        }
    }
    
    // MARK: - Initialization
    private init() {
        // Default to Dubai, UAE
        self.selectedCountryCode = UserDefaults.standard.string(forKey: Keys.selectedCountryCode) ?? "AE"
        self.selectedCityName = UserDefaults.standard.string(forKey: Keys.selectedCityName) ?? "Abu Dhabi"
        self.adhanNotificationsEnabled = UserDefaults.standard.bool(forKey: Keys.adhanNotificationsEnabled)
        self.iqamaNotificationsEnabled = UserDefaults.standard.bool(forKey: Keys.iqamaNotificationsEnabled)
        self.launchAtLogin = UserDefaults.standard.bool(forKey: Keys.launchAtLogin)        
        // Default to true for showing countdowns (use object(forKey:) to distinguish between false and not set)
        self.showAdhanCountdown = UserDefaults.standard.object(forKey: Keys.showAdhanCountdown) as? Bool ?? true
        self.showIqamaCountdown = UserDefaults.standard.object(forKey: Keys.showIqamaCountdown) as? Bool ?? true    }
    
    // MARK: - Location Selection
    func selectLocation(countryCode: String, cityName: String, isManual: Bool = true) {
        selectedCountryCode = countryCode
        selectedCityName = cityName
        if isManual {
            hasManuallySelectedLocation = true
        }
    }
    
    // MARK: - Launch at Login
    private func updateLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("Failed to update launch at login: \(error)")
        }
    }
    
    // MARK: - Check if location needs update
    var needsLocationUpdate: Bool {
        guard let lastFetch = lastFetchDate else { return true }
        let calendar = Calendar.current
        return !calendar.isDateInToday(lastFetch)
    }
}
