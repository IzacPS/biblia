# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application for reading the Bible (Bíblia Sagrada) with offline functionality, bookmarks, and search capabilities. The app uses flutter_bloc for state management, sqflite for local database storage, and hydrated_bloc for state persistence.

## Development Commands

### Basic Development
- **Install dependencies**: `flutter pub get`
- **Run the app**: `flutter run`
- **Generate code**: `flutter pub run build_runner build --delete-conflicting-outputs`
- **Clean and reinstall**: `flutter clean && flutter pub get`

### Analysis and Testing
- **Run static analysis**: `flutter analyze`
- **Run tests**: `flutter test`
- **Check for outdated packages**: `flutter pub outdated`

### Build Commands
- **Build APK**: `flutter build apk`
- **Build release APK**: `flutter build apk --release`
- **Build iOS**: `flutter build ios`

## Architecture

### State Management
- Uses **flutter_bloc** pattern throughout the application
- **hydrated_bloc** for automatic state persistence across app restarts
- Repository pattern with dependency injection via **RepositoryProvider**

### Database Layer
- **sqflite** for local SQLite database (`biblia.db`)
- Two main tables:
  - `saved`: Stores general data with id, description, and data fields
  - `bookmarks`: Stores bookmarked verses with pagedataindex
- Database initialization happens in `main.dart:23-36`

### Data Sources
- Bible text data stored in JSON format in `assets/json/`
- Supports multiple translations/languages (pt_acf.json is primary)
- Uses `json_serializable` for model serialization

### Key Dependencies
- **flutter_bloc**: State management
- **hydrated_bloc**: State persistence
- **sqflite**: Local database
- **shared_preferences**: User preferences
- **google_fonts**: Custom typography
- **font_awesome_flutter**: Icons
- **flutter_settings_ui**: Settings interface

### Project Structure
```
lib/
├── main.dart                 # App entry point, database setup
├── app.dart                  # App widget with repository providers
├── root.dart                 # Root navigation
├── model/                    # Data models
│   ├── bible.dart           # Bible data model
│   ├── bible.g.dart         # Generated serialization code
│   └── bible_page.dart      # Page model
├── repository/              # Data access layer
│   └── bible_repository.dart
├── screen/                  # UI screens
│   ├── root_screen.dart
│   ├── bible_screen.dart
│   ├── bookmark_screen.dart
│   └── configuration_screen.dart
├── page/                    # Page widgets
└── notifier/               # State notifiers
```

### Android Configuration
- Namespace: `com.izac.app.biblia`
- Uses Kotlin and Java 11
- NDK version: 27.0.12077973
- Gradle plugin structure with KTS files

## Development Notes

- App is portrait-only (set in main.dart)
- Uses Material Design with custom fonts via Google Fonts
- Supports dark/light themes (implementation in progress)
- Bible data is preloaded from JSON assets
- All database operations go through BibleRepository
- State persistence handled automatically by hydrated_bloc