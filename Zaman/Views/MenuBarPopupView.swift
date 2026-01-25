//
//  MenuBarPopupView.swift
//  Zaman
//
//  Created by Danyal Faheem on 25/01/2026.
//

import SwiftUI

struct MenuBarPopupView: View {
    @ObservedObject var viewModel: PrayerTimesViewModel
    @State private var showSettings = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            Divider()
            
            // Location Selector
            locationSelector
            
            Divider()
            
            // Next Prayer Countdown
            nextPrayerView
            
            Divider()
            
            // Prayer Times List
            prayerTimesListView
            
            Divider()
            
            // Footer
            footerView
        }
        .frame(width: 320)
        .background(.regularMaterial)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Zaman")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(viewModel.hijriDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(viewModel.gregorianDate)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .help("Settings")
        }
        .padding()
    }
    
    // MARK: - Location Selector
    private var locationSelector: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.accentColor)
                
                Text(viewModel.currentLocationText)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                // Country Picker
                Picker("Country", selection: $viewModel.selectedCountryCode) {
                    ForEach(viewModel.countries) { country in
                        Text(country.name).tag(country.id)
                    }
                }
                .labelsHidden()
                .frame(maxWidth: .infinity)
                .onChange(of: viewModel.selectedCountryCode) { _, newValue in
                    viewModel.onCountryChanged(newValue)
                }
                
                // City Picker
                Picker("City", selection: $viewModel.selectedCityName) {
                    ForEach(viewModel.currentCities) { city in
                        Text(city.name).tag(city.name)
                    }
                }
                .labelsHidden()
                .frame(maxWidth: .infinity)
                .onChange(of: viewModel.selectedCityName) { _, newValue in
                    viewModel.onCityChanged(newValue)
                }
            }
        }
        .padding()
    }
    
    // MARK: - Next Prayer View
    private var nextPrayerView: some View {
        VStack(spacing: 8) {
            if let upcoming = viewModel.upcomingEvent {
                let now = Date()
                let isAdhanDisplayPeriod = {
                    if case .adhan = upcoming.type {
                        return now >= upcoming.time && now < upcoming.time.addingTimeInterval(60)
                    }
                    return false
                }()
                
                HStack {
                    Image(systemName: upcoming.prayerType.icon)
                        .font(.title2)
                        .foregroundColor(prayerColor(for: upcoming.prayerType))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        if isAdhanDisplayPeriod {
                            // During Adhan - just show the name
                            Text(upcoming.displayName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                        } else {
                            // Before Adhan or during Iqama countdown
                            Text("Next: \(upcoming.displayName)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text(upcoming.formattedTimeRemaining())
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    Spacer()
                }
            } else {
                Text("All prayers completed for today")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(.thickMaterial)
    }
    
    // MARK: - Prayer Times List
    private var prayerTimesListView: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.prayerTimes) { prayerTime in
                PrayerTimeRow(prayerTime: prayerTime, upcomingEvent: viewModel.upcomingEvent)
                
                if prayerTime.type != .isha {
                    Divider()
                        .padding(.horizontal)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Footer
    private var footerView: some View {
        HStack {
            Button(action: {
                Task {
                    await viewModel.fetchPrayerTimes()
                }
            }) {
                HStack(spacing: 4) {
                    Image(systemName: viewModel.isLoading ? "arrow.trianglehead.2.clockwise.rotate.90" : "arrow.clockwise")
                        .symbolEffect(.rotate, isActive: viewModel.isLoading)
                    Text("Refresh")
                        .font(.caption)
                }
            }
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
            .disabled(viewModel.isLoading)
            
            Spacer()
            
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "power")
                    Text("Quit")
                        .font(.caption)
                }
            }
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
        }
        .padding()
    }
    
    // MARK: - Helper
    private func prayerColor(for type: PrayerType) -> Color {
        switch type {
        case .fajr: return .indigo
        case .sunrise: return .orange
        case .dhuhr: return .yellow
        case .asr: return .orange
        case .maghrib: return .pink
        case .isha: return .purple
        }
    }
}

// MARK: - Prayer Time Row
struct PrayerTimeRow: View {
    let prayerTime: PrayerTime
    let upcomingEvent: UpcomingEvent?
    
    private var isNextPrayer: Bool {
        guard let upcoming = upcomingEvent else { return false }
        return upcoming.prayerType == prayerTime.type
    }
    
    private var isPassed: Bool {
        return prayerTime.adhanTime < Date() && !(prayerTime.iqamaTime ?? Date.distantPast > Date())
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: prayerTime.type.icon)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(width: 28)
            
            // Prayer Name
            VStack(alignment: .leading, spacing: 2) {
                Text(prayerTime.type.rawValue)
                    .font(.subheadline)
                    .fontWeight(isNextPrayer ? .semibold : .regular)
                    .foregroundColor(isPassed ? .secondary : .primary)
                
                if let iqamaTime = prayerTime.formattedIqamaTime {
                    Text("Iqama: \(iqamaTime)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Time
            Text(prayerTime.formattedAdhanTime)
                .font(.subheadline)
                .fontWeight(isNextPrayer ? .semibold : .regular)
                .foregroundColor(isPassed ? .secondary : .primary)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(isNextPrayer ? Color.accentColor.opacity(0.1) : Color.clear)
        .cornerRadius(8)
    }
    
    private var iconColor: Color {
        if isPassed {
            return .secondary
        }
        
        switch prayerTime.type {
        case .fajr: return .indigo
        case .sunrise: return .orange
        case .dhuhr: return .yellow
        case .asr: return .orange
        case .maghrib: return .pink
        case .isha: return .purple
        }
    }
}

#Preview {
    MenuBarPopupView(viewModel: PrayerTimesViewModel())
}
