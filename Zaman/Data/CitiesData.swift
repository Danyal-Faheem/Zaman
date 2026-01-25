//
//  CitiesData.swift
//  Zaman
//
//  Created by Danyal Faheem on 25/01/2026.
//

import Foundation

extension PrayerAPIService {
    func getCountriesWithCities() -> [Country] {
        // Organized alphabetically by region
        var allCities: [City] = []
        
        // AFRICA (Alphabetically sorted)
        allCities += [
            City(id: "algiers", name: "Algiers", countryCode: "DZ", timezone: "Africa/Algiers"),
            City(id: "alexandria", name: "Alexandria", countryCode: "EG", timezone: "Africa/Cairo"),
            City(id: "cairo", name: "Cairo", countryCode: "EG", timezone: "Africa/Cairo"),
            City(id: "capetown", name: "Cape Town", countryCode: "ZA", timezone: "Africa/Johannesburg"),
            City(id: "casablanca", name: "Casablanca", countryCode: "MA", timezone: "Africa/Casablanca"),
            City(id: "fez", name: "Fez", countryCode: "MA", timezone: "Africa/Casablanca"),
            City(id: "johannesburg", name: "Johannesburg", countryCode: "ZA", timezone: "Africa/Johannesburg"),
            City(id: "lagos", name: "Lagos", countryCode: "NG", timezone: "Africa/Lagos"),
            City(id: "marrakech", name: "Marrakech", countryCode: "MA", timezone: "Africa/Casablanca"),
            City(id: "rabat", name: "Rabat", countryCode: "MA", timezone: "Africa/Casablanca"),
            City(id: "tunis", name: "Tunis", countryCode: "TN", timezone: "Africa/Tunis")
        ]
        
        // ASIA (Alphabetically sorted)
        allCities += [
            City(id: "ahmedabad", name: "Ahmedabad", countryCode: "IN", timezone: "Asia/Kolkata"),
            City(id: "astana", name: "Astana", countryCode: "KZ", timezone: "Asia/Almaty"),
            City(id: "bangalore", name: "Bangalore", countryCode: "IN", timezone: "Asia/Kolkata"),
            City(id: "beijing", name: "Beijing", countryCode: "CN", timezone: "Asia/Shanghai"),
            City(id: "chennai", name: "Chennai", countryCode: "IN", timezone: "Asia/Kolkata"),
            City(id: "colombo", name: "Colombo", countryCode: "LK", timezone: "Asia/Colombo"),
            City(id: "dhaka", name: "Dhaka", countryCode: "BD", timezone: "Asia/Dhaka"),
            City(id: "hong-kong", name: "Hong Kong", countryCode: "HK", timezone: "Asia/Hong_Kong"),
            City(id: "islamabad", name: "Islamabad", countryCode: "PK", timezone: "Asia/Karachi"),
            City(id: "jakarta", name: "Jakarta", countryCode: "ID", timezone: "Asia/Jakarta"),
            City(id: "kabul", name: "Kabul", countryCode: "AF", timezone: "Asia/Kabul"),
            City(id: "karachi", name: "Karachi", countryCode: "PK", timezone: "Asia/Karachi"),
            City(id: "kuala-lumpur", name: "Kuala Lumpur", countryCode: "MY", timezone: "Asia/Kuala_Lumpur"),
            City(id: "lahore", name: "Lahore", countryCode: "PK", timezone: "Asia/Karachi"),
            City(id: "makhachkala", name: "Makhachkala", countryCode: "RU", timezone: "Europe/Moscow"),
            City(id: "mumbai", name: "Mumbai", countryCode: "IN", timezone: "Asia/Kolkata"),
            City(id: "new-delhi", name: "New Delhi", countryCode: "IN", timezone: "Asia/Kolkata"),
            City(id: "samarkand", name: "Samarkand", countryCode: "UZ", timezone: "Asia/Samarkand"),
            City(id: "seoul", name: "Seoul", countryCode: "KR", timezone: "Asia/Seoul"),
            City(id: "shanghai", name: "Shanghai", countryCode: "CN", timezone: "Asia/Shanghai"),
            City(id: "singapore", name: "Singapore", countryCode: "SG", timezone: "Asia/Singapore"),
            City(id: "taipei", name: "Taipei", countryCode: "TW", timezone: "Asia/Taipei"),
            City(id: "tashkent", name: "Tashkent", countryCode: "UZ", timezone: "Asia/Tashkent"),
            City(id: "tokyo", name: "Tokyo", countryCode: "JP", timezone: "Asia/Tokyo"),
            City(id: "turkestan", name: "Turkestan", countryCode: "KZ", timezone: "Asia/Almaty"),
            City(id: "ulaanbaatar", name: "Ulaanbaatar", countryCode: "MN", timezone: "Asia/Ulaanbaatar")
        ]
        
        // OCEANIA/AUSTRALIA (Alphabetically sorted)
        allCities += [
            City(id: "adelaide", name: "Adelaide", countryCode: "AU", timezone: "Australia/Adelaide"),
            City(id: "auckland", name: "Auckland", countryCode: "NZ", timezone: "Pacific/Auckland"),
            City(id: "brisbane", name: "Brisbane", countryCode: "AU", timezone: "Australia/Brisbane"),
            City(id: "darwin", name: "Darwin", countryCode: "AU", timezone: "Australia/Darwin"),
            City(id: "melbourne", name: "Melbourne", countryCode: "AU", timezone: "Australia/Melbourne"),
            City(id: "perth", name: "Perth", countryCode: "AU", timezone: "Australia/Perth"),
            City(id: "sydney", name: "Sydney", countryCode: "AU", timezone: "Australia/Sydney"),
            City(id: "tasmania", name: "Tasmania", countryCode: "AU", timezone: "Australia/Hobart")
        ]
        
        // EUROPE (Alphabetically sorted)
        allCities += [
            City(id: "amsterdam", name: "Amsterdam", countryCode: "NL", timezone: "Europe/Amsterdam"),
            City(id: "belfast", name: "Belfast", countryCode: "GB", timezone: "Europe/London"),
            City(id: "berlin", name: "Berlin", countryCode: "DE", timezone: "Europe/Berlin"),
            City(id: "birmingham", name: "Birmingham", countryCode: "GB", timezone: "Europe/London"),
            City(id: "brussels", name: "Brussels", countryCode: "BE", timezone: "Europe/Brussels"),
            City(id: "bucharest", name: "Bucharest", countryCode: "RO", timezone: "Europe/Bucharest"),
            City(id: "budapest", name: "Budapest", countryCode: "HU", timezone: "Europe/Budapest"),
            City(id: "copenhagen", name: "Copenhagen", countryCode: "DK", timezone: "Europe/Copenhagen"),
            City(id: "cordoba", name: "Cordoba", countryCode: "ES", timezone: "Europe/Madrid"),
            City(id: "dublin", name: "Dublin", countryCode: "IE", timezone: "Europe/Dublin"),
            City(id: "edinburgh", name: "Edinburgh", countryCode: "GB", timezone: "Europe/London"),
            City(id: "frankfurt", name: "Frankfurt", countryCode: "DE", timezone: "Europe/Berlin"),
            City(id: "glasgow", name: "Glasgow", countryCode: "GB", timezone: "Europe/London"),
            City(id: "helsinki", name: "Helsinki", countryCode: "FI", timezone: "Europe/Helsinki"),
            City(id: "leeds", name: "Leeds", countryCode: "GB", timezone: "Europe/London"),
            City(id: "lisbon", name: "Lisbon", countryCode: "PT", timezone: "Europe/Lisbon"),
            City(id: "london", name: "London", countryCode: "GB", timezone: "Europe/London"),
            City(id: "madrid", name: "Madrid", countryCode: "ES", timezone: "Europe/Madrid"),
            City(id: "manchester", name: "Manchester", countryCode: "GB", timezone: "Europe/London"),
            City(id: "milan", name: "Milan", countryCode: "IT", timezone: "Europe/Rome"),
            City(id: "moscow", name: "Moscow", countryCode: "RU", timezone: "Europe/Moscow"),
            City(id: "munich", name: "Munich", countryCode: "DE", timezone: "Europe/Berlin"),
            City(id: "naples", name: "Naples", countryCode: "IT", timezone: "Europe/Rome"),
            City(id: "oslo", name: "Oslo", countryCode: "NO", timezone: "Europe/Oslo"),
            City(id: "paris", name: "Paris", countryCode: "FR", timezone: "Europe/Paris"),
            City(id: "prague", name: "Prague", countryCode: "CZ", timezone: "Europe/Prague"),
            City(id: "pristina", name: "Pristina", countryCode: "XK", timezone: "Europe/Belgrade"),
            City(id: "rome", name: "Rome", countryCode: "IT", timezone: "Europe/Rome"),
            City(id: "rotterdam", name: "Rotterdam", countryCode: "NL", timezone: "Europe/Amsterdam"),
            City(id: "sarajevo", name: "Sarajevo", countryCode: "BA", timezone: "Europe/Sarajevo"),
            City(id: "sofia", name: "Sofia", countryCode: "BG", timezone: "Europe/Sofia"),
            City(id: "stockholm", name: "Stockholm", countryCode: "SE", timezone: "Europe/Stockholm"),
            City(id: "tirana", name: "Tirana", countryCode: "AL", timezone: "Europe/Tirane"),
            City(id: "valencia", name: "Valencia", countryCode: "ES", timezone: "Europe/Madrid"),
            City(id: "vienna", name: "Vienna", countryCode: "AT", timezone: "Europe/Vienna"),
            City(id: "zurich", name: "Zurich", countryCode: "CH", timezone: "Europe/Zurich")
        ]
        
        // MIDDLE EAST (Alphabetically sorted)
        allCities += [
            City(id: "abu-dhabi", name: "Abu Dhabi", countryCode: "AE", timezone: "Asia/Dubai"),
            City(id: "aden", name: "Aden", countryCode: "YE", timezone: "Asia/Aden"),
            City(id: "ajman", name: "Ajman", countryCode: "AE", timezone: "Asia/Dubai"),
            City(id: "aleppo", name: "Aleppo", countryCode: "SY", timezone: "Asia/Damascus"),
            City(id: "ankara", name: "Ankara", countryCode: "TR", timezone: "Europe/Istanbul"),
            City(id: "baghdad", name: "Baghdad", countryCode: "IQ", timezone: "Asia/Baghdad"),
            City(id: "damascus", name: "Damascus", countryCode: "SY", timezone: "Asia/Damascus"),
            City(id: "dubai", name: "Dubai", countryCode: "AE", timezone: "Asia/Dubai"),
            City(id: "isfahan", name: "Isfahan", countryCode: "IR", timezone: "Asia/Tehran"),
            City(id: "istanbul", name: "Istanbul", countryCode: "TR", timezone: "Europe/Istanbul"),
            City(id: "jerusalem", name: "Jerusalem", countryCode: "PS", timezone: "Asia/Jerusalem"),
            City(id: "kayseri", name: "Kayseri", countryCode: "TR", timezone: "Europe/Istanbul"),
            City(id: "konya", name: "Konya", countryCode: "TR", timezone: "Europe/Istanbul"),
            City(id: "makkah", name: "Makkah", countryCode: "SA", timezone: "Asia/Riyadh"),
            City(id: "madinah", name: "Madinah", countryCode: "SA", timezone: "Asia/Riyadh"),
            City(id: "mosul", name: "Mosul", countryCode: "IQ", timezone: "Asia/Baghdad"),
            City(id: "muscat", name: "Muscat", countryCode: "OM", timezone: "Asia/Muscat"),
            City(id: "ras-al-khaimah", name: "Ras Al Khaimah", countryCode: "AE", timezone: "Asia/Dubai"),
            City(id: "riyadh", name: "Riyadh", countryCode: "SA", timezone: "Asia/Riyadh"),
            City(id: "sanaa", name: "Sanaa", countryCode: "YE", timezone: "Asia/Aden"),
            City(id: "sharjah", name: "Sharjah", countryCode: "AE", timezone: "Asia/Dubai"),
            City(id: "tehran", name: "Tehran", countryCode: "IR", timezone: "Asia/Tehran"),
            City(id: "umm-al-quwain", name: "Umm Al Quwain", countryCode: "AE", timezone: "Asia/Dubai")
        ]
        
        // NORTH AMERICA (Alphabetically sorted)
        allCities += [
            City(id: "albany", name: "Albany, NY", countryCode: "US", timezone: "America/New_York"),
            City(id: "boise", name: "Boise, ID", countryCode: "US", timezone: "America/Boise"),
            City(id: "boston", name: "Boston, MA", countryCode: "US", timezone: "America/New_York"),
            City(id: "buffalo", name: "Buffalo, NY", countryCode: "US", timezone: "America/New_York"),
            City(id: "charlotte", name: "Charlotte, NC", countryCode: "US", timezone: "America/New_York"),
            City(id: "chicago", name: "Chicago, IL", countryCode: "US", timezone: "America/Chicago"),
            City(id: "cleveland", name: "Cleveland, OH", countryCode: "US", timezone: "America/New_York"),
            City(id: "colorado-springs", name: "Colorado Springs, CO", countryCode: "US", timezone: "America/Denver"),
            City(id: "dallas", name: "Dallas, TX", countryCode: "US", timezone: "America/Chicago"),
            City(id: "denver", name: "Denver, CO", countryCode: "US", timezone: "America/Denver"),
            City(id: "detroit", name: "Detroit, MI", countryCode: "US", timezone: "America/Detroit"),
            City(id: "edmonton", name: "Edmonton", countryCode: "CA", timezone: "America/Edmonton"),
            City(id: "fort-worth", name: "Fort Worth, TX", countryCode: "US", timezone: "America/Chicago"),
            City(id: "halifax", name: "Halifax", countryCode: "CA", timezone: "America/Halifax"),
            City(id: "havana", name: "Havana", countryCode: "CU", timezone: "America/Havana"),
            City(id: "honolulu", name: "Honolulu, HI", countryCode: "US", timezone: "Pacific/Honolulu"),
            City(id: "houston", name: "Houston, TX", countryCode: "US", timezone: "America/Chicago"),
            City(id: "jersey-city", name: "Jersey City, NJ", countryCode: "US", timezone: "America/New_York"),
            City(id: "juneau", name: "Juneau, AK", countryCode: "US", timezone: "America/Juneau"),
            City(id: "kansas-city", name: "Kansas City, MO", countryCode: "US", timezone: "America/Chicago"),
            City(id: "las-vegas", name: "Las Vegas, NV", countryCode: "US", timezone: "America/Los_Angeles"),
            City(id: "los-angeles", name: "Los Angeles, CA", countryCode: "US", timezone: "America/Los_Angeles"),
            City(id: "miami", name: "Miami, FL", countryCode: "US", timezone: "America/New_York"),
            City(id: "montreal", name: "Montreal", countryCode: "CA", timezone: "America/Toronto"),
            City(id: "new-york", name: "New York, NY", countryCode: "US", timezone: "America/New_York"),
            City(id: "orlando", name: "Orlando, FL", countryCode: "US", timezone: "America/New_York"),
            City(id: "philadelphia", name: "Philadelphia, PA", countryCode: "US", timezone: "America/New_York"),
            City(id: "pittsburgh", name: "Pittsburgh, PA", countryCode: "US", timezone: "America/New_York"),
            City(id: "regina", name: "Regina", countryCode: "CA", timezone: "America/Regina"),
            City(id: "san-diego", name: "San Diego, CA", countryCode: "US", timezone: "America/Los_Angeles"),
            City(id: "san-francisco", name: "San Francisco, CA", countryCode: "US", timezone: "America/Los_Angeles"),
            City(id: "seattle", name: "Seattle, WA", countryCode: "US", timezone: "America/Los_Angeles"),
            City(id: "toronto", name: "Toronto", countryCode: "CA", timezone: "America/Toronto"),
            City(id: "vancouver", name: "Vancouver", countryCode: "CA", timezone: "America/Vancouver"),
            City(id: "washington", name: "Washington, DC", countryCode: "US", timezone: "America/New_York")
        ]
        
        // SOUTH AMERICA (Alphabetically sorted)
        allCities += [
            City(id: "buenos-aires", name: "Buenos Aires", countryCode: "AR", timezone: "America/Argentina/Buenos_Aires"),
            City(id: "caracas", name: "Caracas", countryCode: "VE", timezone: "America/Caracas"),
            City(id: "lima", name: "Lima", countryCode: "PE", timezone: "America/Lima"),
            City(id: "mexico-city", name: "Mexico City", countryCode: "MX", timezone: "America/Mexico_City"),
            City(id: "santiago", name: "Santiago", countryCode: "CL", timezone: "America/Santiago"),
            City(id: "sao-paulo", name: "Sao Paulo", countryCode: "BR", timezone: "America/Sao_Paulo")
        ]
        
        // Group cities by country
        let groupedByCountry = Dictionary(grouping: allCities) { $0.countryCode }
        
        // Create countries with their cities (sorted alphabetically)
        var countries: [Country] = []
        for (code, cities) in groupedByCountry {
            let sortedCities = cities.sorted { $0.name < $1.name }
            let countryName = getCountryName(for: code)
            countries.append(Country(id: code, name: countryName, cities: sortedCities))
        }
        
        // Sort countries alphabetically
        return countries.sorted { $0.name < $1.name }
    }
    
    private func getCountryName(for code: String) -> String {
        let countryNames: [String: String] = [
            "AE": "United Arab Emirates", "AF": "Afghanistan", "AL": "Albania",
            "AR": "Argentina", "AT": "Austria", "AU": "Australia",
            "BA": "Bosnia and Herzegovina", "BD": "Bangladesh", "BE": "Belgium",
            "BG": "Bulgaria", "BR": "Brazil", "CA": "Canada",
            "CH": "Switzerland", "CL": "Chile", "CN": "China",
            "CU": "Cuba", "CZ": "Czech Republic", "DE": "Germany",
            "DK": "Denmark", "DZ": "Algeria", "EG": "Egypt",
            "ES": "Spain", "FI": "Finland", "FR": "France",
            "GB": "United Kingdom", "HK": "Hong Kong", "HU": "Hungary",
            "ID": "Indonesia", "IE": "Ireland", "IN": "India",
            "IQ": "Iraq", "IR": "Iran", "IT": "Italy",
            "JP": "Japan", "KR": "South Korea", "KZ": "Kazakhstan",
            "LK": "Sri Lanka", "MA": "Morocco", "MX": "Mexico",
            "MY": "Malaysia", "NG": "Nigeria", "NL": "Netherlands",
            "NO": "Norway", "NZ": "New Zealand", "OM": "Oman",
            "PE": "Peru", "PK": "Pakistan", "PS": "Palestine",
            "PT": "Portugal", "RO": "Romania", "RU": "Russia",
            "SA": "Saudi Arabia", "SE": "Sweden", "SG": "Singapore",
            "SY": "Syria", "TN": "Tunisia", "TR": "Turkey",
            "TW": "Taiwan", "US": "United States", "UZ": "Uzbekistan",
            "VE": "Venezuela", "XK": "Kosovo", "YE": "Yemen",
            "ZA": "South Africa"
        ]
        return countryNames[code] ?? code
    }
}
