// Profile Screen - User profile management screen
// Displays user info and allows profile updates

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../../utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'sign_in_screen.dart';
import 'verify_email_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _secondPhoneController = TextEditingController();

  bool _isEditMode = false;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    // Load current user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().getCurrentUser();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _secondPhoneController.dispose();
    super.dispose();
  }

  void _populateFields(UserModel user) {
    _currentUser = user;
    _nameController.text = user.name ?? '';
    _phoneController.text = user.phoneNumber ?? '';
    _secondPhoneController.text = user.secondPhone ?? '';
  }

  void _handleUpdateProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().updateProfile(
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

  void _handleSignOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().signOut();
            },
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleSignOut,
            tooltip: 'تسجيل الخروج',
          ),
        ],
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            _populateFields(state.user);
            if (_isEditMode) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تحديث الملف الشخصي'),
                  backgroundColor: Colors.green,
                ),
              );
              setState(() {
                _isEditMode = false;
              });
            }
          } else if (state is AuthProfileUpdated) {
            _populateFields(state.user);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            setState(() {
              _isEditMode = false;
            });
          } else if (state is AuthSignOutSuccess ||
              state is AuthUnauthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SignInScreen()),
              (route) => false,
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
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_currentUser == null) {
            return const Center(
              child: Text('لا توجد بيانات مستخدم'),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Avatar
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // User Info Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              'اسم المستخدم',
                              _currentUser!.username,
                              Icons.person,
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(
                              'البريد الإلكتروني',
                              _currentUser!.email,
                              Icons.email,
                            ),
                            const Divider(height: 24),
                            _buildVerificationRow(),
                            const Divider(height: 24),
                            _buildInfoRow(
                              'الدور',
                              _currentUser!.role,
                              Icons.admin_panel_settings,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Edit Mode Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'تعديل المعلومات',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          value: _isEditMode,
                          onChanged: (value) {
                            setState(() {
                              _isEditMode = value;
                              if (!value) {
                                // Reset to original values
                                _populateFields(_currentUser!);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Editable Fields
                    CustomTextField(
                      label: 'الاسم الكامل',
                      hintText: 'أدخل الاسم الكامل',
                      controller: _nameController,
                      validator: AuthValidators.validateName,
                      prefixIcon: const Icon(Icons.badge),
                      enabled: _isEditMode,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      label: 'رقم الهاتف',
                      hintText: 'أدخل رقم الهاتف',
                      controller: _phoneController,
                      validator: AuthValidators.validatePhone,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone),
                      enabled: _isEditMode,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      label: 'رقم هاتف إضافي',
                      hintText: 'أدخل رقم هاتف إضافي',
                      controller: _secondPhoneController,
                      validator: AuthValidators.validatePhone,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_android),
                      enabled: _isEditMode,
                    ),
                    const SizedBox(height: 24),

                    // Update Button
                    if (_isEditMode)
                      CustomButton(
                        text: 'حفظ التغييرات',
                        onPressed: _handleUpdateProfile,
                        isLoading: state is AuthLoading,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationRow() {
    final isVerified = _currentUser!.emailVerified;

    return Row(
      children: [
        Icon(
          isVerified ? Icons.verified : Icons.warning,
          color: isVerified ? Colors.green : Colors.orange,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'حالة التحقق',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isVerified ? 'تم التحقق' : 'غير محقق',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isVerified ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
        ),
        if (!isVerified)
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      VerifyEmailScreen(email: _currentUser!.email),
                ),
              );
            },
            child: const Text('تحقق الآن'),
          ),
      ],
    );
  }
}
