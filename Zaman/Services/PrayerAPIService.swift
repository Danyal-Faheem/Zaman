//
//  PrayerAPIService.swift
//  Zaman
//
//  Created by Danyal Faheem on 25/01/2026.
//

import Foundation
import Combine

enum APIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case noData
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to parse data: \(error.localizedDescription)"
        case .noData:
            return "No data received"
        case .serverError(let code):
            return "Server error with code: \(code)"
        }
    }
}

class PrayerAPIService: ObservableObject {
    static let shared = PrayerAPIService()
    
    private let baseURL = "https://api.aladhan.com/v1"
    
    @Published var countries: [Country] = []
    @Published var isLoading = false
    @Published var error: APIError?
    
    private init() {}
    
    // MARK: - Fetch Countries and Cities
    func fetchCountriesAndCities() async throws -> [Country] {
        // For simplicity, we'll use a predefined list of common countries
        // Aladhan doesn't have a dedicated endpoint for listing all countries/cities
        // So we'll provide a curated list of countries with major cities
        let countries = getCountriesWithCities()
        
        await MainActor.run {
            self.countries = countries
        }
        
        return countries
    }
    
    // getCountriesWithCities() is now in CitiesData.swift extension
    
    // MARK: - Fetch Prayer Times
    func fetchPrayerTimes(cityName: String, countryCode: String, date: Date = Date()) async throws -> (prayerTimes: [PrayerTime], hijriDate: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: date)
        
        // URL encode the city name
        let encodedCity = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cityName
        
        guard let url = URL(string: "\(baseURL)/timingsByCity/\(dateString)?city=\(encodedCity)&country=\(countryCode)") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.noData
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(AladhanResponse.self, from: data)
        
        let prayerTimes = parseAladhanTimes(from: result.data.timings, date: date)
        let hijriDate = formatHijriDate(result.data.date.hijri)
        
        return (prayerTimes, hijriDate)
    }
    
    private func formatHijriDate(_ hijri: HijriDate) -> String {
        return "\(hijri.day) \(hijri.month.en) \(hijri.year)H"
    }
    
    private func parseAladhanTimes(from timings: AladhanTimings, date: Date) -> [PrayerTime] {
        var prayerTimes: [PrayerTime] = []
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        // Standard Iqama offsets (in minutes)
        let iqamaOffsets: [PrayerType: Int] = [
            .fajr: 25,
            .dhuhr: 20,
            .asr: 20,
            .maghrib: 5,
            .isha: 20
        ]
        
        let prayers: [(PrayerType, String)] = [
            (.fajr, timings.Fajr),
            (.sunrise, timings.Sunrise),
            (.dhuhr, timings.Dhuhr),
            (.asr, timings.Asr),
            (.maghrib, timings.Maghrib),
            (.isha, timings.Isha)
        ]
        
        for (type, timeString) in prayers {
            if let adhanTime = parseTime(timeString, dateComponents: dateComponents) {
                var iqamaTime: Date? = nil
                if let offset = iqamaOffsets[type] {
                    iqamaTime = calendar.date(byAdding: .minute, value: offset, to: adhanTime)
                }
                prayerTimes.append(PrayerTime(type: type, adhanTime: adhanTime, iqamaTime: iqamaTime))
            }
        }
        
        return prayerTimes
    }
    
    private func parseTime(_ timeString: String, dateComponents: DateComponents) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        // Remove any timezone info or extra characters
        let cleanedTime = timeString.components(separatedBy: " ")[0]
        
        if let time = formatter.date(from: cleanedTime) {
            var components = dateComponents
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
            components.hour = timeComponents.hour
            components.minute = timeComponents.minute
            return Calendar.current.date(from: components)
        }
        
        return nil
    }
}
