# 🌸 Flowers App

A production-grade **Flutter e-commerce application** for browsing and ordering flowers and gift arrangements. Built with **Clean Architecture**, the **BLoC/Cubit** pattern, and a fully type-safe networking layer, the app delivers a smooth, localized (Arabic 🇸🇦 / English 🇬🇧) shopping experience from product discovery to checkout and order tracking.

---

## ✨ Features

- 🔐 **Authentication** — Sign up, sign in, logout, forgot/reset password with OTP verification, and change password.
- 🏠 **Home & Discovery** — Curated home feed, occasions, best sellers, and categories.
- 🔎 **Search** — Find products quickly with a dedicated search experience.
- 🛍️ **Product Details** — Rich product pages with images, descriptions, and add-to-cart.
- 🛒 **Cart** — Add, update quantities, remove items, and clear the cart with optimistic local updates.
- 📍 **Addresses** — Manage delivery addresses with **Google Maps**, geolocation, and reverse geocoding.
- 💳 **Checkout** — Cash and card checkout flows.
- 📦 **Orders** — View order history and details.
- 👤 **Profile** — Edit profile, upload photo, reset password.
- 🌍 **Localization** — Full Arabic & English support with RTL handling.
- 📡 **Offline-friendly caching** — Local persistence with Hive and HTTP cache interceptors.
- 🛡️ **Crash reporting & Remote Config** — Firebase Crashlytics and Remote Config.

---
## 📸 Screenshots

Below are the app's screenshots that highlight its functionality:

<img width="170" alt="Image" src="https://github.com/user-attachments/assets/c2726ff6-f370-4713-b001-6b70e3d38ef3" /> <img width="170" alt="Image" src="https://github.com/user-attachments/assets/dc6b060f-8b98-4a4e-a719-5c5f93cdeb68" /> <img width="170" alt="Image" src="https://github.com/user-attachments/assets/1d127308-6a0a-4c3d-aa3f-f847a8089e79" /> <img width="170" alt="Image" src="https://github.com/user-attachments/assets/bef7f5b8-02d8-470b-84ff-ec6702d88225" /><img width="170" alt="Image" src="https://github.com/user-attachments/assets/c460a01a-8c1a-451c-b22b-15f4147018bd" />

---

## 🏗️ Architecture

The project follows **Clean Architecture**, organized **feature-first**. Each feature is split into independent layers, keeping business logic decoupled from the UI and the data sources.

```
lib/
├── main.dart                  # App entry point (DI, localization, Firebase, Hive)
├── config/                    # Cross-cutting infrastructure
│   ├── di/                    # Dependency injection (get_it + injectable)
│   ├── dio/                   # Dio HTTP client module
│   ├── interceptors/          # Auth / logging / cache interceptors
│   ├── cache/                 # Hive helper & local storage
│   ├── services/              # Auth, Firebase, Location, Remote Config, etc.
│   ├── error_handler/         # Centralized failure handling
│   ├── base_response/         # Generic API response wrappers
│   ├── base_state/            # Shared state primitives
│   └── validations/           # Form & input validations
├── core/                      # Shared building blocks
│   ├── entities/ · models/    # Shared domain & data models
│   ├── extensions/            # Dart/Flutter extensions
│   ├── widgets/               # Reusable widgets
│   └── utils/                 # Theme, colors, routes, endpoints, constants
└── features/                  # Feature modules
    └── <feature>/
        ├── api/               # Retrofit API clients & remote data sources
        ├── data/              # Models (request/response), data sources, repo impl
        ├── domain/            # Entities, repo contracts, use cases
        └── presentation/      # Screens, widgets, BLoC/Cubit view models
```

**Layer responsibilities**

| Layer            | Responsibility                                                        |
| ---------------- | --------------------------------------------------------------------- |
| **Presentation** | UI screens, widgets, and BLoC/Cubit state management.                  |
| **Domain**       | Pure business logic: entities, use cases, and repository contracts.    |
| **Data**         | Models, data source implementations, and repository implementations.   |
| **API**          | Retrofit-generated, type-safe HTTP clients over Dio.                   |

---

## 🧰 Tech Stack

| Category              | Packages |
| --------------------- | -------- |
| **State Management**  | `flutter_bloc`, `bloc`, `bloc_test`, `equatable` |
| **Networking**        | `dio`, `retrofit`, `dio_cache_interceptor` |
| **Dependency Injection** | `get_it`, `injectable` |
| **Serialization**     | `json_annotation`, `json_serializable`, `retrofit_generator` |
| **Local Storage**     | `hive`, `hive_flutter`, `flutter_secure_storage`, `path_provider` |
| **Firebase**          | `firebase_core`, `cloud_firestore`, `firebase_crashlytics`, `firebase_remote_config` |
| **Maps & Location**   | `google_maps_flutter`, `flutter_map`, `geolocator`, `geocoding`, `latlong2` |
| **Localization**      | `easy_localization`, `intl` |
| **UI & UX**           | `flutter_screenutil`, `google_fonts`, `flutter_svg`, `cached_network_image`, `shimmer`, `lottie`, `bot_toast`, `pin_code_fields` |
| **Utilities**         | `logger`, `image_picker`, `webview_flutter`, `stream_transform` |
| **Tooling**           | `build_runner`, `flutter_lints`, `mockito`, `test` |

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** with Dart `^3.11.0` (stable channel)
- An IDE (VS Code or Android Studio)
- A configured Firebase project (`google-services.json` / `GoogleService-Info.plist`)
- A Google Maps API key (Android & iOS)

### Installation

```bash
# 1. Clone the repository
git clone <repository-url>
cd flowers-app

# 2. Install dependencies
flutter pub get

# 3. Generate code (DI, Retrofit clients, JSON models)
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

> 💡 During active development, keep generated files in sync with:
> ```bash
> dart run build_runner watch --delete-conflicting-outputs
> ```

---

## 🔧 Configuration

- **API Base URL** is defined in [`lib/core/utils/app_end_points.dart`](lib/core/utils/app_end_points.dart):
  ```dart
  static const String baseUrl = "https://flower.elevateegy.com/api/v1";
  ```
- **Firebase** must be configured per platform before running. Add your platform config files and ensure `FirebaseService.init()` succeeds at startup.
- **Google Maps** requires a valid API key in the Android `AndroidManifest.xml` and iOS `AppDelegate`/`Info.plist`.
- **Localization** assets live under `assets/translations/` (`en` and `ar`).

---

## 🗂️ Assets

```
assets/
├── images/          # Bitmaps & illustrations
├── icons/           # SVG / icon assets
├── lottie_files/    # Lottie animations
├── translations/    # Localization JSON (en, ar)
└── json/            # Static JSON data
```

---

## 🧪 Testing

```bash
flutter test
```

The project includes `bloc_test` and `mockito` for unit-testing BLoCs/Cubits and mocking repositories and data sources.

---

## 📦 Build

```bash
# Android (release APK)
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 🤝 Contributing

1. Create a feature branch from `develop`.
2. Follow the existing **feature-first Clean Architecture** structure.
3. Run the code generator after changing DI, models, or API clients.
4. Ensure `flutter analyze` and `flutter test` pass before opening a PR.

---

## 📄 License

This project is for educational and demonstration purposes. Add your preferred license here.
