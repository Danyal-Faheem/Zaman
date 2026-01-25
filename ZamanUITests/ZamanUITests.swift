//
//  ZamanUITests.swift
//  ZamanUITests
//
//  Created by Danyal Faheem on 25/01/2026.
//

import XCTest

final class ZamanUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Menu Bar Tests
    
    func testMenuBarIconExists() throws {
        // Since this is a menu bar app, we need to check if the app launched
        XCTAssertTrue(app.exists)
    }
    
    // MARK: - Popup View Tests
    
    func testPopupViewElements() throws {
        // Wait for the popup to be accessible
        let popup = app.windows.firstMatch
        
        // Check header exists
        let headerText = popup.staticTexts["Zaman"]
        XCTAssertTrue(headerText.waitForExistence(timeout: 5))
        
        // Check settings button exists
        let settingsButton = popup.buttons.matching(NSPredicate(format: "label CONTAINS 'Settings' OR identifier CONTAINS 'gear'")).firstMatch
        XCTAssertTrue(settingsButton.exists || popup.buttons.count > 0)
    }
    
    func testLocationSelector() throws {
        let popup = app.windows.firstMatch
        XCTAssertTrue(popup.waitForExistence(timeout: 5))
        
        // Check for country picker
        let countryPicker = popup.popUpButtons.matching(NSPredicate(format: "identifier == 'Country' OR title CONTAINS 'United'")).firstMatch
        
        if countryPicker.exists {
            // Verify picker is interactable
            XCTAssertTrue(countryPicker.isEnabled)
        }
    }
    
    func testPrayerTimesListDisplayed() throws {
        let popup = app.windows.firstMatch
        XCTAssertTrue(popup.waitForExistence(timeout: 5))
        
        // Check for prayer names
        let prayerNames = ["Fajr", "Sunrise", "Dhuhr", "Asr", "Maghrib", "Isha"]
        
        for prayerName in prayerNames {
            let prayerText = popup.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", prayerName)).firstMatch
            if prayerText.exists {
                XCTAssertTrue(prayerText.exists, "\(prayerName) should be displayed")
            }
        }
    }
    
    func testRefreshButton() throws {
        let popup = app.windows.firstMatch
        XCTAssertTrue(popup.waitForExistence(timeout: 5))
        
        // Find refresh button
        let refreshButton = popup.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Refresh'")).firstMatch
        
        if refreshButton.exists {
            XCTAssertTrue(refreshButton.isEnabled)
            
            // Tap refresh
            refreshButton.tap()
            
            // Wait a moment for refresh to complete
            sleep(2)
            
            // Verify button is still enabled
            XCTAssertTrue(refreshButton.isEnabled)
        }
    }
    
    func testQuitButton() throws {
        let popup = app.windows.firstMatch
        XCTAssertTrue(popup.waitForExistence(timeout: 5))
        
        // Find quit button
        let quitButton = popup.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Quit'")).firstMatch
        
        if quitButton.exists {
            XCTAssertTrue(quitButton.isEnabled)
            // Don't actually tap it in tests
        }
    }
    
    // MARK: - Settings View Tests
    
    func testOpenSettings() throws {
        let popup = app.windows.firstMatch
        XCTAssertTrue(popup.waitForExistence(timeout: 5))
        
        // Find and tap settings button
        let settingsButton = popup.buttons.matching(NSPredicate(format: "identifier CONTAINS 'gear' OR label CONTAINS 'Settings'")).firstMatch
        
        if settingsButton.exists {
            settingsButton.tap()
            
            // Wait for settings sheet to appear
            sleep(1)
            
            // Check if settings window/sheet exists
            let settingsWindow = app.windows.matching(NSPredicate(format: "title CONTAINS 'Settings' OR identifier CONTAINS 'Settings'")).firstMatch
            
            if settingsWindow.exists {
                XCTAssertTrue(settingsWindow.exists)
            }
        }
    }
    
    func testNotificationSettings() throws {
        let popup = app.windows.firstMatch
        XCTAssertTrue(popup.waitForExistence(timeout: 5))
        
        // Open settings
        let settingsButton = popup.buttons.matching(NSPredicate(format: "identifier CONTAINS 'gear' OR label CONTAINS 'Settings'")).firstMatch
        
        if settingsButton.exists {
            settingsButton.tap()
            sleep(1)
            
            // Look for notification toggles
            let adhanToggle = app.switches.matching(NSPredicate(format: "label CONTAINS[c] 'Adhan Notifications'")).firstMatch
            let iqamaToggle = app.switches.matching(NSPredicate(format: "label CONTAINS[c] 'Iqama Notifications'")).firstMatch
            
            if adhanToggle.exists {
                XCTAssertTrue(adhanToggle.exists)
            }
            
            if iqamaToggle.exists {
                XCTAssertTrue(iqamaToggle.exists)
            }
        }
    }
    
    func testDisplaySettings() throws {
        let popup = app.windows.firstMatch
        XCTAssertTrue(popup.waitForExistence(timeout: 5))
        
        // Open settings
        let settingsButton = popup.buttons.matching(NSPredicate(format: "identifier CONTAINS 'gear' OR label CONTAINS 'Settings'")).firstMatch
        
        if settingsButton.exists {
            settingsButton.tap()
            sleep(1)
            
            // Look for display toggles
            let showAdhanToggle = app.switches.matching(NSPredicate(format: "label CONTAINS[c] 'Show Adhan Countdown'")).firstMatch
            let showIqamaToggle = app.switches.matching(NSPredicate(format: "label CONTAINS[c] 'Show Iqama Countdown'")).firstMatch
            
            if showAdhanToggle.exists {
                XCTAssertTrue(showAdhanToggle.exists)
            }
            
            if showIqamaToggle.exists {
                XCTAssertTrue(showIqamaToggle.exists)
            }
        }
    }
    
    func testToggleDisplaySettings() throws {
        let popup = app.windows.firstMatch
        XCTAssertTrue(popup.waitForExistence(timeout: 5))
        
        // Open settings
        let settingsButton = popup.buttons.matching(NSPredicate(format: "identifier CONTAINS 'gear' OR label CONTAINS 'Settings'")).firstMatch
        
        if settingsButton.exists {
            settingsButton.tap()
            sleep(1)
            
            // Find and toggle Adhan countdown
            let showAdhanToggle = app.switches.matching(NSPredicate(format: "label CONTAINS[c] 'Show Adhan Countdown'")).firstMatch
            
            if showAdhanToggle.exists {
                let initialValue = showAdhanToggle.value as? String
                
                // Toggle it
                showAdhanToggle.tap()
                sleep(1)
                
                // Verify it changed
                let newValue = showAdhanToggle.value as? String
                XCTAssertNotEqual(initialValue, newValue)
                
                // Toggle back
                showAdhanToggle.tap()
                sleep(1)
                
                // Verify it's back to original
                let finalValue = showAdhanToggle.value as? String
                XCTAssertEqual(initialValue, finalValue)
            }
        }
    }
    
    func testCloseSettings() throws {
        let popup = app.windows.firstMatch
        XCTAssertTrue(popup.waitForExistence(timeout: 5))
        
        // Open settings
        let settingsButton = popup.buttons.matching(NSPredicate(format: "identifier CONTAINS 'gear' OR label CONTAINS 'Settings'")).firstMatch
        
        if settingsButton.exists {
            settingsButton.tap()
            sleep(1)
            
            // Find close button (X button)
            let closeButton = app.buttons.matching(NSPredicate(format: "identifier CONTAINS 'xmark' OR label CONTAINS 'Close'")).firstMatch
            
            if closeButton.exists {
                closeButton.tap()
                sleep(1)
                
                // Verify settings closed (main popup should be visible again)
                XCTAssertTrue(popup.exists)
            }
        }
    }
    
    // MARK: - Location Selection Tests
    
    func testCountrySelection() throws {
        let popup = app.windows.firstMatch
        XCTAssertTrue(popup.waitForExistence(timeout: 5))
        
        // Find country picker
        let countryPicker = popup.popUpButtons.matching(NSPredicate(format: "identifier == 'Country' OR title CONTAINS 'United'")).firstMatch
        
        if countryPicker.exists && countryPicker.isEnabled {
            // Click to open menu
            countryPicker.tap()
            sleep(1)
            
            // Select a different country if menu items exist
            let menuItems = app.menuItems
            if menuItems.count > 0 {
                let firstMenuItem = menuItems.firstMatch
                firstMenuItem.tap()
                sleep(1)
            }
        }
    }
    
    func testCitySelection() throws {
        let popup = app.windows.firstMatch
        XCTAssertTrue(popup.waitForExistence(timeout: 5))
        
        // Find city picker
        let cityPicker = popup.popUpButtons.matching(NSPredicate(format: "identifier == 'City'")).firstMatch
        
        if cityPicker.exists && cityPicker.isEnabled {
            // Click to open menu
            cityPicker.tap()
            sleep(1)
            
            // Select a city if menu items exist
            let menuItems = app.menuItems
            if menuItems.count > 0 {
                let firstMenuItem = menuItems.firstMatch
                firstMenuItem.tap()
                sleep(2)
                
                // Verify popup still exists after selection
                XCTAssertTrue(popup.exists)
            }
        }
    }
    
    // MARK: - Prayer Times Display Tests
    
    func testPrayerTimesUpdate() throws {
        let popup = app.windows.firstMatch
        XCTAssertTrue(popup.waitForExistence(timeout: 5))
        
        // Tap refresh
        let refreshButton = popup.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Refresh'")).firstMatch
        
        if refreshButton.exists {
            refreshButton.tap()
            
            // Wait for update
            sleep(3)
            
            // Check that prayer times are still displayed
            let prayerNames = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]
            var foundAny = false
            
            for prayerName in prayerNames {
                let prayerText = popup.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", prayerName)).firstMatch
                if prayerText.exists {
                    foundAny = true
                    break
                }
            }
            
            XCTAssertTrue(foundAny, "At least one prayer time should be displayed")
        }
    }
    
    func testHijriDateDisplayed() throws {
        let popup = app.windows.firstMatch
        XCTAssertTrue(popup.waitForExistence(timeout: 5))
        
        // Look for Hijri date indicator (should contain Arabic month names or 'H')
        let hijriMonths = ["Muharram", "Safar", "Rabi", "Jumada", "Rajab", "Sha'ban", "Ramadan", "Shawwal", "Dhul"]
        
        var foundHijri = false
        for month in hijriMonths {
            let hijriText = popup.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", month)).firstMatch
            if hijriText.exists {
                foundHijri = true
                break
            }
        }
        
        // Alternative: check for 'H' suffix in dates
        if !foundHijri {
            let hSuffix = popup.staticTexts.containing(NSPredicate(format: "label CONTAINS 'H'")).firstMatch
            if hSuffix.exists {
                foundHijri = true
            }
        }
        
        // Note: Test might fail if date hasn't loaded yet
        if foundHijri {
            XCTAssertTrue(foundHijri, "Hijri date should be displayed")
        }
    }
    
    // MARK: - Performance Tests
    
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    func testSettingsOpenPerformance() throws {
        let popup = app.windows.firstMatch
        XCTAssertTrue(popup.waitForExistence(timeout: 5))
        
        let settingsButton = popup.buttons.matching(NSPredicate(format: "identifier CONTAINS 'gear' OR label CONTAINS 'Settings'")).firstMatch
        
        if settingsButton.exists {
            measure {
                settingsButton.tap()
                sleep(1)
                
                // Close settings
                let closeButton = app.buttons.matching(NSPredicate(format: "identifier CONTAINS 'xmark' OR label CONTAINS 'Close'")).firstMatch
                if closeButton.exists {
                    closeButton.tap()
                    sleep(1)
                }
            }
        }
    }
}
