// Auth Remote Datasource Tests - Tests API endpoint calls
// Validates request/response handling for authentication endpoints

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trusted_app/core/network/http_client.dart';
import 'package:trusted_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:trusted_app/features/auth/data/models/auth_request_models.dart';

@GenerateMocks([HttpClient])
import 'auth_remote_datasource_test.mocks.dart';

void main() {
  late AuthRemoteDatasource datasource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = AuthRemoteDatasource(httpClient: mockHttpClient);
  });

  group('AuthRemoteDatasource', () {
    group('signUp', () {
      test('should make POST request to auth.signUp endpoint', () async {
        // Arrange
        final request = SignUpRequestModel(
          username: 'testuser',
          email: 'test@example.com',
          password: 'password123',
          deviceId: 'device-123',
        );

        final mockResponse = {
          'result': {
            'data': {
              'success': true,
              'message': 'Account created successfully',
              'user': {
                'id': 'user123',
                'username': 'testuser',
                'email': 'test@example.com',
                'emailVerified': false,
                'role': 'user',
                'createdAt': '2025-01-01T00:00:00.000Z',
                'updatedAt': '2025-01-01T00:00:00.000Z',
              },
              'session': {
                'id': 'session123',
                'token': 'token123',
                'expiresAt': '2025-01-08T00:00:00.000Z',
              },
            },
          },
        };

        when(mockHttpClient.post(
          'auth.signUp',
          body: anyNamed('body'),
          requiresAuth: false,
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await datasource.signUp(request);

        // Assert
        expect(result.success, true);
        expect(result.user.username, 'testuser');
        expect(result.session.token, 'token123');
        verify(mockHttpClient.post(
          'auth.signUp',
          body: request.toJson(),
          requiresAuth: false,
        )).called(1);
      });
    });

    group('signIn', () {
      test('should make POST request to auth.signIn endpoint', () async {
        // Arrange
        final request = SignInRequestModel(
          username: 'testuser',
          password: 'password123',
          deviceId: 'device-123',
        );

        final mockResponse = {
          'result': {
            'data': {
              'success': true,
              'message': 'Signed in successfully',
              'session': {
                'user': {
                  'id': 'user123',
                  'username': 'testuser',
                  'email': 'test@example.com',
                  'emailVerified': true,
                  'role': 'user',
                  'createdAt': '2025-01-01T00:00:00.000Z',
                  'updatedAt': '2025-01-01T00:00:00.000Z',
                },
                'session': {
                  'id': 'session123',
                  'token': 'token123',
                  'expiresAt': '2025-01-08T00:00:00.000Z',
                },
              },
            },
          },
        };

        when(mockHttpClient.post(
          'auth.signIn',
          body: anyNamed('body'),
          requiresAuth: false,
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await datasource.signIn(request);

        // Assert
        expect(result.success, true);
        expect(result.session.user.username, 'testuser');
        expect(result.session.session.token, 'token123');
        verify(mockHttpClient.post(
          'auth.signIn',
          body: request.toJson(),
          requiresAuth: false,
        )).called(1);
      });
    });

    group('sendEmailVerificationOtp', () {
      test('should make POST request to auth.sendEmailVerificationOTP',
          () async {
        // Arrange
        final request = SendEmailOtpRequestModel(email: 'test@example.com');

        final mockResponse = {
          'result': {
            'data': {
              'success': true,
              'message': 'Verification code sent to your email',
              'email': 'test@example.com',
              'expiresIn': 300,
            },
          },
        };

        when(mockHttpClient.post(
          'auth.sendEmailVerificationOTP',
          body: anyNamed('body'),
          requiresAuth: false,
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await datasource.sendEmailVerificationOtp(request);

        // Assert
        expect(result.success, true);
        expect(result.email, 'test@example.com');
        expect(result.expiresIn, 300);
        verify(mockHttpClient.post(
          'auth.sendEmailVerificationOTP',
          body: request.toJson(),
          requiresAuth: false,
        )).called(1);
      });
    });

    group('getMe', () {
      test('should make GET request to auth.getMe endpoint with auth',
          () async {
        // Arrange
        final mockResponse = {
          'result': {
            'data': {
              'user': {
                'id': 'user123',
                'username': 'testuser',
                'email': 'test@example.com',
                'emailVerified': true,
                'role': 'user',
                'createdAt': '2025-01-01T00:00:00.000Z',
                'updatedAt': '2025-01-01T00:00:00.000Z',
              },
              'session': {
                'id': 'session123',
                'token': 'token123',
                'expiresAt': '2025-01-08T00:00:00.000Z',
              },
            },
          },
        };

        when(mockHttpClient.get(
          'auth.getMe',
          requiresAuth: true,
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await datasource.getMe();

        // Assert
        expect(result.user.username, 'testuser');
        expect(result.session.token, 'token123');
        verify(mockHttpClient.get(
          'auth.getMe',
          requiresAuth: true,
        )).called(1);
      });
    });
  });
}
