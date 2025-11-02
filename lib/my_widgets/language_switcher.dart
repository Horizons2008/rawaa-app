import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/language_controller.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    
    return Obx(() => DropdownButton<String>(
      value: languageController.currentLocale.value.languageCode,
      icon: Icon(Icons.language, color: Colors.white),
      underline: Container(),
      items: languageController.languages.map((language) {
        return DropdownMenuItem<String>(
          value: language['code'],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                language['flag']!,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(width: 8),
              Text(
                language['name']!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          languageController.changeLanguage(newValue);
        }
      },
    ));
  }
}

class LanguageSwitcherButton extends StatelessWidget {
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    
    return Obx(() => IconButton(
      onPressed: () => languageController.showLanguageDialog(),
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            languageController.currentLanguageFlag,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
      tooltip: 'Change Language',
    ));
  }
}

class LanguageSwitcherTile extends StatelessWidget {
  const LanguageSwitcherTile({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    
    return Obx(() => ListTile(
      leading: Text(
        languageController.currentLanguageFlag,
        style: TextStyle(fontSize: 24),
      ),
      title: Text('Language'),
      subtitle: Text(languageController.currentLanguageName),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () => languageController.showLanguageDialog(),
    ));
  }
}
