# CampusTrace

A **Lost & Found** application for colleges and workplaces built using **Flutter** and **Firebase**.

---

## Project Overview

CampusTrace helps students and employees report, search, and reclaim lost items within their campus or workplace. The app provides an intuitive interface for posting lost/found items, browsing listings, and connecting with item owners — all backed by Firebase for real-time data and secure authentication.

---

## Tech Stack

| Technology             | Purpose                        |
| ---------------------- | ------------------------------ |
| Flutter                | Cross-platform UI framework    |
| Firebase Auth          | User authentication            |
| Cloud Firestore        | Real-time NoSQL database       |
| Firebase Storage       | Image/file storage             |
| Provider               | State management               |
| image_picker           | Camera & gallery image capture |
| cached_network_image   | Efficient image loading/cache  |
| url_launcher           | Open external URLs/links       |

---

## Folder Structure

```
lib/
│
├── frontend/
│   ├── screens/
│   │   ├── auth/           # Login, Register, Forgot Password screens
│   │   ├── home/           # Home / Dashboard screens
│   │   ├── item/           # Item detail, Add/Edit item screens
│   │   └── profile/        # User profile screens
│   │
│   ├── widgets/            # Reusable UI components
│   │
│   └── theme/
│       ├── app_theme.dart        # Global ThemeData configuration
│       ├── app_colors.dart       # App color palette
│       └── app_text_styles.dart  # Typography styles
│
├── backend/
│   ├── models/
│   │   ├── user_model.dart       # User data model
│   │   └── item_model.dart       # Lost/Found item data model
│   │
│   ├── providers/
│   │   ├── auth_provider.dart    # Authentication state management
│   │   └── item_provider.dart    # Item listing state management
│   │
│   ├── repositories/
│   │   ├── auth_repository.dart  # Auth data access layer
│   │   └── item_repository.dart  # Item data access layer
│   │
│   └── services/
│       ├── auth_service.dart       # Firebase Auth service
│       ├── firestore_service.dart  # Cloud Firestore service
│       ├── storage_service.dart    # Firebase Storage service
│       └── image_service.dart      # Image picking/processing service
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart    # App-wide constants
│   │   └── app_strings.dart      # Static string values
│   │
│   ├── routes/
│   │   └── app_routes.dart       # Named route definitions
│   │
│   └── utils/
│       ├── validators.dart       # Form validation helpers
│       └── helpers.dart          # General utility functions
│
├── firebase_options.dart         # Firebase configuration (auto-generated)
└── main.dart                     # App entry point
```

---

## Setup Instructions

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x or later)
- [Firebase CLI](https://firebase.google.com/docs/cli) & [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)
- An IDE (VS Code / Android Studio)

### 1. Clone the Repository

```bash
git clone <repository-url>
cd CampusTrace
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

```bash
# Install FlutterFire CLI (if not already installed)
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

This will auto-generate the `lib/firebase_options.dart` file with your project's Firebase configuration.

### 4. Run the App

```bash
flutter run
```

---

## Architecture

The project follows a **layered architecture** with clear separation of concerns:

- **Frontend** — UI screens, reusable widgets, and theming.
- **Backend** — Data models, state management (providers), repositories (data access), and services (Firebase interactions).
- **Core** — Shared constants, route definitions, and utility functions.

---

## License

This project is for educational and internal use.
