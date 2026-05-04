import 'package:flutter/material.dart';
import 'package:vein_pay_wallet/views/layout/main_screen.dart';

class TransactionStatusScreen extends StatelessWidget {
  const TransactionStatusScreen({
    super.key,
    required this.isSuccess,
    required this.amount,
  });

  final bool isSuccess;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                color: isSuccess ? Colors.greenAccent : Colors.redAccent,
                size: 120,
              ),
              const SizedBox(height: 30),
              Text(
                isSuccess ? 'Payment Successful!' : 'Payment Failed',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (isSuccess)
                Text(
                  'You paid ₹ $amount to Green Grocers.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey[400]),
                ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MainScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
