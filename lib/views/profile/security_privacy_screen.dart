import 'package:flutter/material.dart';
import 'package:vein_pay_wallet/views/profile/static_detail_screen.dart';

class SecurityPrivacyScreen extends StatelessWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security & Privacy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SecurityHeroCard(),
          const SizedBox(height: 16),
          _SecurityActionCard(
            icon: Icons.password_rounded,
            title: 'Change Password',
            subtitle: 'Review password strength and update credentials',
            onTap: () => _openDetail(
              context,
              title: 'Change Password',
              description:
                  'Review the password flow and security guidance for your Vein Pay account.',
              sections: const [
                StaticDetailSection(
                  title: 'Password Rules',
                  icon: Icons.rule_folder_outlined,
                  items: [
                    'Use at least 8 characters with a mix of letters, numbers, and symbols.',
                    'Avoid reusing the same password across banking, wallet, or shopping apps.',
                    'Update your password right away if you notice suspicious account activity.',
                  ],
                ),
                StaticDetailSection(
                  title: 'Change Flow',
                  icon: Icons.password,
                  items: [
                    'Enter your current password to verify ownership of the account.',
                    'Create a new password and confirm it before saving the change.',
                    'You would be signed out on other devices after a successful update.',
                  ],
                ),
              ],
            ),
          ),
          _SecurityActionCard(
            icon: Icons.verified_user_outlined,
            title: 'Two-Factor Authentication',
            subtitle: 'Add another layer of account protection',
            onTap: () => _openDetail(
              context,
              title: 'Two-Factor Authentication',
              description:
                  'Choose how you want to protect important sign-ins and approval actions.',
              sections: const [
                StaticDetailSection(
                  title: 'Available Methods',
                  icon: Icons.shield_moon_outlined,
                  items: [
                    'Authenticator app codes for secure sign-ins.',
                    'SMS verification for quick secondary approval.',
                    'Biometric confirmation on supported devices.',
                  ],
                ),
                StaticDetailSection(
                  title: 'Recommended Setup',
                  icon: Icons.check_circle_outline,
                  items: [
                    'Enable an authenticator app as your primary method.',
                    'Keep SMS as a backup in case your device is unavailable.',
                    'Review recovery options every few months.',
                  ],
                ),
              ],
            ),
          ),
          _SecurityActionCard(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Settings',
            subtitle: 'Control how your account information is handled',
            onTap: () => _openDetail(
              context,
              title: 'Privacy Settings',
              description:
                  'Review the types of data visibility and account privacy controls available in Vein Pay.',
              sections: const [
                StaticDetailSection(
                  title: 'Visibility Controls',
                  icon: Icons.visibility_outlined,
                  items: [
                    'Choose whether your display name appears on receipts and transfers.',
                    'Manage the level of profile information visible within the app.',
                    'Decide if marketing preferences are enabled for feature announcements.',
                  ],
                ),
                StaticDetailSection(
                  title: 'Data Preferences',
                  icon: Icons.dataset_outlined,
                  items: [
                    'Review device session records and sign out from inactive devices.',
                    'Understand how payment history is used to improve wallet insights.',
                    'Control in-app communication preferences for tips and reminders.',
                  ],
                ),
              ],
            ),
          ),
          _SecurityActionCard(
            icon: Icons.history_toggle_off_rounded,
            title: 'Login Activity',
            subtitle: 'Check recent access events and session history',
            onTap: () => _openDetail(
              context,
              title: 'Login Activity',
              description:
                  'Keep an eye on recent account access and session behavior.',
              sections: const [
                StaticDetailSection(
                  title: 'Recent Activity',
                  icon: Icons.devices_outlined,
                  items: [
                    'Android device sign-in from Kochi, India at 10:32 AM.',
                    'Session refresh completed automatically from your current mobile device.',
                    'No unusual access attempts detected in the last 7 days.',
                  ],
                ),
                StaticDetailSection(
                  title: 'What To Do',
                  icon: Icons.tips_and_updates_outlined,
                  items: [
                    'Change your password if you see a device you do not recognize.',
                    'Enable two-factor authentication for added protection.',
                    'Log out of all sessions after changing account credentials.',
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

class _SecurityHeroCard extends StatelessWidget {
  const _SecurityHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF251A2C), Color(0xFF163041)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, size: 36, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            'Security Center',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Open security tools, review account protections, and explore privacy guidance.',
            style: TextStyle(color: Colors.grey[300], height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _SecurityActionCard extends StatelessWidget {
  const _SecurityActionCard({
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
          radius: 24,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.22),
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
