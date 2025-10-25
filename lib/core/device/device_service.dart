// Device Service - Handles device identification across platforms
// Generates and persists a unique device ID for authentication

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';
import '../config/env.dart';
import '../storage/secure_storage_service.dart';

class DeviceService {
  final DeviceInfoPlugin _deviceInfo;
  final SecureStorageService _storage;

  DeviceService({
    DeviceInfoPlugin? deviceInfo,
    required SecureStorageService storage,
  })  : _deviceInfo = deviceInfo ?? DeviceInfoPlugin(),
        _storage = storage;

  /// Gets a unique device ID
  /// - On Android: uses androidId
  /// - On iOS: uses identifierForVendor
  /// - Fallback: generates and persists a UUID
  Future<String> getDeviceId() async {
    // Check if we already have a stored device ID
    final storedDeviceId = await _storage.read(AppConfig.storageKeyDeviceId);
    if (storedDeviceId != null && storedDeviceId.isNotEmpty) {
      return storedDeviceId;
    }

    String deviceId;

    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? _generateUuid();
      } else {
        // Fallback for other platforms
        deviceId = _generateUuid();
      }
    } catch (e) {
      // If platform-specific ID retrieval fails, generate UUID
      deviceId = _generateUuid();
    }

    // Store the device ID for future use
    await _storage.write(AppConfig.storageKeyDeviceId, deviceId);

    return deviceId;
  }

  /// Generates a new UUID
  String _generateUuid() {
    return const Uuid().v4();
  }

  /// Clears the stored device ID (useful for testing)
  Future<void> clearDeviceId() async {
    await _storage.delete(AppConfig.storageKeyDeviceId);
  }
}
