import 'package:flutter/material.dart';

class ManagePalmVeinScreen extends StatefulWidget {
  const ManagePalmVeinScreen({super.key});

  @override
  State<ManagePalmVeinScreen> createState() => _ManagePalmVeinScreenState();
}

class _ManagePalmVeinScreenState extends State<ManagePalmVeinScreen> {
  bool _isRegistered = false;
  String _lastScan = 'No scan completed yet';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Palm Vein')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.orange.withValues(alpha: 0.18),
                        child: const Icon(
                          Icons.fingerprint,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Palm Vein Status',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isRegistered ? 'Registered' : 'Not Registered',
                            style: TextStyle(
                              color: _isRegistered
                                  ? Colors.greenAccent
                                  : Colors.orange[300],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Review your biometric status, recent scan state, and available enrollment actions.',
                    style: TextStyle(color: Colors.grey[400], height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _lastScan,
                          style: TextStyle(color: Colors.grey[300]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Palm Vein Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: _registerPalmVein,
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Register Palm Vein'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _rescanPalmVein,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Re-scan Palm Vein'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How it will work',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  _StepRow(
                    number: '1',
                    text: 'Place your hand above the palm vein scanner.',
                  ),
                  _StepRow(
                    number: '2',
                    text: 'The system will verify your registered pattern.',
                  ),
                  _StepRow(
                    number: '3',
                    text: 'Secure payment approval happens after verification.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _registerPalmVein() {
    setState(() {
      _isRegistered = true;
      _lastScan = 'Palm vein registered today at 11:45 AM';
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Palm vein registered successfully')),
      );
  }

  void _rescanPalmVein() {
    setState(() {
      _lastScan = _isRegistered
          ? 'Palm vein re-scanned today at 11:47 AM'
          : 'Please register your palm vein before re-scanning';
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _isRegistered
                ? 'Palm vein scan refreshed successfully'
                : 'Register your palm vein first',
          ),
        ),
      );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              number,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(text, style: TextStyle(color: Colors.grey[300])),
            ),
          ),
        ],
      ),
    );
  }
}
