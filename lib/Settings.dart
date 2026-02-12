import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const SettingsPage({
    super.key, 
    required this.isDarkMode, 
    required this.onThemeChanged
  });

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'dvcarreon@student.apc.edu.ph',
      query: 'subject=Help & Support Query',
    );
    if (!await launchUrl(emailLaunchUri)) {
      debugPrint('Could not launch email');
    }
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor, 
        title: const Text("Privacy & Security"),
        content: const SingleChildScrollView(
          child: Text(
            "Your privacy is important to us. This application collects minimal data necessary for functionality.\n\n"
            "• Data Usage: Name, title, and bio are stored locally.\n"
            "• Security: Standard measures are in place.\n",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "Dominik Profile",
      applicationVersion: "1.0.0",
      applicationIcon: const Icon(Icons.person, color: Colors.orange),
      children: [
        const Text("This application serves as a personal portfolio showcasing mobile development projects and skills."),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color tileColor = isDark ? const Color(0xFF1E1E1E) : (Colors.grey[200] ?? Colors.grey);

    final Color titleColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: Colors.transparent, 
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(fontWeight: FontWeight.bold, color: titleColor)), 
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: titleColor),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text("Preferences", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _tile(
            Icons.dark_mode_outlined, 
            "Dark Mode", 
            isDarkMode ? "On" : "Off", 
            tileColor,
            titleColor,
            trailing: Switch(
              value: isDarkMode,
              activeColor: Colors.orange, 
              onChanged: onThemeChanged 
            )
          ),
          const SizedBox(height: 20),
          Text("Support", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _tile(Icons.security, "Privacy & Security", "Data usage and protection", tileColor, titleColor, onTap: () => _showPrivacyDialog(context)),
          _tile(Icons.help_outline, "Help & Support", "Contact us via email", tileColor, titleColor, onTap: _launchEmail),
          const SizedBox(height: 20),
          Text("General", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
           _tile(Icons.info_outline, "About App", "Version 1.0.0", tileColor, titleColor, onTap: () => _showAboutDialog(context)),
          _tile(Icons.share, "Share Profile", "Share your portfolio link", tileColor, titleColor),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title, String sub, Color color, Color titleColor, {Widget? trailing, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title, style: TextStyle(color: titleColor)), // Use dynamic color
        subtitle: sub.isNotEmpty ? Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null,
        trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
} 