# Changelog

All notable changes to Zaman will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release of Zaman

## [1.0.0] - 2026-01-25

### Added
- **Core Features**
  - Six daily prayer times (Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha)
  - Automatic location detection using CoreLocation
  - Manual location selection from 150+ cities across 50+ countries
  - Hijri calendar date display from Aladhan API
  - Prayer time countdown in menu bar

- **Smart Countdown System**
  - 30-minute countdown threshold
  - 60-second Adhan display period (no countdown)
  - Automatic Iqama countdown after Adhan
  - Minutes-only time display format

- **Notifications**
  - Adhan notifications (toggleable)
  - Iqama notifications (toggleable)
  - macOS native notification system integration

- **UI/UX**
  - Native macOS menu bar integration
  - Mosque icon with template rendering (light/dark mode support)
  - SwiftUI-based popup interface
  - Color-coded prayer times
  - Timezone difference indicator
  - Settings panel with multiple options

- **Settings**
  - Display preferences (show/hide Adhan/Iqama countdowns)
  - Notification preferences
  - Launch at login option
  - Location persistence across relaunches

- **Data & API**
  - Integration with Aladhan API
  - Method 8 (UAE) calculation
  - Support for multiple timezones
  - Comprehensive city database with IANA timezone identifiers

- **Developer Features**
  - MVVM architecture
  - Comprehensive unit tests (40+ tests)
  - UI tests for critical workflows
  - Code documentation
  - Performance optimizations

### Technical Details
- Swift 5.0
- SwiftUI
- macOS 14.0+ support
- CoreLocation integration
- UserNotifications framework
- Combine for reactive updates

---

## Release Notes Format

### Types of Changes
- `Added` for new features
- `Changed` for changes in existing functionality
- `Deprecated` for soon-to-be removed features
- `Removed` for now removed features
- `Fixed` for any bug fixes
- `Security` in case of vulnerabilities
