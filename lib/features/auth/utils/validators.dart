// Form Validators - Validates user input for authentication forms
// Provides consistent validation logic across all forms

class AuthValidators {
  AuthValidators._();

  /// Username validation (3-20 chars, alphanumeric + underscore)
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'اسم المستخدم مطلوب';
    }

    if (value.length < 3) {
      return 'اسم المستخدم يجب أن يكون 3 أحرف على الأقل';
    }

    if (value.length > 20) {
      return 'اسم المستخدم يجب أن يكون 20 حرف كحد أقصى';
    }

    // Alphanumeric + underscore only
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'اسم المستخدم يجب أن يحتوي على حروف وأرقام و _ فقط';
    }

    return null;
  }

  /// Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }

    // RFC 5322 compliant email regex (simplified)
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'البريد الإلكتروني غير صالح';
    }

    return null;
  }

  /// Password validation (min 8 chars)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }

    if (value.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }

    return null;
  }

  /// OTP validation (6 digits)
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'رمز التحقق مطلوب';
    }

    if (value.length != 6) {
      return 'رمز التحقق يجب أن يكون 6 أرقام';
    }

    final otpRegex = RegExp(r'^\d{6}$');
    if (!otpRegex.hasMatch(value)) {
      return 'رمز التحقق يجب أن يحتوي على أرقام فقط';
    }

    return null;
  }

  /// Phone number validation (optional)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    // Simple international phone format
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'رقم الهاتف غير صالح';
    }

    return null;
  }

  /// Name validation (optional)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    if (value.length < 2) {
      return 'الاسم يجب أن يكون حرفين على الأقل';
    }

    return null;
  }
}
