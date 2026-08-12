# ZedLingo Test Suite

Complete testing guide for the ZedLingo app.

## Test Structure

```
test/
├── unit/
│   ├── services/
│   │   ├── tts_service_test.dart
│   │   └── zambian_language_data_test.dart
│   └── widgets/
│       ├── zambian_eagle_mascot_test.dart
│       └── scenario_illustration_test.dart
├── integration/
│   ├── onboarding_flow_test.dart
│   └── home_dashboard_test.dart
└── system/
    └── zedlingo_app_test.dart

integration_test/
└── app_test.dart

test_driver/
└── zedlingo_e2e_test.dart
```

## Running Tests

### 1. Unit Tests
```bash
flutter test test/unit/
```

### 2. Widget Tests
```bash
flutter test test/unit/widgets/
```

### 3. Integration Tests
```bash
flutter test test/integration/
```

### 4. System Tests
```bash
flutter test test/system/
```

### 5. All Tests
```bash
flutter test
```

### 6. E2E Test (requires device/emulator)
```bash
flutter drive --target=test_driver/zedlingo_e2e_test.dart
```

## Test Coverage

### Unit Tests
- **TTSService**: Initialization, speak, stop, speed control, dispose
- **ZambianLanguageData**: Languages list, getters, uniqueness, unit structure
- **ZambianEagleMascot**: Rendering, emotions, tap handling, sizing
- **ScenarioIllustration**: All 11 scenario types render correctly

### Integration Tests
- **OnboardingFlow**: Welcome → Language → Motivation → Level → Goal → Home
- **HomeDashboard**: Navigation to all 5 main screens
- **Navigation**: Bottom nav, Explore More grid, back buttons

### System Tests
- **E2E Flow**: Complete user journey from app launch to home
- **Screen Transitions**: All routes and animations
- **Data Integrity**: Language selection persistence

## Prerequisites

1. Flutter SDK installed
2. Dependencies installed:
   ```bash
   flutter pub get
   ```
3. For E2E tests: Device or emulator connected
   ```bash
   flutter devices
   ```

## Troubleshooting

### "Flutter not found"
Add Flutter to your PATH:
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

### "No devices found"
Start an emulator or connect a device:
```bash
flutter emulators
flutter emulators --launch <emulator_id>
```

### "Tests fail due to missing assets"
Ensure assets directory exists:
```bash
mkdir -p assets/images
```

## CI/CD Integration

Add to `.github/workflows/flutter_test.yml`:
```yaml
name: Flutter Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
```
