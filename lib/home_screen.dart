import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BiometricButtonScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isAuthenticated');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => BiometricButtonScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Biometric Authentication Successful!',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
