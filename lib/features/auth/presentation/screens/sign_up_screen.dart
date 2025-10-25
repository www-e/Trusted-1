// Sign Up Screen - User registration screen
// Collects user information and creates new account

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'sign_in_screen.dart';
import 'verify_email_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _secondPhoneController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _secondPhoneController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signUp(
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            name: _nameController.text.trim().isEmpty
                ? null
                : _nameController.text.trim(),
            phoneNumber: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
            secondPhone: _secondPhoneController.text.trim().isEmpty
                ? null
                : _secondPhoneController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => VerifyEmailScreen(email: state.user.email),
              ),
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
                      // Logo/Icon
                      Icon(
                        Icons.person_add,
                        size: 80,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 32),

                      // Title
                      const Text(
                        'إنشاء حساب جديد',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'املأ البيانات للتسجيل',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Username Field (Required)
                      CustomTextField(
                        label: 'اسم المستخدم *',
                        hintText: 'أدخل اسم المستخدم',
                        controller: _usernameController,
                        validator: AuthValidators.validateUsername,
                        prefixIcon: const Icon(Icons.person),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Email Field (Required)
                      CustomTextField(
                        label: 'البريد الإلكتروني *',
                        hintText: 'أدخل البريد الإلكتروني',
                        controller: _emailController,
                        validator: AuthValidators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Password Field (Required)
                      CustomTextField(
                        label: 'كلمة المرور *',
                        hintText: 'أدخل كلمة المرور',
                        controller: _passwordController,
                        validator: AuthValidators.validatePassword,
                        isPassword: true,
                        prefixIcon: const Icon(Icons.lock),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Name Field (Optional)
                      CustomTextField(
                        label: 'الاسم الكامل',
                        hintText: 'أدخل الاسم الكامل (اختياري)',
                        controller: _nameController,
                        validator: AuthValidators.validateName,
                        prefixIcon: const Icon(Icons.badge),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Phone Field (Optional)
                      CustomTextField(
                        label: 'رقم الهاتف',
                        hintText: 'أدخل رقم الهاتف (اختياري)',
                        controller: _phoneController,
                        validator: AuthValidators.validatePhone,
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Second Phone Field (Optional)
                      CustomTextField(
                        label: 'رقم هاتف إضافي',
                        hintText: 'أدخل رقم هاتف إضافي (اختياري)',
                        controller: _secondPhoneController,
                        validator: AuthValidators.validatePhone,
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone_android),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 24),

                      // Sign Up Button
                      CustomButton(
                        text: 'إنشاء الحساب',
                        onPressed: _handleSignUp,
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Sign In Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'لديك حساب؟ ',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => const SignInScreen(),
                                      ),
                                    );
                                  },
                            child: const Text(
                              'تسجيل الدخول',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
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
