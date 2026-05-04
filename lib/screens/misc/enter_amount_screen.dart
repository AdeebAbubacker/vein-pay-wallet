// --- Payment Flow Screens ---

import 'package:flutter/material.dart';
import 'package:vein_pay_wallet/screens/misc/confirm_apyment_screen.dart';

class EnterAmountScreen extends StatefulWidget {
  const EnterAmountScreen({super.key});

  @override
  State<EnterAmountScreen> createState() => _EnterAmountScreenState();
}

class _EnterAmountScreenState extends State<EnterAmountScreen> {
  String _amount = "0";

  void _onKeyPress(String value) {
    setState(() {
      if (value == "<-") {
        _amount = _amount.length > 1
            ? _amount.substring(0, _amount.length - 1)
            : "0";
      } else {
        if (_amount == "0") {
          _amount = value;
        } else {
          _amount += value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Amount')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                '₹ $_amount',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Custom Numeric Keypad
          _buildKeypad(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: (double.tryParse(_amount) ?? 0) > 0
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ConfirmPaymentScreen(amount: _amount),
                        ),
                      );
                    }
                  : null,
              child: const Text('Proceed to Pay'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2,
      children: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '<-']
          .map((key) {
            return InkWell(
              onTap: () => _onKeyPress(key),
              child: Center(
                child: Text(
                  key,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          })
          .toList(),
    );
  }
}
