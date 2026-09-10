import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../utils/app_colors.dart';
import 'themes_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSwitch(
                title: 'Sound',
                icon: Icons.volume_up,
                value: settings.soundEnabled,
                onChanged: (v) => settings.toggleSound(v),
              ),
              _buildSwitch(
                title: 'Music',
                icon: Icons.music_note,
                value: settings.musicEnabled,
                onChanged: (v) => settings.toggleMusic(v),
              ),
              _buildSwitch(
                title: 'Vibration',
                icon: Icons.vibration,
                value: settings.vibrationEnabled,
                onChanged: (v) => settings.toggleVibration(v),
              ),
              const Divider(color: Colors.white24, height: 32),
              ListTile(
                leading: const Icon(Icons.gamepad, color: Colors.white),
                title: const Text('Controls', style: TextStyle(color: Colors.white)),
                trailing: DropdownButton<String>(
                  dropdownColor: AppColors.backgroundDark,
                  value: settings.controlType,
                  style: const TextStyle(color: AppColors.primaryGreen),
                  underline: const SizedBox(),
                  items: ['Swipe', 'Buttons'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) settings.setControlType(v);
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.palette, color: Colors.white),
                title: const Text('Theme', style: TextStyle(color: Colors.white)),
                trailing: Text(settings.selectedTheme, style: const TextStyle(color: Colors.white70)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ThemesScreen()));
                },
              ),
              const Divider(color: Colors.white24, height: 32),
              ListTile(
                leading: const Icon(Icons.restore, color: Colors.redAccent),
                title: const Text('Reset Game Data', style: TextStyle(color: Colors.redAccent)),
                onTap: () async {
                  bool? confirm = await showDialog(
                    context: context,
                    builder: (c) => AlertDialog(
                      backgroundColor: AppColors.backgroundDark,
                      title: const Text('Reset Data', style: TextStyle(color: Colors.white)),
                      content: const Text('Are you sure you want to delete all high scores, coins, and purchases?', style: TextStyle(color: Colors.white70)),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Reset', style: TextStyle(color: Colors.redAccent))),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await settings.resetAll();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Game data reset.')));
                    }
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSwitch({required String title, required IconData icon, required bool value, required Function(bool) onChanged}) {
    return SwitchListTile(
      activeColor: AppColors.primaryGreen,
      secondary: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
    );
  }
}
