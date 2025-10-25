# ⚡ Quick Start Guide

## Step 1: Verify Installation ✅

All dependencies are already installed. You're ready to go!

## Step 2: Configure Backend URL 🌐

Edit `.env` file and update the backend URL:

```env
API_BASE_URL=http://YOUR_BACKEND_IP:3000/api/trpc
```

Replace `YOUR_BACKEND_IP` with your actual backend server IP address.

## Step 3: Run the App 🚀

```bash
flutter run
```

Or select your device in your IDE and press **Run**.

## Step 4: Test the Features 🧪

### Sign Up Flow
1. Open the app → Click "إنشاء حساب جديد"
2. Fill in:
   - Username (required, 3-20 chars)
   - Email (required)
   - Password (required, min 8 chars)
   - Name, Phone (optional)
3. Click "إنشاء الحساب"
4. You'll be redirected to email verification screen

### Email Verification
1. Check your email for the 6-digit OTP code
2. Enter the code
3. Click "تحقق"
4. You'll be redirected to profile screen

### Sign In Flow
1. From sign in screen, enter username and password
2. Click "تسجيل الدخول"
3. You'll be redirected to profile screen

### Profile Management
1. View your account information
2. Toggle "تعديل المعلومات" switch to edit
3. Update name or phone numbers
4. Click "حفظ التغييرات"

### Sign Out
1. Click logout icon in app bar
2. Confirm sign out
3. You'll be redirected to sign in screen

## Troubleshooting 🔧

### "Connection refused" error
- Make sure your backend server is running
- Verify the `API_BASE_URL` in `.env` is correct
- If using emulator, use `10.0.2.2` instead of `localhost`

### "Token expired" immediately
- Check backend returns valid `expiresAt` in ISO 8601 format
- Example: `2025-10-29T18:00:00.000Z`

### Build errors
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## Emulator IP Addresses 📱

- **Android Emulator**: Use `http://10.0.2.2:3000/api/trpc`
- **iOS Simulator**: Use `http://localhost:3000/api/trpc`
- **Physical Device**: Use your computer's LAN IP (e.g., `http://192.168.1.100:3000/api/trpc`)

## Project Structure at a Glance 📂

```
lib/
├── core/               # Shared utilities (network, storage, config)
├── features/auth/      # Authentication feature
│   ├── data/          # Models, API calls, repositories
│   ├── domain/        # Business logic interfaces
│   └── presentation/  # UI (screens, widgets, state management)
└── main.dart          # App entry point
```

## Commands Cheat Sheet 📝

```bash
# Install dependencies
flutter pub get

# Generate code (JSON serialization, mocks)
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Run tests
flutter test

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release

# Clean build
flutter clean
```

## Next Steps 🎯

1. ✅ App is ready to run
2. ✅ All code generated
3. ✅ Tests included
4. 📝 Start your backend server
5. 🚀 Run the app and test

## Need Help? 💬

Check the main [README.md](README.md) for:
- Full documentation
- Architecture details
- Security best practices
- API endpoints reference
- Advanced configuration

---

**Happy coding! 🎉**
