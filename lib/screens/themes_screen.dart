import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../utils/app_colors.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});

  final List<String> themes = const ['Classic', 'Forest', 'Night'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Themes'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: themes.length,
            itemBuilder: (context, index) {
              final themeName = themes[index];
              final isActive = settings.selectedTheme == themeName;

              return GestureDetector(
                onTap: () => settings.setTheme(themeName),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(16),
                    border: isActive ? Border.all(color: AppColors.primaryGreen, width: 2) : null,
                  ),
                  child: Stack(
                    children: [
                      // Placeholder for theme preview background
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            color: themeName == 'Forest' ? Colors.green.withOpacity(0.1) : 
                                   themeName == 'Night' ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          themeName,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      if (isActive)
                        const Positioned(
                          right: 16,
                          top: 16,
                          child: Chip(
                            label: Text('Active'),
                            backgroundColor: AppColors.primaryGreen,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
