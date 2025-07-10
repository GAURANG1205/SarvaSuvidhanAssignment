import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class BiometricButtonScreen extends StatefulWidget {
  @override
  _BiometricButtonScreenState createState() => _BiometricButtonScreenState();
}

class _BiometricButtonScreenState extends State<BiometricButtonScreen> {
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    checkIfAlreadyAuthenticated();
  }

  Future<void> checkIfAlreadyAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    bool isAuthenticated = prefs.getBool('isAuthenticated') ?? false;

    if (isAuthenticated) {
      _navigateToHome();
    }
  }

  Future<void> authenticate() async {
    try {
      bool isDeviceSupported = await _auth.isDeviceSupported();
      bool canCheckBiometrics = await _auth.canCheckBiometrics;

      if (!isDeviceSupported || !canCheckBiometrics) {
        _showMessage("Biometric not supported on this device.");
        return;
      }

      bool authenticated = await _auth.authenticate(
        localizedReason: 'Authenticate using biometrics',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAuthenticated', true);
        _navigateToHome();
      } else {
        _showMessage("Authentication Failed");
      }
    } catch (e) {
      _showMessage("Error: $e");
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biometric Login'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: authenticate,
          icon: Icon(Icons.fingerprint, size: 28),
          label: Text('Authenticate with Biometrics'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
