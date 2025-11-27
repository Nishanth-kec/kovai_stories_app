# 📱 Invoice App - Flutter Mobile

A full-featured Flutter mobile application for managing invoices, clients, and items with seamless backend integration.

**Supported Platforms:** iOS, Android, Web, macOS, Linux, Windows  
**Flutter Version:** 3.10.1+  
**State Management:** Provider (ChangeNotifier)

---

## ✨ Features

### 🔐 Authentication
- User registration and login
- JWT token-based authentication
- Secure credential storage
- Session management
- Password validation

### 👥 Client Management
- Create, read, update, delete clients
- Search and filter clients
- Client information storage (name, email, phone, address)
- Notes and custom fields
- Quick access to client invoices

### 📦 Item Management
- Create, read, update, delete items
- Item catalog with descriptions
- Unit pricing
- SKU management
- Inventory tracking

### 📄 Invoice Management
- Create professional invoices
- Invoice status tracking (draft, sent, paid, overdue)
- Line item management
- Automatic calculations (subtotal, tax, discount, total)
- Invoice numbering
- PDF generation and preview
- Invoice sharing via email/messaging

### 🏢 Company Management
- Company profile management
- Logo upload and management
- Company information (name, email, phone, address, tax number)
- Multi-company support

### 📊 Dashboard
- Invoice overview
- Key metrics display
- Recent activity
- Quick actions

---

## 🛠️ Technology Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter 3.10.1 |
| **Language** | Dart 3.10+ |
| **State Management** | Provider 6.0+ |
| **Backend API** | REST (HTTP) |
| **Storage** | Shared Preferences (local), MongoDB (backend) |
| **PDF** | PDF generation library |
| **Image Handling** | image_picker |
| **API Client** | http package |
| **JSON Serialization** | json_serializable |

---

## 📦 Installation

### Prerequisites
- Flutter 3.10.1 or later
- Dart 3.10+
- iOS: Xcode 14+
- Android: Android Studio, SDK 21+

### 1. Clone Repository
```bash
git clone <repo-url>
cd invoice_app
```

### 2. Get Dependencies
```bash
flutter pub get
```

### 3. Configure API
Edit `lib/config/api.dart`:
```dart
static String baseUrl = 'http://your-server-url:4000/api';
// For local development: http://192.168.x.x:4000/api
// For production: https://api.example.com/api
```

### 4. Run Application

#### Android
```bash
flutter run -d <device-id>
# List devices: flutter devices
```

#### iOS
```bash
# First time setup
cd ios
pod install
cd ..

# Run app
flutter run -d <device-id>
```

#### Web
```bash
flutter run -d chrome
```

#### macOS/Windows/Linux
```bash
flutter run -d <platform>
```

---

## 🚀 Getting Started

### 1. Launch App
```bash
flutter run
```

### 2. Create Account
- Tap "Sign Up"
- Enter company name
- Enter full name
- Enter email
- Create password
- Tap "Register"

### 3. Login
- Enter email
- Enter password
- Tap "Login"

### 4. Navigate App
- **Home (Dashboard):** Overview of invoices
- **Clients:** Manage client list
- **Items:** Manage product/service items
- **Invoices:** Create and manage invoices
- **Settings:** Company info and preferences

---

## 📁 Project Structure

```
invoice_app/
├── pubspec.yaml                Main configuration and dependencies
├── analysis_options.yaml       Dart analysis rules
│
├── lib/
│   ├── main.dart              App entry point & provider setup
│   ├── app_theme.dart         Theme configuration
│   │
│   ├── config/
│   │   └── api.dart           API endpoint definitions
│   │
│   ├── models/
│   │   ├── user.dart          User model
│   │   ├── company.dart       Company model
│   │   ├── client.dart        Client model
│   │   ├── item.dart          Item model
│   │   └── invoice.dart       Invoice model
│   │
│   ├── providers/
│   │   ├── auth_provider.dart       Authentication state
│   │   ├── company_provider.dart    Company data state
│   │   ├── client_provider.dart     Clients state
│   │   ├── item_provider.dart       Items state
│   │   └── invoice_provider.dart    Invoices state
│   │
│   ├── services/
│   │   ├── auth_service.dart        Authentication API calls
│   │   ├── company_service.dart     Company API calls
│   │   ├── client_service.dart      Client API calls
│   │   ├── item_service.dart        Item API calls
│   │   ├── invoice_service.dart     Invoice API calls
│   │   └── pdf_service.dart         PDF generation
│   │
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── dashboard/
│   │   │   └── dashboard_screen.dart
│   │   ├── clients/
│   │   │   ├── clients_list_screen.dart
│   │   │   ├── client_details_screen.dart
│   │   │   └── add_client_screen.dart
│   │   ├── items/
│   │   │   ├── items_list_screen.dart
│   │   │   ├── item_details_screen.dart
│   │   │   └── add_item_screen.dart
│   │   ├── invoices/
│   │   │   ├── invoices_list_screen.dart
│   │   │   ├── invoice_details_screen.dart
│   │   │   └── add_invoice_screen.dart
│   │   ├── settings/
│   │   │   ├── settings_screen.dart
│   │   │   └── company_settings_screen.dart
│   │   └── navigation/
│   │       └── main_navigation.dart
│   │
│   └── widgets/
│       ├── custom_app_bar.dart
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       ├── invoice_card.dart
│       └── loading_widget.dart
│
├── assets/
│   ├── images/
│   │   ├── logo.png
│   │   └── icons/
│   └── fonts/
│       └── OpenSans.ttf
│
└── test/
    └── widget_test.dart
```

---

## 🏗️ Architecture

### Clean Architecture Layers

```
Screens (UI)
    ↓ (uses)
Providers (State Management)
    ↓ (uses)
Services (Business Logic)
    ↓ (uses)
API Config & HTTP Client
    ↓ (calls)
Backend REST API
    ↓ (persists)
MongoDB Database
```

---

## 🔐 Authentication Flow

```
1. User enters credentials
   ↓
2. Register/Login Service called
   ↓
3. Backend validates & returns JWT token
   ↓
4. Token stored in AuthProvider
   ↓
5. Token included in all API requests
   ↓
6. Backend validates token on each request
   ↓
7. Response returns data or 401 Unauthorized
```

---

## 📡 API Integration

### Base Configuration
```dart
// lib/config/api.dart
class ApiConfig {
  static const String baseUrl = 'http://192.168.x.x:4000/api';
  
  // Auth endpoints
  static String register = "$baseUrl/auth/register";
  static String login = "$baseUrl/auth/login";
  
  // Client endpoints
  static String clients = "$baseUrl/clients";
  static String clientDetail(String id) => "$baseUrl/clients/$id";
  
  // Item endpoints
  static String items = "$baseUrl/items";
  static String itemDetail(String id) => "$baseUrl/items/$id";
  
  // Invoice endpoints
  static String invoices = "$baseUrl/invoices";
  static String invoiceDetail(String id) => "$baseUrl/invoices/$id";
  
  // Company endpoints
  static String companyMe = "$baseUrl/company/me";
  static String companyUpdate = "$baseUrl/company/me";
  static String companyLogo = "$baseUrl/company/logo";
}
```

---

## 🧪 Testing

### Run Tests
```bash
flutter test
# Run specific test file
flutter test test/widget_test.dart
```

---

## 🐛 Common Issues & Solutions

### "Failed to connect to API"
```dart
// Check API URL in lib/config/api.dart
// For local dev: Use your machine IP (not localhost)
static const String baseUrl = 'http://192.168.x.x:4000/api';
```

### "CORS error"
```
Backend must have CORS enabled:
app.use(cors());
```

### "Build errors"
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub upgrade
flutter run
```

---

## 🚀 Building for Release

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-app.apk
```

### Android App Bundle
```bash
flutter build appbundle --release
# For Google Play Store
```

### iOS
```bash
flutter build ios --release
# Output: build/ios/iphoneos/Runner.app
```

### Web
```bash
flutter build web --release
# Output: build/web/
```

---

## 🔒 Security Considerations

✅ **Implemented**
- JWT token authentication
- Secure HTTPS (production)
- No hardcoded credentials
- Input validation

---

## ✅ Deployment Checklist

Before releasing:

- [ ] Update version in pubspec.yaml
- [ ] Test on iOS device
- [ ] Test on Android device
- [ ] Test on different screen sizes
- [ ] Update API base URL to production
- [ ] Enable HTTPS
- [ ] Configure app icons and splash screen
- [ ] Test authentication flow
- [ ] Verify PDF generation
- [ ] Test image upload

---

**Last Updated:** November 27, 2025  
**Status:** ✅ Ready for Testing  
**Version:** 1.0.0

🚀 **Ready to test and deploy!**
