//
//  LocationManager.swift
//  Zaman
//
//  Created by Danyal Faheem on 25/01/2026.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func requestLocation() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied, .restricted:
            authorizationStatus = status
        @unknown default:
            break
        }
    }
    
    func findNearestCity(from cities: [City], location: CLLocation) -> City? {
        var nearestCity: City?
        var shortestDistance: CLLocationDistance = .infinity
        
        for city in cities {
            // Get approximate coordinates for the city timezone
            if let cityCoordinate = getCoordinatesForTimezone(city.timezone) {
                let cityLocation = CLLocation(latitude: cityCoordinate.latitude, longitude: cityCoordinate.longitude)
                let distance = location.distance(from: cityLocation)
                
                if distance < shortestDistance {
                    shortestDistance = distance
                    nearestCity = city
                }
            }
        }
        
        return nearestCity
    }
    
    private func getCoordinatesForTimezone(_ timezone: String) -> CLLocationCoordinate2D? {
        // Approximate coordinates for major timezones/cities
        let timezoneCoordinates: [String: CLLocationCoordinate2D] = [
            // Middle East
            "Asia/Dubai": CLLocationCoordinate2D(latitude: 25.2048, longitude: 55.2708),
            "Asia/Riyadh": CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753),
            "Asia/Muscat": CLLocationCoordinate2D(latitude: 23.5880, longitude: 58.3829),
            "Asia/Kuwait": CLLocationCoordinate2D(latitude: 29.3759, longitude: 47.9774),
            "Asia/Bahrain": CLLocationCoordinate2D(latitude: 26.0667, longitude: 50.5577),
            "Asia/Qatar": CLLocationCoordinate2D(latitude: 25.2854, longitude: 51.5310),
            "Asia/Damascus": CLLocationCoordinate2D(latitude: 33.5138, longitude: 36.2765),
            "Asia/Baghdad": CLLocationCoordinate2D(latitude: 33.3152, longitude: 44.3661),
            "Asia/Tehran": CLLocationCoordinate2D(latitude: 35.6892, longitude: 51.3890),
            "Asia/Jerusalem": CLLocationCoordinate2D(latitude: 31.7683, longitude: 35.2137),
            "Asia/Amman": CLLocationCoordinate2D(latitude: 31.9454, longitude: 35.9284),
            "Asia/Beirut": CLLocationCoordinate2D(latitude: 33.8886, longitude: 35.4955),
            "Asia/Aden": CLLocationCoordinate2D(latitude: 12.7855, longitude: 45.0187),
            
            // Europe
            "Europe/London": CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278),
            "Europe/Paris": CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
            "Europe/Berlin": CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050),
            "Europe/Rome": CLLocationCoordinate2D(latitude: 41.9028, longitude: 12.4964),
            "Europe/Madrid": CLLocationCoordinate2D(latitude: 40.4168, longitude: -3.7038),
            "Europe/Amsterdam": CLLocationCoordinate2D(latitude: 52.3676, longitude: 4.9041),
            "Europe/Brussels": CLLocationCoordinate2D(latitude: 50.8503, longitude: 4.3517),
            "Europe/Vienna": CLLocationCoordinate2D(latitude: 48.2082, longitude: 16.3738),
            "Europe/Prague": CLLocationCoordinate2D(latitude: 50.0755, longitude: 14.4378),
            "Europe/Stockholm": CLLocationCoordinate2D(latitude: 59.3293, longitude: 18.0686),
            "Europe/Oslo": CLLocationCoordinate2D(latitude: 59.9139, longitude: 10.7522),
            "Europe/Copenhagen": CLLocationCoordinate2D(latitude: 55.6761, longitude: 12.5683),
            "Europe/Helsinki": CLLocationCoordinate2D(latitude: 60.1699, longitude: 24.9384),
            "Europe/Dublin": CLLocationCoordinate2D(latitude: 53.3498, longitude: -6.2603),
            "Europe/Lisbon": CLLocationCoordinate2D(latitude: 38.7223, longitude: -9.1393),
            "Europe/Moscow": CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173),
            "Europe/Istanbul": CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784),
            "Europe/Athens": CLLocationCoordinate2D(latitude: 37.9838, longitude: 23.7275),
            "Europe/Bucharest": CLLocationCoordinate2D(latitude: 44.4268, longitude: 26.1025),
            "Europe/Budapest": CLLocationCoordinate2D(latitude: 47.4979, longitude: 19.0402),
            "Europe/Warsaw": CLLocationCoordinate2D(latitude: 52.2297, longitude: 21.0122),
            "Europe/Sofia": CLLocationCoordinate2D(latitude: 42.6977, longitude: 23.3219),
            "Europe/Belgrade": CLLocationCoordinate2D(latitude: 44.7866, longitude: 20.4489),
            "Europe/Sarajevo": CLLocationCoordinate2D(latitude: 43.8563, longitude: 18.4131),
            "Europe/Tirane": CLLocationCoordinate2D(latitude: 41.3275, longitude: 19.8187),
            "Europe/Zurich": CLLocationCoordinate2D(latitude: 47.3769, longitude: 8.5417),
            
            // Asia
            "Asia/Karachi": CLLocationCoordinate2D(latitude: 24.8607, longitude: 67.0011),
            "Asia/Kolkata": CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025),
            "Asia/Dhaka": CLLocationCoordinate2D(latitude: 23.8103, longitude: 90.4125),
            "Asia/Jakarta": CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456),
            "Asia/Kuala_Lumpur": CLLocationCoordinate2D(latitude: 3.1390, longitude: 101.6869),
            "Asia/Singapore": CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8198),
            "Asia/Bangkok": CLLocationCoordinate2D(latitude: 13.7563, longitude: 100.5018),
            "Asia/Shanghai": CLLocationCoordinate2D(latitude: 31.2304, longitude: 121.4737),
            "Asia/Hong_Kong": CLLocationCoordinate2D(latitude: 22.3193, longitude: 114.1694),
            "Asia/Tokyo": CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503),
            "Asia/Seoul": CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
            "Asia/Taipei": CLLocationCoordinate2D(latitude: 25.0330, longitude: 121.5654),
            "Asia/Manila": CLLocationCoordinate2D(latitude: 14.5995, longitude: 120.9842),
            "Asia/Kabul": CLLocationCoordinate2D(latitude: 34.5553, longitude: 69.2075),
            "Asia/Tashkent": CLLocationCoordinate2D(latitude: 41.2995, longitude: 69.2401),
            "Asia/Almaty": CLLocationCoordinate2D(latitude: 43.2220, longitude: 76.8512),
            "Asia/Colombo": CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
            "Asia/Samarkand": CLLocationCoordinate2D(latitude: 39.6270, longitude: 66.9750),
            "Asia/Ulaanbaatar": CLLocationCoordinate2D(latitude: 47.8864, longitude: 106.9057),
            
            // North America
            "America/New_York": CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
            "America/Los_Angeles": CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437),
            "America/Chicago": CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298),
            "America/Denver": CLLocationCoordinate2D(latitude: 39.7392, longitude: -104.9903),
            "America/Toronto": CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832),
            "America/Vancouver": CLLocationCoordinate2D(latitude: 49.2827, longitude: -123.1207),
            "America/Edmonton": CLLocationCoordinate2D(latitude: 53.5461, longitude: -113.4938),
            "America/Halifax": CLLocationCoordinate2D(latitude: 44.6488, longitude: -63.5752),
            "America/Mexico_City": CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332),
            "America/Havana": CLLocationCoordinate2D(latitude: 23.1136, longitude: -82.3666),
            "Pacific/Honolulu": CLLocationCoordinate2D(latitude: 21.3099, longitude: -157.8581),
            "America/Phoenix": CLLocationCoordinate2D(latitude: 33.4484, longitude: -112.0740),
            "America/Detroit": CLLocationCoordinate2D(latitude: 42.3314, longitude: -83.0458),
            "America/Boise": CLLocationCoordinate2D(latitude: 43.6150, longitude: -116.2023),
            "America/Juneau": CLLocationCoordinate2D(latitude: 58.3019, longitude: -134.4197),
            "America/Regina": CLLocationCoordinate2D(latitude: 50.4452, longitude: -104.6189),
            
            // South America
            "America/Sao_Paulo": CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333),
            "America/Argentina/Buenos_Aires": CLLocationCoordinate2D(latitude: -34.6037, longitude: -58.3816),
            "America/Lima": CLLocationCoordinate2D(latitude: -12.0464, longitude: -77.0428),
            "America/Santiago": CLLocationCoordinate2D(latitude: -33.4489, longitude: -70.6693),
            "America/Caracas": CLLocationCoordinate2D(latitude: 10.4806, longitude: -66.9036),
            "America/Bogota": CLLocationCoordinate2D(latitude: 4.7110, longitude: -74.0721),
            
            // Africa
            "Africa/Cairo": CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357),
            "Africa/Johannesburg": CLLocationCoordinate2D(latitude: -26.2041, longitude: 28.0473),
            "Africa/Lagos": CLLocationCoordinate2D(latitude: 6.5244, longitude: 3.3792),
            "Africa/Casablanca": CLLocationCoordinate2D(latitude: 33.5731, longitude: -7.5898),
            "Africa/Algiers": CLLocationCoordinate2D(latitude: 36.7538, longitude: 3.0588),
            "Africa/Tunis": CLLocationCoordinate2D(latitude: 36.8065, longitude: 10.1815),
            "Africa/Nairobi": CLLocationCoordinate2D(latitude: -1.2864, longitude: 36.8172),
            
            // Australia/Oceania
            "Australia/Sydney": CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093),
            "Australia/Melbourne": CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631),
            "Australia/Brisbane": CLLocationCoordinate2D(latitude: -27.4698, longitude: 153.0251),
            "Australia/Perth": CLLocationCoordinate2D(latitude: -31.9505, longitude: 115.8605),
            "Australia/Adelaide": CLLocationCoordinate2D(latitude: -34.9285, longitude: 138.6007),
            "Australia/Hobart": CLLocationCoordinate2D(latitude: -42.8821, longitude: 147.3272),
            "Australia/Darwin": CLLocationCoordinate2D(latitude: -12.4634, longitude: 130.8456),
            "Pacific/Auckland": CLLocationCoordinate2D(latitude: -36.8485, longitude: 174.7633)
        ]
        
        return timezoneCoordinates[timezone]
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
