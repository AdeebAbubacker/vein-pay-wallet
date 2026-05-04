import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vein_pay_wallet/screens/misc/transaction_status_screen.dart';

class ConfirmPaymentScreen extends StatelessWidget {
  final String amount;
  const ConfirmPaymentScreen({super.key, required this.amount});

  void _showAuthenticationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Simulate a delay for biometric scanning
        Timer(const Duration(seconds: 3), () {
          Navigator.of(context).pop(); // Close the dialog
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionStatusScreen(
                isSuccess: true, // Simulate success
                amount: amount,
              ),
            ),
          );
        });

        return const AlertDialog(
          title: Text('Authenticating...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              SizedBox(height: 20),
              Text('Scanning palm vein... Please hold still.'),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Payment')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Paying to:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const Text(
              'Green Grocers',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Text(
              '₹ $amount',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.fingerprint),
              label: const Text('Confirm & Scan Palm'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              onPressed: () => _showAuthenticationDialog(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
