import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/config_service.dart';
import '../services/api_service.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  final ConfigService _configService = ConfigService();
  final ApiService _apiService = ApiService();
  
  bool _isLoading = true;
  String _currentStatus = 'Initializing...';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      // Initialize configuration
      await _configService.initializeConfig();
      
      // Initialize API service
      _apiService.initialize();
      
      // Test API connection
      final isHealthy = await _apiService.healthCheck();
      if (!isHealthy) {
        print('Warning: API health check failed');
      }
      
      // Initialize WebView
      await _initializeWebView();
      
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeWebView() async {
    late final PlatformWebViewControllerCreationParams params;
    
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);

    // Configure WebView settings
    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.setBackgroundColor(const Color(0x00000000));
    
    // Add JavaScript channels for communication
    await controller.addJavaScriptChannel(
      'messageHandler',
      onMessageReceived: _handleWebViewMessage,
    );

    // Set navigation delegate
    await controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          debugPrint('WebView loading progress: $progress%');
        },
        onPageStarted: (String url) {
          debugPrint('Page started loading: $url');
        },
        onPageFinished: (String url) async {
          debugPrint('Page finished loading: $url');
          
          // Send configuration to WebView
          await _sendConfigToWebView();
          
          setState(() {
            _isLoading = false;
          });
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint('WebView error: ${error.description}');
          setState(() {
            _errorMessage = 'WebView error: ${error.description}';
          });
        },
      ),
    );

    // Load the HTML file
    final String htmlPath = 'assets/web/index.html';
    await controller.loadFlutterAsset(htmlPath);

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  Future<void> _sendConfigToWebView() async {
    final config = _configService.config;
    if (config == null) return;

    final configMessage = {
      'type': 'config',
      'config': {
        'api_config': config.apiConfig.toJson(),
        'acuant_config': config.acuantConfig.toJson(),
      }
    };

    try {
      await _controller.runJavaScript('''
        window.postMessage(${json.encode(configMessage)}, '*');
      ''');
    } catch (e) {
      print('Failed to send config to WebView: $e');
    }
  }

  void _handleWebViewMessage(JavaScriptMessage message) {
    try {
      final data = json.decode(message.message) as Map<String, dynamic>;
      final messageType = data['type'] as String;
      final messageData = data['data'] as Map<String, dynamic>?;

      print('Received message from WebView: $messageType');

      switch (messageType) {
        case 'request_config':
          _sendConfigToWebView();
          break;
          
        case 'status_update':
          _handleStatusUpdate(messageData);
          break;
          
        case 'api_call':
          _handleApiCall(messageData);
          break;
          
        case 'document_captured':
          _handleDocumentCaptured(messageData);
          break;
          
        case 'biometric_captured':
          _handleBiometricCaptured(messageData);
          break;
          
        case 'error':
          _handleError(messageData);
          break;
          
        case 'verification_ready':
          _handleVerificationReady(messageData);
          break;
          
        case 'idcloud_verification_complete':
          _handleIdCloudVerificationComplete(messageData);
          break;
          
        case 'verification_completed':
          _handleVerificationCompleted(messageData);
          break;
          
        default:
          print('Unknown message type: $messageType');
      }
    } catch (e) {
      print('Error handling WebView message: $e');
    }
  }

  void _handleStatusUpdate(Map<String, dynamic>? data) {
    if (data != null && data['status'] != null) {
      setState(() {
        _currentStatus = data['status'] as String;
      });
    }
  }

  Future<void> _handleApiCall(Map<String, dynamic>? data) async {
    if (data == null) return;

    final method = data['method'] as String;
    final params = data['params'] as Map<String, dynamic>? ?? {};
    final requestId = data['request_id'] as String;

    try {
      dynamic result;
      
      switch (method) {
        case 'initiate_document_verification':
          result = await _apiService.initiateDocumentVerification(
            frontImageBase64: params['front_image'] as String,
            documentType: params['document_type'] as String?,
            documentSize: params['document_size'] as String?,
            captureMethod: params['capture_method'] as String? ?? 'SDKMobile',
          );
          break;
          
        case 'send_document_image':
          result = await _apiService.sendDocumentImage(
            scenarioId: params['scenario_id'] as String,
            imageType: params['image_type'] as String,
            imageBase64: params['image_base64'] as String,
          );
          break;
          
        case 'submit_front_document':
          result = await _apiService.submitFrontDocument(
            frontImageBase64: params['front_image'] as String,
            documentType: params['document_type'] as String?,
            documentSize: params['document_size'] as String?,
          );
          break;
          
        case 'submit_back_document':
          result = await _apiService.submitBackDocument(
            scenarioId: params['scenario_id'] as String,
            backImageBase64: params['back_image'] as String,
          );
          break;
          
        case 'get_verification_results':
          result = await _apiService.getVerificationResults(
            scenarioId: params['scenario_id'] as String,
          );
          break;
          
        case 'get_scenario_status':
          result = await _apiService.getScenarioStatus(
            params['scenario_id'] as String,
          );
          break;
          
        case 'complete_document_verification':
          result = await _apiService.completeDocumentVerification(
            scenarioId: params['scenario_id'] as String,
          );
          break;
          
        default:
          throw Exception('Unknown API method: $method');
      }

      // Send success response back to WebView
      await _sendApiResponse(requestId, result, null);
      
    } catch (e) {
      print('API call failed: $method - $e');
      await _sendApiResponse(requestId, null, e.toString());
    }
  }

  Future<void> _sendApiResponse(String requestId, dynamic response, String? error) async {
    try {
      await _controller.runJavaScript('''
        if (window.handleApiResponse) {
          window.handleApiResponse('$requestId', ${json.encode(response)}, ${json.encode(error)});
        }
      ''');
    } catch (e) {
      print('Failed to send API response: $e');
    }
  }

  void _handleDocumentCaptured(Map<String, dynamic>? data) {
    print('Document captured and verification initiated: ${data?['scenario_id']}');
    // Handle document capture and verification initiation success
    _showSnackBar('Document captured and verification initiated', Colors.green);
  }

  void _handleBiometricCaptured(Map<String, dynamic>? data) {
    print('Biometric captured: ${data?['scenario_id']}');
    // Handle biometric capture success
    _showSnackBar('Face verification completed', Colors.green);
  }

  void _handleError(Map<String, dynamic>? data) {
    final errorType = data?['type'] as String? ?? 'unknown';
    final errorMessage = data?['error'] as String? ?? 'Unknown error occurred';
    
    print('WebView error: $errorType - $errorMessage');
    _showSnackBar('Error: $errorMessage', Colors.red);
  }

  void _handleVerificationReady(Map<String, dynamic>? data) {
    print('Verification ready for document capture');
    _showSnackBar('Ready for document capture', Colors.blue);
  }

  void _handleIdCloudVerificationComplete(Map<String, dynamic>? data) {
    print('IdCloud verification complete: ${data?['scenario_id']}');
    _showSnackBar('Verification results retrieved from IdCloud', Colors.green);
  }

  void _handleVerificationCompleted(Map<String, dynamic>? data) {
    print('Verification completed: ${data?['scenario_id']}');
    _showSnackBar('Document verification completed successfully', Colors.green);
  }

  void _showSnackBar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identity Verification'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Status bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Status: $_currentStatus',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (_isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
          
          // Content area
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_errorMessage != null) {
      return _buildErrorView();
    }

    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading verification interface...'),
          ],
        ),
      );
    }

    return WebViewWidget(controller: _controller);
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Configuration Error',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Please ensure you have created a config.json file with your credentials.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                  _isLoading = true;
                });
                _initializeServices();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
} 