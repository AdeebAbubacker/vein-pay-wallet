import 'package:flutter/material.dart';
import 'package:vein_pay_wallet/views/profile/static_detail_screen.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  const _FaqTile(
                    question: 'How do I add money to my wallet?',
                    answer:
                        'Go to the home screen and tap the Add Money button to open the top-up flow.',
                  ),
                  const _FaqTile(
                    question: 'Is palm vein authentication active?',
                    answer:
                        'You can explore the palm vein setup screens, status cards, and local UI actions from the profile section.',
                  ),
                  const _FaqTile(
                    question: 'Where can I see transaction history?',
                    answer:
                        'Open the History tab from the bottom navigation bar to review your recent transactions.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SupportActionTile(
            icon: Icons.support_agent,
            title: 'Contact Support',
            subtitle: 'Get assistance from the Vein Pay support team',
            onTap: () => _openDetail(
              context,
              title: 'Contact Support',
              description:
                  'Reach the Vein Pay support team using the contact channels below.',
              sections: const [
                StaticDetailSection(
                  title: 'Support Channels',
                  icon: Icons.call_outlined,
                  items: [
                    'In-app chat support: Available from 9:00 AM to 8:00 PM.',
                    'Email support: support@veinpay.app',
                    'Priority help desk: For urgent payment or access issues.',
                  ],
                ),
                StaticDetailSection(
                  title: 'Before You Contact Us',
                  icon: Icons.info_outline,
                  items: [
                    'Keep your transaction ID ready if the issue is payment-related.',
                    'Mention your device model and app version for technical issues.',
                    'Describe the exact step where the problem occurred.',
                  ],
                ),
              ],
            ),
          ),

          _SupportActionTile(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            subtitle: 'Read the static legal and usage overview',
            onTap: () => _openDetail(
              context,
              title: 'Terms & Conditions',
              description:
                  'Review a summary of how Vein Pay should be used within the app experience.',
              sections: const [
                StaticDetailSection(
                  title: 'Usage Basics',
                  icon: Icons.gavel_outlined,
                  items: [
                    'Users are responsible for protecting their login credentials.',
                    'Wallet usage should comply with applicable financial rules and regulations.',
                    'Biometric features should only be configured on personal trusted devices.',
                  ],
                ),
                StaticDetailSection(
                  title: 'Account Conduct',
                  icon: Icons.verified_outlined,
                  items: [
                    'Do not attempt unauthorized access to other user accounts.',
                    'Report suspicious transactions immediately through support channels.',
                    'Keep your profile details accurate for a smoother account experience.',
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

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      collapsedIconColor: Theme.of(context).colorScheme.secondary,
      iconColor: Theme.of(context).colorScheme.secondary,
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(answer, style: TextStyle(color: Colors.grey[400])),
        ),
      ],
    );
  }
}

class _SupportActionTile extends StatelessWidget {
  const _SupportActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.2),
          child: Icon(icon, color: Theme.of(context).colorScheme.secondary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
