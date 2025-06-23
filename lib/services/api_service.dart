import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final ConfigService _configService = ConfigService();
  late final http.Client _client;

  void initialize() {
    _client = http.Client();
  }

  void dispose() {
    _client.close();
  }

  /// Initiate Document Verification (Step 1)
  /// POST /scs/v1/scenarios
  Future<Map<String, dynamic>> initiateDocumentVerification({
    required String frontImageBase64,
    String? documentType = 'Passport',
    String? documentSize = 'TD1',
    String captureMethod = 'SDKMobile',
  }) async {
    try {
      final config = _configService.config;
      if (config == null) {
        throw Exception('Configuration not loaded');
      }

      final uri = Uri.parse('${config.apiConfig.baseUrl}/scenarios');
      final headers = _configService.getApiHeaders();

      final body = {
        'name': 'Connect_Verify_Document',
        'input': {
          'captureMethod': captureMethod,
          'type': documentType,
          'size': documentSize,
          'frontWhiteImage': frontImageBase64,
        }
      };

      print('Making POST request to: $uri');
      print('Initiating document verification...');

      final response = await _client.post(
        uri,
        headers: headers,
        body: json.encode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw ApiException(
          'Failed to initiate document verification: ${response.statusCode}',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      print('Error initiating document verification: $e');
      rethrow;
    }
  }

  /// Send additional document images (Step 2)
  /// PATCH /scs/v1/scenarios/{scenario_id}/state/steps/{image_type}
  Future<Map<String, dynamic>> sendDocumentImage({
    required String scenarioId,
    required String imageType, // e.g., 'backWhiteImage', 'frontIRImage', etc.
    required String imageBase64,
  }) async {
    try {
      final config = _configService.config;
      if (config == null) {
        throw Exception('Configuration not loaded');
      }

      final uri = Uri.parse('${config.apiConfig.baseUrl}/scenarios/$scenarioId/state/steps/$imageType');
      final headers = _configService.getApiHeaders();

      final body = {
        'name': 'Connect_Verify_Document',
        'input': {
          imageType: imageBase64,
        }
      };

      print('Making PATCH request to: $uri');
      print('Sending $imageType for scenario: $scenarioId');

      final response = await _client.patch(
        uri,
        headers: headers,
        body: json.encode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw ApiException(
          'Failed to send document image: ${response.statusCode}',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      print('Error sending document image: $e');
      rethrow;
    }
  }

  /// Get verification results (Step 3)
  /// PATCH /scs/v1/scenarios/{scenario_id}/state/steps/verifyResults
  Future<Map<String, dynamic>> getVerificationResults({
    required String scenarioId,
  }) async {
    try {
      final config = _configService.config;
      if (config == null) {
        throw Exception('Configuration not loaded');
      }

      final uri = Uri.parse('${config.apiConfig.baseUrl}/scenarios/$scenarioId/state/steps/verifyResults');
      final headers = _configService.getApiHeaders();

      final body = {
        'name': 'Connect_Verify_Document'
      };

      print('Making PATCH request to: $uri');
      print('Getting verification results for scenario: $scenarioId');

      final response = await _client.patch(
        uri,
        headers: headers,
        body: json.encode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 204 || response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body) as Map<String, dynamic>;
        } else {
          // 204 No Content - need to poll scenario status
          return await getScenarioStatus(scenarioId);
        }
      } else {
        throw ApiException(
          'Failed to get verification results: ${response.statusCode}',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      print('Error getting verification results: $e');
      rethrow;
    }
  }

  /// Get scenario status
  /// GET /scs/v1/scenarios/{scenario_id}
  Future<Map<String, dynamic>> getScenarioStatus(String scenarioId) async {
    try {
      final config = _configService.config;
      if (config == null) {
        throw Exception('Configuration not loaded');
      }

      final uri = Uri.parse('${config.apiConfig.baseUrl}/scenarios/$scenarioId');
      final headers = _configService.getApiHeaders();

      print('Making GET request to: $uri');
      print('Getting scenario status for: $scenarioId');

      final response = await _client.get(uri, headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw ApiException(
          'Failed to get scenario status: ${response.statusCode}',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      print('Error getting scenario status: $e');
      rethrow;
    }
  }

  /// Helper method to submit front document image and initiate verification
  Future<Map<String, dynamic>> submitFrontDocument({
    required String frontImageBase64,
    String? documentType,
    String? documentSize,
  }) async {
    return await initiateDocumentVerification(
      frontImageBase64: frontImageBase64,
      documentType: documentType ?? 'Passport',
      documentSize: documentSize ?? 'TD1',
    );
  }

  /// Helper method to submit back document image
  Future<Map<String, dynamic>> submitBackDocument({
    required String scenarioId,
    required String backImageBase64,
  }) async {
    return await sendDocumentImage(
      scenarioId: scenarioId,
      imageType: 'backWhiteImage',
      imageBase64: backImageBase64,
    );
  }

  /// Submit IR (Infrared) images
  Future<Map<String, dynamic>> submitIRImage({
    required String scenarioId,
    required String imageBase64,
    required bool isFront, // true for front, false for back
  }) async {
    final imageType = isFront ? 'frontIRImage' : 'backIRImage';
    return await sendDocumentImage(
      scenarioId: scenarioId,
      imageType: imageType,
      imageBase64: imageBase64,
    );
  }

  /// Submit UV (Ultraviolet) images
  Future<Map<String, dynamic>> submitUVImage({
    required String scenarioId,
    required String imageBase64,
    required bool isFront, // true for front, false for back
  }) async {
    final imageType = isFront ? 'frontUVImage' : 'backUVImage';
    return await sendDocumentImage(
      scenarioId: scenarioId,
      imageType: imageType,
      imageBase64: imageBase64,
    );
  }

  /// Complete document verification workflow
  Future<Map<String, dynamic>> completeDocumentVerification({
    required String scenarioId,
  }) async {
    return await getVerificationResults(scenarioId: scenarioId);
  }

  /// Health check endpoint (if available)
  Future<bool> healthCheck() async {
    try {
      final config = _configService.config;
      if (config == null) {
        return false;
      }

      // Try a simple GET request to the base URL
      final uri = Uri.parse(config.apiConfig.baseUrl);
      final headers = _configService.getApiHeaders();

      final response = await _client.get(uri, headers: headers);
      return response.statusCode == 200 || response.statusCode == 404; // 404 is acceptable for base URL
    } catch (e) {
      print('Health check failed: $e');
      return false;
    }
  }

  /// Extract document data from verification results
  Map<String, dynamic>? extractDocumentData(Map<String, dynamic> verificationResult) {
    try {
      final state = verificationResult['state'] as Map<String, dynamic>?;
      if (state == null) return null;

      final result = state['result'] as Map<String, dynamic>?;
      if (result == null) return null;

      final object = result['object'] as Map<String, dynamic>?;
      if (object == null) return null;

      final document = object['document'] as Map<String, dynamic>?;
      return document;
    } catch (e) {
      print('Error extracting document data: $e');
      return null;
    }
  }

  /// Extract verification results from response
  Map<String, dynamic>? extractVerificationResults(Map<String, dynamic> response) {
    try {
      final documentData = extractDocumentData(response);
      if (documentData == null) return null;

      return documentData['verificationResults'] as Map<String, dynamic>?;
    } catch (e) {
      print('Error extracting verification results: $e');
      return null;
    }
  }

  /// Check if scenario is finished
  bool isScenarioFinished(Map<String, dynamic> scenarioResponse) {
    try {
      final status = scenarioResponse['status'] as String?;
      return status == 'Finished';
    } catch (e) {
      print('Error checking scenario status: $e');
      return false;
    }
  }

  /// Get scenario steps status
  List<Map<String, dynamic>>? getScenarioSteps(Map<String, dynamic> scenarioResponse) {
    try {
      final state = scenarioResponse['state'] as Map<String, dynamic>?;
      if (state == null) return null;

      final steps = state['steps'] as List<dynamic>?;
      return steps?.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error getting scenario steps: $e');
      return null;
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String responseBody;

  ApiException(this.message, this.statusCode, this.responseBody);

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)\nResponse: $responseBody';
  }
} 