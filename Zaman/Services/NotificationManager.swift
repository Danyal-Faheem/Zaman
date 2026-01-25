//
//  NotificationManager.swift
//  Zaman
//
//  Created by Danyal Faheem on 25/01/2026.
//

import Foundation
import Combine
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    
    private init() {
        checkAuthorization()
    }
    
    // MARK: - Authorization
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            await MainActor.run {
                self.isAuthorized = granted
            }
            return granted
        } catch {
            print("Notification authorization error: \(error)")
            return false
        }
    }
    
    func checkAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // MARK: - Schedule Notifications
    func scheduleNotifications(for prayerTimes: [PrayerTime], settings: SettingsManager) {
        // Remove all pending notifications first
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        guard isAuthorized else { return }
        
        for prayerTime in prayerTimes {
            // Skip sunrise as it's not a prayer
            if prayerTime.type == .sunrise { continue }
            
            // Schedule Adhan notification
            if settings.adhanNotificationsEnabled {
                scheduleNotification(
                    for: prayerTime.type,
                    at: prayerTime.adhanTime,
                    isIqama: false
                )
            }
            
            // Schedule Iqama notification
            if settings.iqamaNotificationsEnabled, let iqamaTime = prayerTime.iqamaTime {
                scheduleNotification(
                    for: prayerTime.type,
                    at: iqamaTime,
                    isIqama: true
                )
            }
        }
    }
    
    private func scheduleNotification(for prayer: PrayerType, at time: Date, isIqama: Bool) {
        // Don't schedule if time has passed
        guard time > Date() else { return }
        
        let content = UNMutableNotificationContent()
        
        if isIqama {
            content.title = "\(prayer.rawValue) Iqama"
            content.body = "It's time for \(prayer.rawValue) Iqama"
        } else {
            content.title = "\(prayer.rawValue) Adhan"
            content.body = "It's time for \(prayer.rawValue) prayer"
        }
        
        content.sound = .default
        content.categoryIdentifier = "PRAYER_TIME"
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let identifier = isIqama ? "\(prayer.rawValue)-iqama" : "\(prayer.rawValue)-adhan"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
    
    // MARK: - Remove All Notifications
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}

