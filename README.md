# HizmetSepetim – Flutter Client (Open Source)

🚀 **HizmetSepetim** is a platform that connects service providers with users.
This repository contains the **Flutter client application** of HizmetSepetim.

> ⚠️ **Important:**
> This repo contains **only the Flutter client application**.
> Backend, database, live API services, and brand infrastructure are not included in this repository.

---

## 🎯 Project Purpose

This Flutter application aims to:

- Demonstrate how a **real-world product** is developed with Flutter
- Build a foundation for iOS version and **unified Android + iOS client** in the long term
- Showcase **Flutter architecture, UI/UX, and API integration** through open source
- Advance developer Flutter knowledge to an advanced level

The goal is **not to create a demo**, but to develop a real-world structure as open source.

---

## 📱 Features

### User Management
- ✅ User registration and login (JWT token-based)
- ✅ Profile viewing and editing
- ✅ Session management (persistent storage of tokens and user information)
- ✅ Auth state management (global state with ValueNotifier)

### Product and Category System
- ✅ Categories list
- ✅ Product listing by category
- ✅ Product detail page (description, price, seller information, reviews)
- ✅ Product search feature

### Order and Appointment Management
- ✅ Product selection and additional services
- ✅ Address management (add, list, select)
- ✅ Appointment date/time selection
- ✅ Order creation
- ✅ Appointment list viewing (Booking Screen)
- ✅ Appointment status tracking (Pending, Confirmed, Completed, Cancelled)

### Payment System
- ✅ **Wallet integration**
  - Wallet balance display
  - Payment with wallet
  - Partial payment support (wallet + card mixed payment)
  - Automatic balance check
- ✅ **Card information form** (currently optional, visual purposes)
- ✅ Payment method selection (wallet, card, mixed)
- ✅ Payment breakdown display (wallet + card breakdown)

### Wallet Features
- ✅ Balance display
- ✅ Transaction history (last 10 transactions)
- ✅ Promo code redemption
- ✅ Transaction types: `promo_code`, `order_payment`
- ✅ Pull-to-refresh support

### UI/UX Features
- ✅ Modern gradient bottom navigation bar
- ✅ Card-based design (shadowed cards)
- ✅ Loading and error state management
- ✅ Empty state displays
- ✅ Responsive layout

---

## 🧠 General Architecture

### Technology Stack

- **Framework:** Flutter SDK ^3.10.4
- **HTTP Client:** Dio ^5.9.0
- **Secure Storage:** flutter_secure_storage ^9.0.0 (JWT token)
- **Local Storage:** shared_preferences ^2.2.2 (User session)
- **State Management:**
  - `setState` (local state)
  - `ValueNotifier` (global auth state)
  - Provider ^6.0.5 (available as dependency, currently not used)

### Project Structure

```
lib/
├── main.dart                 # Application entry point
├── appData/
│   └── api_service.dart      # API services and data models
├── gui/
│   ├── main_layout.dart      # Main layout (bottom navigation)
│   ├── home_screen.dart      # Home page (categories & products)
│   ├── product_detail_screen.dart
│   ├── checkout_screen.dart  # Address selection
│   ├── payment_screen.dart   # Payment screen
│   ├── booking_screen.dart   # Appointments list
│   ├── wallet_screen.dart    # Wallet screen
│   ├── profile_screen.dart   # Profile viewing
│   ├── editprofile_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── profile_gate.dart     # Auth guard
│   └── widgets/              # Custom widgets
│       ├── payment_wallet.dart
│       ├── payment_addons.dart
│       └── payment_datetime.dart
├── utils/
│   ├── auth_state.dart       # Global auth state
│   ├── token_store.dart      # JWT token management
│   └── user_store.dart       # User information management
└── theme/
    └── colors.dart           # Theme colors
```

### API Integration

**Base URL:** `http://92.249.61.58:8080/`

**Endpoints:**
- `GET /get_categories` - Categories list
- `GET /get_products?category_id={id}` - Products list
- `GET /get_product_detail?id={id}` - Product detail
- `POST /register` - User registration
- `POST /login` - Login
- `GET /get_addresses` - Addresses list
- `POST /add_address` - Add address
- `GET /get_addons` - Additional services list
- `POST /create_order_with_payment` - Create order (wallet + card support)
- `GET /get_orders` - Appointments/orders list
- `GET /wallet/balance` - Wallet balance
- `GET /wallet/transactions` - Wallet transaction history
- `POST /redeem_promo` - Promo code redemption
- `POST /update_profile` - Profile update

**Authentication:**
- JWT Bearer token-based
- Token is securely stored with `flutter_secure_storage`
- `Authorization: Bearer {token}` header is automatically added to every request

### State Management

- **Local State:** `StatefulWidget` and `setState` usage
- **Global State:**
  - `ValueNotifier<bool> authState` - Login status
  - `ValueNotifier<UserSession?> userSession` - User information
- **Persistence:**
  - JWT token → `flutter_secure_storage`
  - User session → `shared_preferences`

### Design System

**Color Palette:**
- Primary: `#2A9D8F` (Teal)
- Background: `#F2F6F5` (Light gray)
- Text Dark: `#0F172A`
- Text Soft: `#64748B`

**UI Features:**
- Material Design
- Gradient bottom navigation bar
- Card-based layout (border-radius: 20px)
- Subtle shadows
- Smooth animations

---

## 📱 Platform Support

| Platform | Status |
|----------|--------|
| Android | ✅ In Development |
| iOS | 🎯 Target Platform |
| Web | ❌ Not currently targeted |
| Windows | ⚠️ Flutter default support (untested) |
| Linux | ⚠️ Flutter default support (untested) |
| macOS | ⚠️ Flutter default support (untested) |

> ℹ️ The **first Play Store release for Android** will be with native Kotlin (Jetpack Compose).
> Flutter is being developed in this project for **iOS and long-term unified client** goals.

---

## 🚀 Installation and Running

### Requirements

- Flutter SDK ^3.10.4 or higher
- Dart SDK (comes with Flutter)
- Android Studio / Xcode (for platform-specific development)
- Git

### Steps

1. **Clone the repository:**
```bash
git clone <repository-url>
cd hizmetsepetimapp_flutter
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Check API Base URL:**
   - Check the `baseUrl` variable in `lib/appData/api_service.dart` file
   - Enter your own backend URL if needed

4. **Run the application:**
```bash
# Android
flutter run

# iOS
flutter run -d ios

# For a specific device
flutter devices
flutter run -d <device-id>
```

### Configuration

The application currently uses a hardcoded backend URL.
To use your own backend, update the `baseUrl` variable in `lib/appData/api_service.dart` file.

---

## 📦 Dependencies

### Production Dependencies

```yaml
dio: ^5.9.0                    # HTTP client
flutter_secure_storage: ^9.0.0 # Secure token storage
shared_preferences: ^2.2.2     # Local storage
provider: ^6.0.5               # State management (currently not used)
cupertino_icons: ^1.0.8        # iOS-style icons
```

### Development Dependencies

```yaml
flutter_test: sdk              # Unit testing
flutter_lints: ^6.0.0          # Linting rules
flutter_launcher_icons: ^0.14.4 # App icon generation
```

---

## 🎨 Screens and Features

### 1. Home Screen
- Categories list
- Product listing by category
- Product cards (image, name, price)
- Navigation to product detail page

### 2. Product Detail Screen
- Product information (name, description, price)
- Seller information (name, phone, rating)
- Product reviews
- "Place Order" button

### 3. Checkout Screen
- Address list
- New address addition form
- Address selection
- Navigation to payment screen

### 4. Payment Screen
- Order summary
- Additional services selection
- Appointment date/time selection
- **Wallet integration:**
  - Balance display
  - Wallet usage toggle
  - Payment breakdown display
- Card information form (optional)
- Payment processing

### 5. Booking Screen
- Appointment list
- Appointment details:
  - Product name
  - Date/time
  - Address information
  - Additional services
  - Total amount
  - Status (color-coded badge)
- Pull-to-refresh
- Cancel button (currently disabled)

### 6. Wallet Screen
- Balance card
- Promo code entry and redemption
- Transaction history list:
  - Transaction type
  - Amount (positive/negative)
  - Description
  - Date
- Pull-to-refresh

### 7. Profile Screen
- User information (name, email, phone)
- Profile editing
- Logout
- Auth guard (redirect for non-logged-in users)

---

## 🔐 About Backend

- Backend is kept **private**
- This repository **does not include** live backend code
- API endpoints are for example/development purposes
- Backend is developed with **Go (Golang)**

### Backend Features (Reference)

- JWT authentication
- MySQL database
- CORS support
- Wallet/payment system
- Promo code system
- Order/booking management

If the project in the future:
- **Succeeds:** Open-core model continues
- **Is terminated:** Everything including backend can be made open source

---

## 🛠️ Development Notes

### Payment System Logic

1. **Wallet Payment:**
   - If user wants to use wallet balance, toggle is turned on
   - If balance is sufficient: Entire amount is paid from wallet (`payment_method: "wallet"`)
   - If balance is insufficient: Partial payment is made (`payment_method: "mixed"`)
     - Wallet: Up to available balance
     - Card: Remaining amount (currently optional)

2. **Card Payment:**
   - If wallet is not used: Entire amount from card (`payment_method: "card"`)
   - Card information is currently visual purposes only, not sent to backend

### Security

- JWT token secure storage (`flutter_secure_storage`)
- HTTPS usage is recommended (for production)
- Token is automatically added to every request
- Token expiration check is done on backend

### Error Management

- All API calls are protected with try-catch
- Loading and error states are available on every screen
- Meaningful error messages are shown to users
- Logs are written to console in debug mode

---

## 📄 License

This project is provided as open source. See the license file for details.

---

## 🤝 Contributing

We welcome your contributions! Please open an issue first or check existing issues.

---

## 📞 Contact

You can open an issue for questions or suggestions.

---

**Note:** This README reflects the current state of the project and is regularly updated.
