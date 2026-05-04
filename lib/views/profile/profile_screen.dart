import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vein_pay_wallet/data/repositories/auth_repository.dart';
import 'package:vein_pay_wallet/viewmodels/wallet_viewmodel.dart';
import 'package:vein_pay_wallet/views/profile/about_vein_pay_screen.dart';
import 'package:vein_pay_wallet/views/profile/edit_profile_screen.dart';
import 'package:vein_pay_wallet/views/profile/help_support_screen.dart';
import 'package:vein_pay_wallet/views/profile/manage_palm_vein_screen.dart';
import 'package:vein_pay_wallet/views/profile/notifications_screen.dart';
import 'package:vein_pay_wallet/views/profile/security_privacy_screen.dart';
import 'package:vein_pay_wallet/views/profile/widgets/profile_menu_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = context.select((WalletViewModel vm) => vm.state.wallet);
    final username = wallet?.ownerUsername ?? 'Vein Pay User';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ProfileHeader(username: username),
          const SizedBox(height: 20),
          Text(
            'Account',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ProfileMenuTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Update your personal details and contact info',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),
          ProfileMenuTile(
            icon: Icons.lock_outline,
            title: 'Security & Privacy',
            subtitle: 'Review password, privacy, and login activity',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SecurityPrivacyScreen(),
                ),
              );
            },
          ),
          ProfileMenuTile(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            subtitle: 'Choose which alerts you want to receive',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Biometrics & Support',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ProfileMenuTile(
            icon: Icons.fingerprint,
            title: 'Manage Palm Vein',
            subtitle: 'See biometric status and enrollment actions',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManagePalmVeinScreen()),
              );
            },
          ),
          ProfileMenuTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            subtitle: 'FAQs, support options, and report tools',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
              );
            },
          ),
          ProfileMenuTile(
            icon: Icons.info_outline_rounded,
            title: 'About Vein Pay',
            subtitle: 'App version, policies, and product details',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutVeinPayScreen()),
              );
            },
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red[300]),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red[300],
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text('Sign out of your Vein Pay account'),
              trailing: Icon(Icons.chevron_right, color: Colors.red[300]),
              onTap: () async {
                await context.read<AuthRepository>().logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF21132F), Color(0xFF102A2A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
            ),
            child: const Icon(Icons.person, size: 36, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Manage your account, security, and app preferences',
                  style: TextStyle(color: Colors.grey[400], height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
