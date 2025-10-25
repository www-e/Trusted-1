// Device Service Tests - Tests device ID generation and persistence
// Validates fallback UUID generation when platform info unavailable

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trusted_app/core/config/env.dart';
import 'package:trusted_app/core/device/device_service.dart';
import 'package:trusted_app/core/storage/secure_storage_service.dart';

@GenerateMocks([SecureStorageService])
import 'device_service_test.mocks.dart';

void main() {
  late DeviceService deviceService;
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockStorage = MockSecureStorageService();
    deviceService = DeviceService(storage: mockStorage);
  });

  group('DeviceService', () {
    test('should return stored device ID if exists', () async {
      // Arrange
      const storedDeviceId = 'stored-device-id';
      when(mockStorage.read(AppConfig.storageKeyDeviceId))
          .thenAnswer((_) async => storedDeviceId);

      // Act
      final result = await deviceService.getDeviceId();

      // Assert
      expect(result, storedDeviceId);
      verify(mockStorage.read(AppConfig.storageKeyDeviceId)).called(1);
      verifyNever(mockStorage.write(any, any));
    });

    test('should generate and store UUID when no stored ID exists', () async {
      // Arrange
      when(mockStorage.read(AppConfig.storageKeyDeviceId))
          .thenAnswer((_) async => null);
      when(mockStorage.write(any, any)).thenAnswer((_) async {});

      // Act
      final result = await deviceService.getDeviceId();

      // Assert
      expect(result, isNotEmpty);
      expect(result.length, 36); // UUID v4 length
      verify(mockStorage.read(AppConfig.storageKeyDeviceId)).called(1);
      verify(mockStorage.write(AppConfig.storageKeyDeviceId, result)).called(1);
    });

    test('should clear device ID', () async {
      // Arrange
      when(mockStorage.delete(AppConfig.storageKeyDeviceId))
          .thenAnswer((_) async {});

      // Act
      await deviceService.clearDeviceId();

      // Assert
      verify(mockStorage.delete(AppConfig.storageKeyDeviceId)).called(1);
    });
  });
}
