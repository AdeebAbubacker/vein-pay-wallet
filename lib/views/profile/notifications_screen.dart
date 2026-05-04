import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _paymentAlerts = true;
  bool _transactionUpdates = true;
  bool _securityAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Alert Preferences',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'These switches work locally on this screen only and are not saved anywhere.',
                    style: TextStyle(color: Colors.grey[400], height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile.adaptive(
            value: _paymentAlerts,
            onChanged: (value) {
              setState(() {
                _paymentAlerts = value;
              });
            },
            title: const Text('Payment Alerts'),
            subtitle: const Text('Get notified when a payment is made'),
          ),
          SwitchListTile.adaptive(
            value: _transactionUpdates,
            onChanged: (value) {
              setState(() {
                _transactionUpdates = value;
              });
            },
            title: const Text('Transaction Updates'),
            subtitle: const Text(
              'See updates for successful and pending activity',
            ),
          ),
          SwitchListTile.adaptive(
            value: _securityAlerts,
            onChanged: (value) {
              setState(() {
                _securityAlerts = value;
              });
            },
            title: const Text('Security Alerts'),
            subtitle: const Text(
              'Receive alerts for sign-ins and account events',
            ),
          ),
        ],
      ),
    );
  }
}
