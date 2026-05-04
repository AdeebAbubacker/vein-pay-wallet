import 'package:flutter/material.dart';
import 'package:vein_pay_wallet/screens/layout/main_screen.dart';

class PalmVeinEnrollmentScreen extends StatelessWidget {
  const PalmVeinEnrollmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Palm Vein Enrollment')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.camera_alt,
              size: 100,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 20),
            const Text(
              'Position your palm over the scanner to register your unique vein pattern.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            // Placeholder for the actual camera feed/guide
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'Scanner Area',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Simulate successful enrollment and navigate to the main app
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Scan & Complete Setup'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Main Application Screens (with Bottom Navigation) ---
