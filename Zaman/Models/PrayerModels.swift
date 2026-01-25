//
//  PrayerModels.swift
//  Zaman
//
//  Created by Danyal Faheem on 25/01/2026.
//

import Foundation

// MARK: - App Models
struct Country: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    
    var cities: [City] = []
}

struct City: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let countryCode: String
    let timezone: String
    
    init(id: String, name: String, countryCode: String, timezone: String) {
        self.id = id
        self.name = name
        self.countryCode = countryCode
        self.timezone = timezone
    }
}

// MARK: - Aladhan API Response
struct AladhanResponse: Codable {
    let code: Int
    let status: String
    let data: AladhanData
}

struct AladhanData: Codable {
    let timings: AladhanTimings
    let date: AladhanDate
}

struct AladhanDate: Codable {
    let hijri: HijriDate
}

struct HijriDate: Codable {
    let date: String
    let format: String?
    let day: String
    let month: HijriMonth
    let year: String
}

struct HijriMonth: Codable {
    let number: Int
    let en: String
    let ar: String
}

struct AladhanTimings: Codable {
    let Fajr: String
    let Sunrise: String
    let Dhuhr: String
    let Asr: String
    let Maghrib: String
    let Isha: String
}

// MARK: - Prayer Type Enum
enum PrayerType: String, CaseIterable, Identifiable {
    case fajr = "Fajr"
    case sunrise = "Sunrise"
    case dhuhr = "Dhuhr"
    case asr = "Asr"
    case maghrib = "Maghrib"
    case isha = "Isha"
    
    var id: String { rawValue }
    
    var arabicName: String {
        switch self {
        case .fajr: return "الفجر"
        case .sunrise: return "الشروق"
        case .dhuhr: return "الظهر"
        case .asr: return "العصر"
        case .maghrib: return "المغرب"
        case .isha: return "العشاء"
        }
    }
    
    var icon: String {
        switch self {
        case .fajr: return "sunrise.fill"
        case .sunrise: return "sun.horizon.fill"
        case .dhuhr: return "sun.max.fill"
        case .asr: return "sun.min.fill"
        case .maghrib: return "sunset.fill"
        case .isha: return "moon.stars.fill"
        }
    }
    
    var color: String {
        switch self {
        case .fajr: return "FajrColor"
        case .sunrise: return "SunriseColor"
        case .dhuhr: return "DhuhrColor"
        case .asr: return "AsrColor"
        case .maghrib: return "MaghribColor"
        case .isha: return "IshaColor"
        }
    }
    
    var hasIqama: Bool {
        self != .sunrise
    }
}

// MARK: - Prayer Time Model
struct PrayerTime: Identifiable {
    let id = UUID()
    let type: PrayerType
    let adhanTime: Date
    let iqamaTime: Date?
    
    var formattedAdhanTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: adhanTime)
    }
    
    var formattedIqamaTime: String? {
        guard let iqamaTime = iqamaTime else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: iqamaTime)
    }
}

// MARK: - Upcoming Event
struct UpcomingEvent {
    enum EventType {
        case adhan(PrayerType)
        case iqama(PrayerType)
    }
    
    let type: EventType
    let time: Date
    
    var displayName: String {
        switch type {
        case .adhan(let prayer):
            return "\(prayer.rawValue) Adhan"
        case .iqama(let prayer):
            return "\(prayer.rawValue) Iqama"
        }
    }
    
    var prayerType: PrayerType {
        switch type {
        case .adhan(let prayer), .iqama(let prayer):
            return prayer
        }
    }
    
    var isIqama: Bool {
        if case .iqama = type {
            return true
        }
        return false
    }
    
    func timeRemaining(from now: Date = Date()) -> TimeInterval {
        return time.timeIntervalSince(now)
    }
    
    func formattedTimeRemaining(from now: Date = Date()) -> String {
        let remaining = timeRemaining(from: now)
        if remaining <= 0 {
            return "Now"
        }
        
        let totalMinutes = Int(remaining) / 60
        
        if totalMinutes >= 60 {
            let hours = totalMinutes / 60
            let mins = totalMinutes % 60
            if mins == 0 {
                return String(format: "%dh", hours)
            }
            return String(format: "%dh %dm", hours, mins)
        } else {
            return String(format: "%dm", totalMinutes)
        }
    }
}
