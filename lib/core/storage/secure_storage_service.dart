// Secure Storage Service - Manages secure storage operations using flutter_secure_storage
// All token and sensitive data storage goes through this service

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  // Android options for secure storage
  static const AndroidOptions _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  // iOS options for secure storage
  static const IOSOptions _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: _androidOptions,
              iOptions: _iosOptions,
            );

  /// Write a value securely
  Future<void> write(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  /// Read a value securely
  Future<String?> read(String key) async {
    return await _storage.read(
      key: key,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  /// Delete a specific key
  Future<void> delete(String key) async {
    await _storage.delete(
      key: key,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  /// Delete all stored data
  Future<void> deleteAll() async {
    await _storage.deleteAll(
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  /// Check if a key exists
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(
      key: key,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  /// Get all keys
  Future<Map<String, String>> readAll() async {
    return await _storage.readAll(
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }
}
