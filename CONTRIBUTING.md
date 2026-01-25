# Contributing to Zaman

First off, thank you for considering contributing to Zaman! It's people like you that make Zaman a great tool for the Muslim community.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Style Guidelines](#style-guidelines)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inspiring community for all. Please be respectful and constructive in your interactions.

### Our Standards

**Positive behavior includes:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

**Unacceptable behavior includes:**
- Harassment, trolling, or insulting comments
- Publishing others' private information
- Any conduct which could reasonably be considered inappropriate

## 🤝 How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates.

**When reporting bugs, include:**
- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected behavior** vs **actual behavior**
- **Screenshots** if applicable
- **Environment details:**
  - macOS version
  - Zaman version
  - Location (city/country) if relevant
  - Any error messages

**Example bug report:**
```markdown
**Title:** Prayer times not updating after location change

**Description:** 
When I change my location from Dubai to London, the prayer times don't update immediately.

**Steps to Reproduce:**
1. Launch Zaman with Dubai selected
2. Open settings and change country to United Kingdom
3. Select London from city dropdown
4. Close settings

**Expected:** Prayer times update to London times
**Actual:** Still shows Dubai times until app restart

**Environment:**
- macOS: 14.2
- Zaman: 1.0.0
- Initial location: Dubai, UAE
```

### Suggesting Enhancements

Enhancement suggestions are welcome! Please include:
- **Clear use case**: Why is this needed?
- **Detailed description**: What should it do?
- **Mockups/examples**: Visual aids help (optional)
- **Alternative solutions**: What other approaches could work?

### Adding New Cities/Countries

To add support for new cities:

1. **Check Aladhan API**: Verify the city is supported
2. **Add to CitiesData.swift**:
   ```swift
   City(id: "city-slug", name: "City Name", countryCode: "CC", timezone: "Region/City")
   ```
3. **Add timezone coordinates** to LocationManager.swift (optional, for auto-detection)
4. **Test thoroughly**: Verify prayer times are accurate

### Submitting Code

We love pull requests! Here's how:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Make your changes**
4. **Write/update tests**
5. **Commit your changes** (see commit guidelines below)
6. **Push to your fork** (`git push origin feature/amazing-feature`)
7. **Open a Pull Request**

## 💻 Development Setup

### Prerequisites

- **Xcode 15.0+** with macOS SDK
- **macOS 14.0+** for testing
- **Git** for version control
- **Swift 5.0+** knowledge

### Initial Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/Zaman.git
cd Zaman

# Add upstream remote
git remote add upstream https://github.com/ORIGINAL_OWNER/Zaman.git

# Create a feature branch
git checkout -b feature/your-feature-name

# Open in Xcode
open Zaman.xcodeproj
```

### Project Structure

```
Zaman/
├── Assets.xcassets/       # Images and colors
├── Data/
│   └── CitiesData.swift   # Cities and countries data
├── Models/
│   └── PrayerModels.swift # Data models
├── Services/
│   ├── LocationManager.swift
│   ├── NotificationManager.swift
│   ├── PrayerAPIService.swift
│   └── SettingsManager.swift
├── ViewModels/
│   └── PrayerTimesViewModel.swift
├── Views/
│   ├── MenuBarPopupView.swift
│   └── SettingsView.swift
├── ZamanApp.swift         # App entry point
├── Info.plist
└── Zaman.entitlements
```

### Running Tests

```bash
# In Xcode: Cmd+U

# Or via command line:
xcodebuild test -scheme Zaman -destination 'platform=macOS'
```

### Building

```bash
# Debug build
xcodebuild -project Zaman.xcodeproj -scheme Zaman -configuration Debug

# Release build
xcodebuild -project Zaman.xcodeproj -scheme Zaman -configuration Release
```

## 🎨 Style Guidelines

### Swift Code Style

We follow Swift's official [API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).

**Key points:**

1. **Naming**
   ```swift
   // Good
   func fetchPrayerTimes(cityName: String, countryCode: String) async throws
   var isLoading: Bool
   
   // Bad
   func getPrayers(c: String, cc: String) -> Void
   var loading: Bool
   ```

2. **Formatting**
   ```swift
   // Good - Clear and readable
   if let city = selectedCity,
      let country = selectedCountry {
       // ...
   }
   
   // Bad - Cramped
   if let city=selectedCity,let country=selectedCountry{
       // ...
   }
   ```

3. **Comments**
   ```swift
   // Good - Explain why, not what
   // Update every second to keep countdown accurate
   timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
   
   // Bad - Obvious
   // Create a timer
   timer = Timer.scheduledTimer(...)
   ```

4. **MARK Usage**
   ```swift
   // MARK: - Published Properties
   @Published var prayerTimes: [PrayerTime] = []
   
   // MARK: - Initialization
   init() { }
   
   // MARK: - Private Methods
   private func updateMenuBarTitle() { }
   ```

### SwiftUI Views

```swift
// Good - Small, focused views
struct PrayerTimeRow: View {
    let prayerTime: PrayerTime
    
    var body: some View {
        HStack {
            // ...
        }
    }
}

// Good - Extract complex logic to computed properties
private var isNextPrayer: Bool {
    guard let upcoming = upcomingEvent else { return false }
    return upcoming.prayerType == prayerTime.type
}
```

### Testing

```swift
// Good - Descriptive test names
func testPrayerTimeFormattingWithValidData() throws {
    // Given
    let adhanTime = Date()
    
    // When
    let prayerTime = PrayerTime(type: .fajr, adhanTime: adhanTime, iqamaTime: nil)
    
    // Then
    XCTAssertNotNil(prayerTime.formattedAdhanTime)
}
```

## 📝 Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/):

### Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code refactoring
- **test**: Adding/updating tests
- **chore**: Maintenance tasks

### Examples

```bash
# Good commits
git commit -m "feat(prayer): add hijri date display from API"
git commit -m "fix(location): resolve timezone calculation for DST"
git commit -m "docs(readme): update installation instructions"
git commit -m "test(viewmodel): add tests for countdown threshold"

# With body
git commit -m "feat(notifications): add iqama notification support

- Added iqamaNotificationsEnabled setting
- Created separate notification for iqama times
- Updated settings UI with toggle

Closes #42"
```

## 🔄 Pull Request Process

### Before Submitting

- [ ] **Code compiles** without errors or warnings
- [ ] **Tests pass** (`Cmd+U` in Xcode)
- [ ] **Code is formatted** according to style guidelines
- [ ] **Commits follow** conventional commit format
- [ ] **Documentation updated** if needed
- [ ] **No sensitive data** (API keys, personal info) included

### PR Template

When opening a PR, include:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] All existing tests pass
- [ ] Added new tests for new features
- [ ] Manually tested on macOS [version]

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No warnings in Xcode
```

### Review Process

1. **Automated checks** run on your PR
2. **Maintainer review** within 1-3 days
3. **Feedback addressed** (if any)
4. **Approval and merge**

### After Merge

- Your contribution will be included in the next release
- You'll be added to the contributors list
- Release notes will credit your contribution

## 🎯 Priority Areas

We especially welcome contributions in:

- **New cities/countries**: Expanding location support
- **Calculation methods**: Supporting different madhabs
- **Accessibility**: VoiceOver, keyboard navigation
- **Localization**: Arabic and other languages
- **Performance**: Optimizations and efficiency
- **Testing**: Increasing test coverage
- **Documentation**: Improving guides and examples

## 💡 Questions?

- **General questions**: [Open a discussion](../../discussions)
- **Quick questions**: Comment on relevant issues
- **Private matters**: Email us at your.email@example.com

## 🌟 Recognition

All contributors will be:
- Listed in the README contributors section
- Mentioned in release notes
- Forever appreciated by the community! 🙏

---

Thank you for contributing to Zaman and supporting the Muslim community! 🕌
