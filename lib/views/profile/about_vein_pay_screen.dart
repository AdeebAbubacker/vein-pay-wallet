import 'package:flutter/material.dart';
import 'package:vein_pay_wallet/views/profile/static_detail_screen.dart';

class AboutVeinPayScreen extends StatelessWidget {
  const AboutVeinPayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Vein Pay')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.22),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 34,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Vein Pay',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Vein Pay is a dark-fintech wallet experience designed around secure digital payments and biometric-first identity flows.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[300], height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _AboutActionTile(
            title: 'Privacy Policy',
            subtitle: 'Read the static privacy overview',
            onTap: () => _openDetail(
              context,
              title: 'Privacy Policy',
              description:
                  'Learn how Vein Pay approaches account information, payment records, and in-app preferences.',
              sections: const [
                StaticDetailSection(
                  title: 'Information We Use',
                  icon: Icons.folder_shared_outlined,
                  items: [
                    'Basic profile details such as your name, username, and contact information.',
                    'Wallet activity and transaction history used for the account experience.',
                    'Device session data to help maintain account security.',
                  ],
                ),
                StaticDetailSection(
                  title: 'How It Helps',
                  icon: Icons.security_outlined,
                  items: [
                    'Supports secure sign-in and fraud monitoring.',
                    'Improves transaction visibility and wallet summaries.',
                    'Helps tailor important alerts and product updates.',
                  ],
                ),
              ],
            ),
          ),
          _AboutActionTile(
            title: 'Terms of Service',
            subtitle: 'Review the static app usage terms',
            onTap: () => _openDetail(
              context,
              title: 'Terms of Service',
              description:
                  'Read the product overview, usage expectations, and account responsibilities for Vein Pay.',
              sections: const [
                StaticDetailSection(
                  title: 'Account Responsibilities',
                  icon: Icons.assignment_ind_outlined,
                  items: [
                    'Keep your login details secure and up to date.',
                    'Use the app only for lawful transactions and authorized access.',
                    'Review your balance and transaction history regularly.',
                  ],
                ),
                StaticDetailSection(
                  title: 'Service Notes',
                  icon: Icons.receipt_long_outlined,
                  items: [
                    'Some product features may vary by device capability and region.',
                    'Security checks may be required before sensitive actions are approved.',
                    'App updates can refresh interface flows and account settings.',
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(
    BuildContext context, {
    required String title,
    required String description,
    required List<StaticDetailSection> sections,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StaticDetailScreen(
          title: title,
          description: description,
          sections: sections,
        ),
      ),
    );
  }
}

class _AboutActionTile extends StatelessWidget {
  const _AboutActionTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
