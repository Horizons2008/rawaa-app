import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rawaa_app/controller/language_controller.dart';
import 'package:rawaa_app/controller/settings_controller.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/login/screen_login.dart';
import 'package:rawaa_app/views/settings/change_password.dart';
import 'package:rawaa_app/views/settings/screen_profile.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: GetBuilder<SettingsController>(
        init: SettingsController(),
        builder: (ctrl) {
          return ListView(
            children: [
              // User Profile Section
              _buildUserProfileSection(),

              // Account Section
              _buildSectionHeader('mon_compte'.tr),
              _buildSettingsItem(
                icon: Icons.person_outline,
                title: 'profile'.tr,
                onTap: () {
                  ctrl.loadProfileData();
                  Get.to(() => EditProfileScreen());
                  // Navigate to edit profile screen
                },
              ),
              _buildSettingsItem(
                icon: Icons.lock_outline,
                title: 'changer_password'.tr,

                onTap: () {
                  showModalBottomSheet(
                    context: context,
                     isScrollControlled: true, 
                    builder: (context) {
                      return ChangePassword();
                    },
                  );
                  // Navigate to change password screen
                },
              ),

              // Application Section
              //_buildSectionHeader('Application'),
              _buildSettingsItem(
                icon: Icons.language,
                title: 'changer_langue'.tr,

                onTap: () {
                  languageController.showLanguageDialog();
                  // Navigate to language selection screen
                },
              ),

              // Log Out Section
              const SizedBox(height: 20),
              _buildLogOutButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue[100],
            ),

            child: ClipOval(
              child: Image.network(
                "${Constants.photoUrl}/users/${Constants.currentUser!.id}.jpg",

                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 40, color: Colors.blue);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Constants.currentUser!.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Constants.currentUser!.role,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700], size: 22),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[500],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildLogOutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          Constants.currentUser = null;
          Hive.box(Constants.boxConfig).put("current_user", null);
          Hive.box(Constants.boxConfig).put("logged", false);
          Get.offAll(() => ScreenLogin());

          // Handle log out
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          'logout'.tr,

          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
