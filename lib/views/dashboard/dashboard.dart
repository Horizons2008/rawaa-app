import 'package:rawaa_app/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rawaa_app/views/login/screen_login.dart';

class ScreenDashboard extends StatelessWidget {
  const ScreenDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor = theme.colorScheme.surface;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        backgroundColor: surfaceColor,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User greeting section

              // Module buttons
              const SizedBox(height: 32),
              // Logout button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  label: Text(
                    "Déconnexion",
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontFamily: 'Poppins',
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  icon: Icon(
                    Icons.logout,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modern module button with icon in colored circle, card, and semantic label
  Widget _buildModuleButton(
    BuildContext context, {
    required String title,
    required String subTitle,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String semanticLabel,
  }) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: cardColor,
        elevation: 4,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onPressed,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subTitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'Poppins',
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "Cliquer pour démarrer",
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontFamily: 'Poppins',
                              color: color,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios, color: color, size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Greeting based on time of day

  // Logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Déconnexion"),
        content: const Text("Voulez-vous vous déconnecter ?"),
        actions: [
          TextButton(
            child: const Text("Annuler"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Confirmer"),
            onPressed: () {
              Hive.box(Constants.boxConfig).put("logged", false);
              Hive.box(Constants.boxConfig).put("current_user", null);
              Navigator.of(context).pop();
              Get.offAll(ScreenLogin());
            },
          ),
        ],
      ),
    );
  }
}
