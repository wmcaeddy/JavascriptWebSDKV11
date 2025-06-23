import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import '../models/config_model.dart';

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();
  factory ConfigService() => _instance;
  ConfigService._internal();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  AppConfig? _config;

  AppConfig? get config => _config;

  /// Initialize configuration from file or secure storage
  Future<AppConfig> initializeConfig() async {
    try {
      // First try to load from local config.json file
      _config = await _loadConfigFromFile();
      
      if (_config != null) {
        // Save to secure storage for future use
        await _saveConfigToSecureStorage(_config!);
        return _config!;
      }
    } catch (e) {
      print('Failed to load config from file: $e');
    }

    try {
      // Fallback to secure storage
      _config = await _loadConfigFromSecureStorage();
      if (_config != null) {
        return _config!;
      }
    } catch (e) {
      print('Failed to load config from secure storage: $e');
    }

    throw Exception(
      'No configuration found. Please create config.json file with your credentials.'
    );
  }

  /// Load configuration from config.json file
  Future<AppConfig?> _loadConfigFromFile() async {
    try {
      // Try loading from assets first (for bundled config)
      try {
        final String configString = await rootBundle.loadString('config.json');
        final Map<String, dynamic> configJson = json.decode(configString);
        return AppConfig.fromJson(configJson);
      } catch (e) {
        // If not found in assets, try loading from app documents directory
        final Directory appDir = await getApplicationDocumentsDirectory();
        final File configFile = File('${appDir.path}/config.json');
        
        if (await configFile.exists()) {
          final String configString = await configFile.readAsString();
          final Map<String, dynamic> configJson = json.decode(configString);
          return AppConfig.fromJson(configJson);
        }
      }
      return null;
    } catch (e) {
      print('Error loading config from file: $e');
      return null;
    }
  }

  /// Load configuration from secure storage
  Future<AppConfig?> _loadConfigFromSecureStorage() async {
    try {
      final String? configString = await _storage.read(key: 'app_config');
      if (configString != null) {
        final Map<String, dynamic> configJson = json.decode(configString);
        return AppConfig.fromJson(configJson);
      }
      return null;
    } catch (e) {
      print('Error loading config from secure storage: $e');
      return null;
    }
  }

  /// Save configuration to secure storage
  Future<void> _saveConfigToSecureStorage(AppConfig config) async {
    try {
      final String configString = json.encode(config.toJson());
      await _storage.write(key: 'app_config', value: configString);
    } catch (e) {
      print('Error saving config to secure storage: $e');
    }
  }

  /// Update configuration and save to secure storage
  Future<void> updateConfig(AppConfig newConfig) async {
    _config = newConfig;
    await _saveConfigToSecureStorage(newConfig);
  }

  /// Clear all stored configuration
  Future<void> clearConfig() async {
    _config = null;
    await _storage.delete(key: 'app_config');
  }

  /// Check if configuration is loaded and valid
  bool isConfigured() {
    return _config != null &&
        _config!.apiConfig.xApiKey.isNotEmpty &&
        _config!.apiConfig.jwtToken.isNotEmpty;
  }

  /// Get API headers for Gemalto requests
  Map<String, String> getApiHeaders() {
    if (_config == null) {
      throw Exception('Configuration not loaded');
    }
    
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_config!.apiConfig.jwtToken}',
      'X-API-KEY': _config!.apiConfig.xApiKey,
      'Accept': 'application/json',
    };
  }

  /// Get Acuant credentials as base64 encoded string
  String getAcuantCredentials() {
    if (_config == null) {
      throw Exception('Configuration not loaded');
    }
    
    final credentials = '${_config!.acuantConfig.idUsername}:${_config!.acuantConfig.idPassword}';
    return base64Encode(utf8.encode(credentials));
  }

  /// Get Acuant passive liveness credentials
  String getAcuantPassiveCredentials() {
    if (_config == null) {
      throw Exception('Configuration not loaded');
    }
    
    final credentials = '${_config!.acuantConfig.passiveUsername}:${_config!.acuantConfig.passivePassword}';
    return base64Encode(utf8.encode(credentials));
  }
} 