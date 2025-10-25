# 🔐 Trusted App - Production-Ready Flutter Authentication System

A complete, production-ready authentication system built with Flutter following **Clean Architecture** principles. This app connects to a real tRPC backend API and implements all authentication flows including Sign Up, Sign In, Email Verification (OTP), Profile Management, and Sign Out.

## ✨ Features

- ✅ **Sign Up** with device ID tracking
- ✅ **Sign In** with username and password
- ✅ **Email Verification** with 6-digit OTP
- ✅ **Profile Management** (view and update user data)
- ✅ **Secure Token Storage** using `flutter_secure_storage`
- ✅ **Automatic Token Expiration** handling
- ✅ **Device ID Management** (persistent across app sessions)
- ✅ **Network Error Handling** with retry logic
- ✅ **Offline Detection** before API calls
- ✅ **Clean Architecture** with separation of concerns
- ✅ **State Management** using BLoC/Cubit
- ✅ **Form Validation** with user-friendly error messages
- ✅ **Beautiful UI** with Material Design 3
- ✅ **No Mock Data** - connects to real API

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── env.dart                    # Environment configuration (base URL, timeouts)
│   ├── device/
│   │   └── device_service.dart         # Device ID generation and persistence
│   ├── network/
│   │   ├── api_exceptions.dart         # Unified exception handling
│   │   └── http_client.dart            # HTTP wrapper with retry & auth
│   └── storage/
│       └── secure_storage_service.dart # Secure token storage
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── auth_remote_datasource.dart  # API endpoint calls
│       │   ├── models/
│       │   │   ├── auth_request_models.dart     # Request DTOs
│       │   │   ├── auth_response_models.dart    # Response DTOs
│       │   │   ├── session_model.dart           # Session data
│       │   │   └── user_model.dart              # User data
│       │   └── repositories/
│       │       └── auth_repository_impl.dart    # Repository implementation
│       ├── domain/
│       │   └── repositories/
│       │       └── auth_repository.dart         # Repository interface
│       ├── presentation/
│       │   ├── cubit/
│       │   │   ├── auth_cubit.dart              # State management
│       │   │   └── auth_state.dart              # App states
│       │   ├── screens/
│       │   │   ├── profile_screen.dart          # Profile view & edit
│       │   │   ├── sign_in_screen.dart          # Sign in UI
│       │   │   ├── sign_up_screen.dart          # Sign up UI
│       │   │   └── verify_email_screen.dart     # OTP verification UI
│       │   └── widgets/
│       │       ├── custom_button.dart           # Reusable button
│       │       └── custom_text_field.dart       # Reusable text field
│       └── utils/
│           └── validators.dart                  # Form validation logic
└── main.dart                                    # App entry point with DI setup
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.8.0 or higher
- Dart SDK 3.8.0 or higher
- Android Studio / Xcode (for mobile development)
- A running backend server (see API configuration below)

### Installation

1. **Clone the repository:**

```bash
git clone <repository-url>
cd trusted_app
```

2. **Install dependencies:**

```bash
flutter pub get
```

3. **Generate JSON serialization code:**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Configuration

#### Environment Variables

The app uses a `.env` file for configuration. Edit `.env` to match your backend:

```env
# API Configuration
API_BASE_URL=http://localhost:3000/api/trpc
API_TIMEOUT_SECONDS=10
API_MAX_RETRIES=2

# Environment (development or production)
ENVIRONMENT=development

# Security
USE_CERTIFICATE_PINNING=false
```

**For Production:**

```env
API_BASE_URL=https://your-domain.com/api/trpc
ENVIRONMENT=production
USE_CERTIFICATE_PINNING=true
```

⚠️ **Important:** The app will warn you if using HTTP in production mode.

#### Changing Base URL

All configuration is centralized in `lib/core/config/env.dart`. You can also change values directly in `.env` without touching code.

### Running the App

**Development Mode:**

```bash
flutter run
```

**Production Build:**

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### Running Tests

**Run all tests:**

```bash
flutter test
```

**Run with coverage:**

```bash
flutter test --coverage
```

## 🔧 How It Works

### Authentication Flow

1. **Sign Up**
   - User enters username, email, password (and optional fields)
   - Device ID is automatically fetched/generated
   - API creates account and returns session token
   - Token is stored securely in `flutter_secure_storage`
   - User is redirected to email verification screen

2. **Email Verification**
   - OTP is automatically sent to user's email
   - User enters 6-digit code
   - API validates OTP and marks email as verified
   - User is redirected to profile screen

3. **Sign In**
   - User enters username and password
   - Device ID is automatically sent
   - API validates credentials and returns token
   - Token is stored securely
   - User is redirected to profile screen

4. **Token Management**
   - Token is automatically added to all protected requests
   - Token expiration is checked before each request
   - If token is expired, user is forced to re-login
   - Token is cleared on sign out

5. **Profile Management**
   - User can view account information
   - User can update name and phone numbers
   - Changes are saved to backend and local cache
   - Email verification status is displayed

### Device ID Management

The app generates a unique device ID for tracking:

- **Android:** Uses `androidId` from device info
- **iOS:** Uses `identifierForVendor`
- **Fallback:** Generates UUID and persists it securely

The device ID persists across app sessions and is sent with sign up/sign in requests.

### Token Expiration Handling

- Token expiry date is stored with the token
- Before each authenticated request, the app checks if token is expired
- If expired or about to expire (within 5 minutes), user must re-login
- This prevents unnecessary API calls with expired tokens

### Error Handling

All API errors are mapped to user-friendly Arabic messages:

| Error Code | User Message |
|------------|-------------|
| `UNAUTHORIZED` | اسم المستخدم أو كلمة المرور غير صحيحة |
| `CONFLICT` | اسم المستخدم أو البريد الإلكتروني موجود بالفعل |
| `NOT_FOUND` | لا يوجد حساب مرتبط بهذا البريد الإلكتروني |
| `BAD_REQUEST` | الرجاء التحقق من المدخلات |
| `INTERNAL_SERVER_ERROR` | خطأ في الخادم، حاول لاحقًا |
| Network Error | تأكد من اتصال الإنترنت |

### Network Layer Features

The `HttpClient` wrapper provides:

- ✅ Automatic Bearer token injection
- ✅ Connectivity check before requests
- ✅ Timeout handling (configurable)
- ✅ Exponential backoff retry (up to 2 retries)
- ✅ Unified error mapping
- ✅ Request/response logging (development only)
- ✅ No token/password logging (security)

## 🔒 Security Best Practices

### Implemented

- ✅ Tokens stored in `flutter_secure_storage` (encrypted)
- ✅ No hardcoded API URLs or secrets in code
- ✅ No logging of sensitive data (tokens, passwords)
- ✅ Token expiration validation
- ✅ HTTPS warning in production mode
- ✅ Input validation before sending to backend
- ✅ Secure device ID generation and storage

### Optional (To Implement)

**Certificate Pinning:**

To enable certificate pinning in production:

1. Get your server's SSL certificate
2. Add it to `assets/certificates/` folder
3. Update `pubspec.yaml` to include the certificate
4. Modify `HttpClient` to use the certificate
5. Set `USE_CERTIFICATE_PINNING=true` in `.env`

Example implementation (add to `http_client.dart`):

```dart
import 'dart:io';

SecurityContext context = SecurityContext.defaultContext;
context.setTrustedCertificatesBytes(certificateBytes);
```

## 🧪 Testing

### Unit Tests

The project includes unit tests for:

- **Device Service:** Tests device ID generation and persistence
- **Auth Remote Datasource:** Tests API endpoint calls with mocked HTTP client

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/core/device/device_service_test.dart

# Generate test mocks
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📦 Dependencies

### Production Dependencies

| Package | Purpose |
|---------|---------|
| `http` | HTTP requests |
| `flutter_secure_storage` | Secure token storage |
| `device_info_plus` | Device identification |
| `connectivity_plus` | Network connectivity check |
| `flutter_bloc` | State management |
| `json_annotation` | JSON serialization annotations |
| `flutter_dotenv` | Environment variables |
| `uuid` | UUID generation |
| `equatable` | Value equality |

### Development Dependencies

| Package | Purpose |
|---------|---------|
| `build_runner` | Code generation |
| `json_serializable` | JSON serialization generator |
| `mockito` | Mocking for tests |
| `flutter_test` | Testing framework |

## 🎨 UI/UX Features

- **Material Design 3** with modern aesthetics
- **RTL Support** for Arabic text
- **Form Validation** with inline error messages
- **Loading States** with progress indicators
- **Success/Error Snackbars** for user feedback
- **Smooth Animations** using Flutter's built-in widgets
- **Responsive Design** adapts to different screen sizes
- **Accessibility** support with semantic widgets

## 📝 API Endpoints Used

All endpoints are documented in `API_Doc/` folder:

- `POST /api/trpc/auth.signUp` - Create new account
- `POST /api/trpc/auth.signIn` - Authenticate user
- `POST /api/trpc/auth.sendEmailVerificationOTP` - Send OTP to email
- `POST /api/trpc/auth.verifyEmailOTP` - Verify email with OTP
- `GET /api/trpc/auth.getMe` - Get current user (protected)
- `POST /api/trpc/auth.updateProfile` - Update user profile (protected)
- `POST /api/trpc/auth.signOut` - Sign out (protected)

## 🐛 Troubleshooting

### Issue: "Connection refused" error

**Solution:** Make sure your backend server is running and the `API_BASE_URL` in `.env` is correct.

```bash
# Test if backend is accessible
curl http://localhost:3000/api/trpc/auth.getMe
```

### Issue: "Token expired" immediately after login

**Solution:** Check that your backend is returning a valid `expiresAt` timestamp in ISO 8601 format.

### Issue: "Device ID not generated on iOS"

**Solution:** Ensure you have the proper permissions in `Info.plist`. The app will fallback to UUID generation.

### Issue: Build runner errors

**Solution:** Delete generated files and regenerate:

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Tests failing with "MissingStubError"

**Solution:** Regenerate mocks:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🚀 Production Deployment Checklist

- [ ] Change `API_BASE_URL` to production URL in `.env`
- [ ] Set `ENVIRONMENT=production` in `.env`
- [ ] Enable `USE_CERTIFICATE_PINNING=true` (after implementing)
- [ ] Test all authentication flows on staging environment
- [ ] Run `flutter test` to ensure all tests pass
- [ ] Build release version (`flutter build apk --release`)
- [ ] Test on physical devices (Android & iOS)
- [ ] Verify no sensitive data is logged
- [ ] Enable ProGuard/R8 for Android (obfuscation)
- [ ] Submit to App Store / Play Store

## 📄 License

This project is licensed under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

For issues or questions:

1. Check the troubleshooting section above
2. Review API documentation in `API_Doc/` folder
3. Open an issue on GitHub
4. Contact support team

---

**Built with ❤️ using Flutter & Clean Architecture**
