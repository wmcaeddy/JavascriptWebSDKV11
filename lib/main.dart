import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/webview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter IDV',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PermissionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool _permissionsGranted = false;
  bool _checkingPermissions = true;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final microphoneStatus = await Permission.microphone.status;
    
    setState(() {
      _permissionsGranted = cameraStatus.isGranted && microphoneStatus.isGranted;
      _checkingPermissions = false;
    });

    if (_permissionsGranted) {
      _navigateToWebView();
    }
  }

  Future<void> _requestPermissions() async {
    setState(() {
      _checkingPermissions = true;
    });

    final Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    final bool allGranted = statuses.values.every((status) => status.isGranted);
    
    setState(() {
      _permissionsGranted = allGranted;
      _checkingPermissions = false;
    });

    if (allGranted) {
      _navigateToWebView();
    } else {
      _showPermissionDialog();
    }
  }

  void _navigateToWebView() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const WebViewScreen()),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permissions Required'),
          content: const Text(
            'This app requires camera and microphone permissions to function properly. '
            'Please grant these permissions in your device settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identity Verification'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _permissionsGranted ? Icons.check_circle : Icons.security,
                size: 100,
                color: _permissionsGranted ? Colors.green : Colors.blue,
              ),
              const SizedBox(height: 32),
              Text(
                'Permission Setup',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'This application needs camera and microphone access to capture '
                'identity documents and perform face verification.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (_checkingPermissions)
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Checking permissions...'),
                  ],
                )
              else if (_permissionsGranted)
                const Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 32),
                    SizedBox(height: 8),
                    Text('Permissions granted. Redirecting...'),
                  ],
                )
              else
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: _requestPermissions,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Grant Permissions'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _checkPermissions,
                      child: const Text('Check Again'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
} 