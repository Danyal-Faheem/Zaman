//
//  SettingsView.swift
//  Zaman
//
//  Created by Danyal Faheem on 25/01/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var settings = SettingsManager.shared
    @ObservedObject private var notificationManager = NotificationManager.shared
    
    @State private var showNotificationPermissionAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Settings")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding()
            
            Divider()
            
            // Settings Content
            ScrollView {
                VStack(spacing: 20) {
                    // Notifications Section
                    SettingsSection(title: "Notifications", icon: "bell.fill") {
                        VStack(spacing: 12) {
                            SettingsToggle(
                                title: "Adhan Notifications",
                                subtitle: "Get notified when it's time for prayer",
                                isOn: $settings.adhanNotificationsEnabled,
                                icon: "speaker.wave.2.fill"
                            )
                            .onChange(of: settings.adhanNotificationsEnabled) { _, newValue in
                                if newValue {
                                    requestNotificationPermission()
                                }
                            }
                            
                            Divider()
                            
                            SettingsToggle(
                                title: "Iqama Notifications",
                                subtitle: "Get notified when it's time for Iqama",
                                isOn: $settings.iqamaNotificationsEnabled,
                                icon: "bell.badge.fill"
                            )
                            .onChange(of: settings.iqamaNotificationsEnabled) { _, newValue in
                                if newValue {
                                    requestNotificationPermission()
                                }
                            }
                        }
                    }
                    
                    // Display Section
                    SettingsSection(title: "Display", icon: "eye.fill") {
                        VStack(spacing: 12) {
                            SettingsToggle(
                                title: "Show Adhan Countdown",
                                subtitle: "Display countdown to Adhan time in menu bar",
                                isOn: $settings.showAdhanCountdown,
                                icon: "clock.fill"
                            )
                            
                            Divider()
                            
                            SettingsToggle(
                                title: "Show Iqama Countdown",
                                subtitle: "Display countdown to Iqama time in menu bar",
                                isOn: $settings.showIqamaCountdown,
                                icon: "timer"
                            )
                        }
                    }
                    
                    // General Section
                    SettingsSection(title: "General", icon: "gear") {
                        VStack(spacing: 12) {
                            SettingsToggle(
                                title: "Launch at Login",
                                subtitle: "Start Zaman automatically when you log in",
                                isOn: $settings.launchAtLogin,
                                icon: "power"
                            )
                        }
                    }
                    
                    // About Section
                    SettingsSection(title: "About", icon: "info.circle.fill") {
                        VStack(spacing: 8) {
                            HStack {
                                Text("Version")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("1.0.0")
                            }
                            .font(.subheadline)
                            
                            Divider()
                            
                            HStack {
                                Text("Data Source")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("UAE Awqaf")
                            }
                            .font(.subheadline)
                        }
                    }
                }
                .padding()
            }
        }
        .frame(width: 360, height: 520)
        .background(.regularMaterial)
        .alert("Notification Permission Required", isPresented: $showNotificationPermissionAlert) {
            Button("Open Settings") {
                if let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") {
                    NSWorkspace.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {
                // Reset toggles if permission not granted
                settings.adhanNotificationsEnabled = false
                settings.iqamaNotificationsEnabled = false
            }
        } message: {
            Text("Please enable notifications in System Settings to receive prayer time alerts.")
        }
    }
    
    private func requestNotificationPermission() {
        Task {
            let granted = await notificationManager.requestAuthorization()
            if !granted {
                await MainActor.run {
                    showNotificationPermissionAlert = true
                }
            }
        }
    }
}

// MARK: - Settings Section
struct SettingsSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.headline)
            }
            
            VStack {
                content
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(10)
        }
    }
}

// MARK: - Settings Toggle
struct SettingsToggle: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.secondary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(.switch)
                .labelsHidden()
        }
    }
}

#Preview {
    SettingsView()
}
