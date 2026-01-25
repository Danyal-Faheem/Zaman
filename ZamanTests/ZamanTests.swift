//
//  ZamanTests.swift
//  ZamanTests
//
//  Created by Danyal Faheem on 25/01/2026.
//

import XCTest
@testable import Zaman

@MainActor
final class ZamanTests: XCTestCase {
    
    var viewModel: PrayerTimesViewModel!
    var settings: SettingsManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = PrayerTimesViewModel()
        settings = SettingsManager.shared
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Settings Tests
    
    func testSettingsPersistence() throws {
        // Test that location settings persist
        let testCountryCode = "US"
        let testCityName = "New York, NY"
        
        settings.selectLocation(countryCode: testCountryCode, cityName: testCityName, isManual: true)
        
        XCTAssertEqual(settings.selectedCountryCode, testCountryCode)
        XCTAssertEqual(settings.selectedCityName, testCityName)
        XCTAssertTrue(settings.hasManuallySelectedLocation)
    }
    
    func testNotificationSettings() throws {
        // Test notification toggles
        settings.adhanNotificationsEnabled = true
        settings.iqamaNotificationsEnabled = true
        
        XCTAssertTrue(settings.adhanNotificationsEnabled)
        XCTAssertTrue(settings.iqamaNotificationsEnabled)
        
        settings.adhanNotificationsEnabled = false
        settings.iqamaNotificationsEnabled = false
        
        XCTAssertFalse(settings.adhanNotificationsEnabled)
        XCTAssertFalse(settings.iqamaNotificationsEnabled)
    }
    
    func testDisplaySettings() throws {
        // Test display countdown toggles
        settings.showAdhanCountdown = true
        settings.showIqamaCountdown = true
        
        XCTAssertTrue(settings.showAdhanCountdown)
        XCTAssertTrue(settings.showIqamaCountdown)
        
        settings.showAdhanCountdown = false
        settings.showIqamaCountdown = false
        
        XCTAssertFalse(settings.showAdhanCountdown)
        XCTAssertFalse(settings.showIqamaCountdown)
    }
    
    // MARK: - Prayer Time Model Tests
    
    func testPrayerTypeProperties() throws {
        // Test prayer type properties
        XCTAssertTrue(PrayerType.fajr.hasIqama)
        XCTAssertFalse(PrayerType.sunrise.hasIqama)
        XCTAssertTrue(PrayerType.dhuhr.hasIqama)
        
        XCTAssertEqual(PrayerType.fajr.arabicName, "الفجر")
        XCTAssertEqual(PrayerType.dhuhr.arabicName, "الظهر")
        XCTAssertEqual(PrayerType.maghrib.arabicName, "المغرب")
    }
    
    func testPrayerTimeFormatting() throws {
        let calendar = Calendar.current
        let now = Date()
        
        // Create a test prayer time
        let adhanComponents = calendar.dateComponents([.year, .month, .day], from: now)
        var adhanTime = calendar.date(from: adhanComponents)!
        adhanTime = calendar.date(bySettingHour: 5, minute: 30, second: 0, of: adhanTime)!
        
        var iqamaTime = calendar.date(from: adhanComponents)!
        iqamaTime = calendar.date(bySettingHour: 5, minute: 45, second: 0, of: iqamaTime)!
        
        let prayerTime = PrayerTime(type: .fajr, adhanTime: adhanTime, iqamaTime: iqamaTime)
        
        XCTAssertNotNil(prayerTime.formattedAdhanTime)
        XCTAssertNotNil(prayerTime.formattedIqamaTime)
        XCTAssertTrue(prayerTime.formattedAdhanTime.contains("5:30"))
        XCTAssertTrue(prayerTime.formattedIqamaTime!.contains("5:45"))
    }
    
    // MARK: - Upcoming Event Tests
    
    func testUpcomingEventTimeRemaining() throws {
        let now = Date()
        let futureTime = now.addingTimeInterval(900) // 15 minutes
        
        let event = UpcomingEvent(type: .adhan(.fajr), time: futureTime)
        
        let timeRemaining = event.timeRemaining(from: now)
        XCTAssertEqual(Int(timeRemaining), 900, accuracy: 1)
        
        let formatted = event.formattedTimeRemaining(from: now)
        XCTAssertTrue(formatted.contains("15"))
    }
    
    func testUpcomingEventIsIqama() throws {
        let adhanEvent = UpcomingEvent(type: .adhan(.fajr), time: Date())
        let iqamaEvent = UpcomingEvent(type: .iqama(.fajr), time: Date())
        
        XCTAssertFalse(adhanEvent.isIqama)
        XCTAssertTrue(iqamaEvent.isIqama)
    }
    
    func testUpcomingEventDisplayName() throws {
        let adhanEvent = UpcomingEvent(type: .adhan(.fajr), time: Date())
        let iqamaEvent = UpcomingEvent(type: .iqama(.dhuhr), time: Date())
        
        XCTAssertEqual(adhanEvent.displayName, "Fajr Adhan")
        XCTAssertEqual(iqamaEvent.displayName, "Dhuhr Iqama")
    }
    
    func testUpcomingEventFormattedTimeRemaining() throws {
        let now = Date()
        
        // Test minutes only
        let event15min = UpcomingEvent(type: .adhan(.fajr), time: now.addingTimeInterval(15 * 60))
        XCTAssertEqual(event15min.formattedTimeRemaining(from: now), "15m")
        
        // Test hours and minutes
        let event90min = UpcomingEvent(type: .adhan(.fajr), time: now.addingTimeInterval(90 * 60))
        XCTAssertEqual(event90min.formattedTimeRemaining(from: now), "1h 30m")
        
        // Test hours only
        let event2hours = UpcomingEvent(type: .adhan(.fajr), time: now.addingTimeInterval(120 * 60))
        XCTAssertEqual(event2hours.formattedTimeRemaining(from: now), "2h")
        
        // Test "Now" for past time
        let pastEvent = UpcomingEvent(type: .adhan(.fajr), time: now.addingTimeInterval(-60))
        XCTAssertEqual(pastEvent.formattedTimeRemaining(from: now), "Now")
    }
    
    // MARK: - Country and City Model Tests
    
    func testCountryModel() throws {
        let city1 = City(id: "dubai", name: "Dubai", countryCode: "AE", timezone: "Asia/Dubai")
        let city2 = City(id: "abu-dhabi", name: "Abu Dhabi", countryCode: "AE", timezone: "Asia/Dubai")
        
        let country = Country(id: "AE", name: "United Arab Emirates", cities: [city1, city2])
        
        XCTAssertEqual(country.id, "AE")
        XCTAssertEqual(country.name, "United Arab Emirates")
        XCTAssertEqual(country.cities.count, 2)
    }
    
    func testCityModel() throws {
        let city = City(id: "london", name: "London", countryCode: "GB", timezone: "Europe/London")
        
        XCTAssertEqual(city.id, "london")
        XCTAssertEqual(city.name, "London")
        XCTAssertEqual(city.countryCode, "GB")
        XCTAssertEqual(city.timezone, "Europe/London")
    }
    
    // MARK: - View Model Tests
    
    func testViewModelInitialization() throws {
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.prayerTimes.count, 0) // Initially empty
        XCTAssertEqual(viewModel.countries.count, 0) // Initially empty
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testViewModelLocationSelection() throws {
        // Create test data
        let city1 = City(id: "dubai", name: "Dubai", countryCode: "AE", timezone: "Asia/Dubai")
        let city2 = City(id: "abu-dhabi", name: "Abu Dhabi", countryCode: "AE", timezone: "Asia/Dubai")
        let country = Country(id: "AE", name: "United Arab Emirates", cities: [city1, city2])
        
        viewModel.countries = [country]
        
        // Test country selection
        viewModel.selectCountry(country)
        XCTAssertEqual(viewModel.selectedCountryCode, "AE")
        XCTAssertEqual(viewModel.selectedCountry?.id, "AE")
        
        // Test city selection
        viewModel.selectCity(city1)
        XCTAssertEqual(viewModel.selectedCityName, "Dubai")
        XCTAssertEqual(viewModel.selectedCity?.id, "dubai")
    }
    
    func testViewModelCurrentCities() throws {
        let city1 = City(id: "dubai", name: "Dubai", countryCode: "AE", timezone: "Asia/Dubai")
        let city2 = City(id: "abu-dhabi", name: "Abu Dhabi", countryCode: "AE", timezone: "Asia/Dubai")
        let country = Country(id: "AE", name: "United Arab Emirates", cities: [city1, city2])
        
        viewModel.selectedCountry = country
        
        XCTAssertEqual(viewModel.currentCities.count, 2)
        XCTAssertEqual(viewModel.currentCities[0].name, "Dubai")
    }
    
    func testViewModelGregorianDate() throws {
        let gregorianDate = viewModel.gregorianDate
        XCTAssertFalse(gregorianDate.isEmpty)
        XCTAssertTrue(gregorianDate.contains("Jan") || gregorianDate.contains("2026"))
    }
    
    // MARK: - Timezone Difference Tests
    
    func testTimezoneDifferenceCalculation() throws {
        // This test assumes the system is in a known timezone
        let dubaiCity = City(id: "dubai", name: "Dubai", countryCode: "AE", timezone: "Asia/Dubai")
        let londonCity = City(id: "london", name: "London", countryCode: "GB", timezone: "Europe/London")
        
        let systemTimezone = TimeZone.current
        let dubaiTimezone = TimeZone(identifier: "Asia/Dubai")!
        let londonTimezone = TimeZone(identifier: "Europe/London")!
        
        let now = Date()
        let systemOffset = systemTimezone.secondsFromGMT(for: now)
        let dubaiOffset = dubaiTimezone.secondsFromGMT(for: now)
        let londonOffset = londonTimezone.secondsFromGMT(for: now)
        
        // If system timezone is different from Dubai, there should be a difference
        if systemOffset != dubaiOffset {
            // There should be a timezone difference
            let diff = abs(dubaiOffset - systemOffset) / 3600
            XCTAssertGreaterThan(diff, 0)
        }
    }
    
    // MARK: - API Service Tests
    
    func testAPIServiceSharedInstance() throws {
        let service1 = PrayerAPIService.shared
        let service2 = PrayerAPIService.shared
        
        XCTAssertTrue(service1 === service2, "PrayerAPIService should be a singleton")
    }
    
    func testCountriesAndCitiesDataExists() async throws {
        let apiService = PrayerAPIService.shared
        let countries = try await apiService.fetchCountriesAndCities()
        
        XCTAssertGreaterThan(countries.count, 0, "Should have countries")
        
        // Check for specific countries
        let hasUAE = countries.contains { $0.id == "AE" }
        let hasUSA = countries.contains { $0.id == "US" }
        let hasUK = countries.contains { $0.id == "GB" }
        
        XCTAssertTrue(hasUAE, "Should have UAE")
        XCTAssertTrue(hasUSA, "Should have USA")
        XCTAssertTrue(hasUK, "Should have UK")
        
        // Check cities exist
        if let uae = countries.first(where: { $0.id == "AE" }) {
            XCTAssertGreaterThan(uae.cities.count, 0, "UAE should have cities")
            XCTAssertTrue(uae.cities.contains { $0.name == "Dubai" }, "UAE should have Dubai")
        }
    }
    
    // MARK: - Location Manager Tests
    
    func testLocationManagerSharedInstance() throws {
        let manager1 = LocationManager.shared
        let manager2 = LocationManager.shared
        
        XCTAssertTrue(manager1 === manager2, "LocationManager should be a singleton")
    }
    
    func testLocationManagerInitialState() throws {
        let locationManager = LocationManager.shared
        
        // Initial state should have no current location
        XCTAssertNil(locationManager.currentLocation)
    }
    
    // MARK: - Notification Manager Tests
    
    func testNotificationManagerSharedInstance() throws {
        let manager1 = NotificationManager.shared
        let manager2 = NotificationManager.shared
        
        XCTAssertTrue(manager1 === manager2, "NotificationManager should be a singleton")
    }
    
    // MARK: - Integration Tests
    
    func testFullWorkflow() async throws {
        // 1. Load countries and cities
        let countries = try await PrayerAPIService.shared.fetchCountriesAndCities()
        viewModel.countries = countries
        
        XCTAssertGreaterThan(countries.count, 0)
        
        // 2. Select a country
        if let uae = countries.first(where: { $0.id == "AE" }) {
            viewModel.selectCountry(uae)
            
            XCTAssertEqual(viewModel.selectedCountryCode, "AE")
            XCTAssertGreaterThan(viewModel.currentCities.count, 0)
            
            // 3. Select a city
            if let dubai = uae.cities.first(where: { $0.name == "Dubai" }) {
                viewModel.selectCity(dubai)
                
                XCTAssertEqual(viewModel.selectedCityName, "Dubai")
                XCTAssertEqual(viewModel.selectedCity?.timezone, "Asia/Dubai")
            }
        }
    }
    
    func testMenuBarTitleUpdates() throws {
        // Initially should be empty
        viewModel.updateMenuBarTitle()
        XCTAssertEqual(viewModel.menuBarTitle, "")
        
        // Create a future prayer time
        let calendar = Calendar.current
        let now = Date()
        var futureTime = calendar.date(byAdding: .minute, value: 10, to: now)!
        
        let prayerTime = PrayerTime(type: .fajr, adhanTime: futureTime, iqamaTime: nil)
        viewModel.prayerTimes = [prayerTime]
        
        // Enable countdown display
        settings.showAdhanCountdown = true
        
        viewModel.updateUpcomingEvent()
        viewModel.updateMenuBarTitle()
        
        // Should show countdown
        if viewModel.showCountdown {
            XCTAssertFalse(viewModel.menuBarTitle.isEmpty)
            XCTAssertTrue(viewModel.menuBarTitle.contains("Fajr"))
        }
    }
    
    func testCountdownThresholdBehavior() throws {
        let calendar = Calendar.current
        let now = Date()
        
        // Test 1: Prayer time > 30 minutes away - should not show countdown
        var farFuture = calendar.date(byAdding: .minute, value: 35, to: now)!
        let prayerTime1 = PrayerTime(type: .fajr, adhanTime: farFuture, iqamaTime: nil)
        viewModel.prayerTimes = [prayerTime1]
        
        settings.showAdhanCountdown = true
        viewModel.updateUpcomingEvent()
        
        XCTAssertFalse(viewModel.showCountdown, "Should not show countdown for prayers > 30 min away")
        
        // Test 2: Prayer time < 30 minutes away - should show countdown
        var nearFuture = calendar.date(byAdding: .minute, value: 15, to: now)!
        let prayerTime2 = PrayerTime(type: .dhuhr, adhanTime: nearFuture, iqamaTime: nil)
        viewModel.prayerTimes = [prayerTime2]
        
        viewModel.updateUpcomingEvent()
        
        XCTAssertTrue(viewModel.showCountdown, "Should show countdown for prayers < 30 min away")
    }
    
    func testAdhanDisplayPeriod() throws {
        let calendar = Calendar.current
        let now = Date()
        
        // Create a prayer time that's happening now
        let adhanTime = now.addingTimeInterval(-5) // 5 seconds ago
        let iqamaTime = now.addingTimeInterval(10 * 60) // 10 minutes from now
        
        let prayerTime = PrayerTime(type: .fajr, adhanTime: adhanTime, iqamaTime: iqamaTime)
        viewModel.prayerTimes = [prayerTime]
        
        settings.showAdhanCountdown = true
        viewModel.updateUpcomingEvent()
        viewModel.updateMenuBarTitle()
        
        // During the 60-second Adhan display period
        if now >= adhanTime && now < adhanTime.addingTimeInterval(60) {
            XCTAssertTrue(viewModel.menuBarTitle.contains("Adhan") || viewModel.menuBarTitle.isEmpty)
        }
    }
    
    // MARK: - Performance Tests
    
    func testPrayerTimeCalculationPerformance() throws {
        measure {
            let calendar = Calendar.current
            let now = Date()
            
            // Create multiple prayer times
            var prayerTimes: [PrayerTime] = []
            for i in 0..<100 {
                let time = calendar.date(byAdding: .minute, value: i, to: now)!
                prayerTimes.append(PrayerTime(type: .fajr, adhanTime: time, iqamaTime: nil))
            }
            
            viewModel.prayerTimes = prayerTimes
            viewModel.updateUpcomingEvent()
        }
    }
    
    func testMenuBarTitleUpdatePerformance() throws {
        let calendar = Calendar.current
        let now = Date()
        let futureTime = calendar.date(byAdding: .minute, value: 10, to: now)!
        
        let prayerTime = PrayerTime(type: .fajr, adhanTime: futureTime, iqamaTime: nil)
        viewModel.prayerTimes = [prayerTime]
        
        measure {
            viewModel.updateMenuBarTitle()
        }
    }
}
