import 'package:flutter/material.dart';

class PalmVeinEnrollmentScreen extends StatelessWidget {
  const PalmVeinEnrollmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Palm Vein Enrollment')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Palm vein enrollment will be available here.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
