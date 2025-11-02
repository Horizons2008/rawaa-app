import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/translations/messages.dart';

class LanguageController extends GetxController {
  // Current locale
  var currentLocale = Locale('fr', '').obs;

  // Available languages
  final List<Map<String, String>> languages = [
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇩🇿'},
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize with saved language or default to French
    _loadSavedLanguage();
  }

  // Load saved language from storage
  void _loadSavedLanguage() async {
    // You can implement SharedPreferences or other storage here
    // For now, defaulting to
    String lang = await Hive.box(Constants.boxConfig).get('language') ?? 'fr';
    print("Loaded language from storage: $lang");

    changeLanguage(lang);
  }

  // Change language
  void changeLanguage(String languageCode) {
    print("Changing language to $languageCode");
    currentLocale.value = Locale(languageCode, '');
    Constants.lang = languageCode;
    Get.updateLocale(currentLocale.value);

    // Save language preference
    _saveLanguagePreference(languageCode);

    // Show success message
    /*   Get.snackbar(
      'success'.tr,
      'Language changed to ${languages.firstWhere((lang) => lang['code'] == languageCode)['name']}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );*/
  }

  // Save language preference
  void _saveLanguagePreference(String languageCode) {
    Hive.box(Constants.boxConfig).put('language', languageCode);
    // Implement SharedPreferences or other storage here
    // For example:
    // SharedPreferences.getInstance().then((prefs) {
    //   prefs.setString('language', languageCode);
    // });
  }

  // Get current language name
  String get currentLanguageName {
    return languages.firstWhere(
          (lang) => lang['code'] == currentLocale.value.languageCode,
        )['name'] ??
        'Français';
  }

  // Get current language flag
  String get currentLanguageFlag {
    return languages.firstWhere(
          (lang) => lang['code'] == currentLocale.value.languageCode,
        )['flag'] ??
        '🇫🇷';
  }

  // Show language selection dialog
  void showLanguageDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('settings'.tr),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((language) {
            return ListTile(
              leading: Text(language['flag']!, style: TextStyle(fontSize: 24)),
              title: Text(language['name']!),
              trailing: currentLocale.value.languageCode == language['code']
                  ? Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                Get.back();
                changeLanguage(language['code']!);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
        ],
      ),
    );
  }
}
