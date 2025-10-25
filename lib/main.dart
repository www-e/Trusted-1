// Main entry point - Sets up app configuration, DI, and routing
// Initializes environment variables and core services

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/config/env.dart';
import 'core/device/device_service.dart';
import 'core/network/http_client.dart';
import 'core/storage/secure_storage_service.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/auth/presentation/screens/profile_screen.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // If .env file not found, continue with defaults
    debugPrint('Warning: .env file not found, using default configuration');
  }

  // Validate configuration
  try {
    AppConfig.validate();
  } catch (e) {
    debugPrint('Configuration Warning: $e');
  }

  runApp(const TrustedApp());
}

class TrustedApp extends StatelessWidget {
  const TrustedApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize services (simple DI)
    final secureStorage = SecureStorageService();
    final httpClient = HttpClient(storage: secureStorage);
    final deviceService = DeviceService(storage: secureStorage);
    final authDatasource = AuthRemoteDatasource(httpClient: httpClient);
    final authRepository = AuthRepositoryImpl(
      remoteDatasource: authDatasource,
      storage: secureStorage,
    );

    return BlocProvider(
      create: (context) => AuthCubit(
        repository: authRepository,
        deviceService: deviceService,
      )..checkAuthStatus(),
      child: MaterialApp(
        title: 'Trusted App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

/// Auth Wrapper - Decides which screen to show based on auth state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // Show loading while checking auth status
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // User is authenticated
        if (state is AuthAuthenticated) {
          return const ProfileScreen();
        }

        // Default: Show sign in screen
        return const SignInScreen();
      },
    );
  }
}
