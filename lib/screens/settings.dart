import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/api_service.dart';
import 'sign_in.dart';
import 'edit_profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _name = 'Loading...';
  String? _avatar;
  bool _notifEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await ApiService.getUserName();
    final avatar = await ApiService.getUserAvatar();
    setState(() {
      _name = name ?? 'User';
      _avatar = avatar;
    });
  }

  void _handleSignOut() async {
    await ApiService.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Banner User
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: (_avatar != null && _avatar!.isNotEmpty)
                      ? NetworkImage(_avatar!)
                      : const NetworkImage(
                          'https://picsum.photos/seed/profile/150',
                        ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Text(
                        'Traveler',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                    _loadUserData(); // Refresh data after returning
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'EDIT PROFILE',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          _buildMenuItem(
            Icons.notifications_none,
            'Notifications',
            trailing: Switch(
              value: _notifEnabled,
              activeThumbColor: primaryColor,
              onChanged: (v) => setState(() => _notifEnabled = v),
            ),
          ),
          _buildMenuItem(Icons.language, 'Languages'),
          _buildMenuItem(Icons.payment, 'Payment'),
          _buildMenuItem(Icons.privacy_tip_outlined, 'Privacy & Policies'),
          _buildMenuItem(Icons.feedback_outlined, 'Feedback'),
          _buildMenuItem(Icons.data_usage, 'Usage'),
          const Spacer(),
          TextButton(
            onPressed: _handleSignOut,
            child: const Text('Sign out', style: TextStyle(color: hintColor)),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: hintColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing:
          trailing ??
          const Icon(Icons.arrow_forward_ios, size: 14, color: hintColor),
    );
  }
}
