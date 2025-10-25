// Verify Email Screen - OTP verification screen
// Allows users to verify their email with 6-digit OTP code

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'profile_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  int _expiresIn = 300; // 5 minutes default

  @override
  void initState() {
    super.initState();
    // Auto-send OTP on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().sendEmailVerificationOtp(widget.email);
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerifyOtp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().verifyEmailOtp(
            email: widget.email,
            otp: _otpController.text.trim(),
          );
    }
  }

  void _handleResendOtp() {
    _otpController.clear();
    context.read<AuthCubit>().sendEmailVerificationOtp(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحقق من البريد الإلكتروني'),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpSent) {
            setState(() {
              _expiresIn = state.expiresIn;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AuthEmailVerified) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Icon
                      Icon(
                        Icons.mark_email_read,
                        size: 80,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 32),

                      // Title
                      const Text(
                        'التحقق من البريد',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Email Display
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.email, color: Colors.blue),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.email,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Instructions
                      Text(
                        'تم إرسال رمز التحقق المكون من 6 أرقام إلى بريدك الإلكتروني',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Expiry Info
                      Text(
                        'الرمز صالح لمدة ${(_expiresIn / 60).ceil()} دقيقة',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[700],
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // OTP Field
                      CustomTextField(
                        label: 'رمز التحقق',
                        hintText: 'أدخل الرمز المكون من 6 أرقام',
                        controller: _otpController,
                        validator: AuthValidators.validateOtp,
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(Icons.security),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 24),

                      // Verify Button
                      CustomButton(
                        text: 'تحقق',
                        onPressed: _handleVerifyOtp,
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Resend Button
                      TextButton(
                        onPressed: isLoading ? null : _handleResendOtp,
                        child: const Text(
                          'إعادة إرسال الرمز',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Note
                      Text(
                        'تحقق من مجلد الرسائل غير المرغوب فيها إذا لم تستلم الرمز',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
