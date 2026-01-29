import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/login/screen_login.dart';

// Data model for onboarding slides
class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class OnboardingController extends GetxController {
  late PageController pageController;
  int currentPage = 0;

  final List<OnboardingData> onboardingData = [
    OnboardingData(
      title: 'welcome_title'.tr,
      description: 'welcome_description'.tr,
      icon: Icons.shopping_cart_outlined,
      color: Colors.green,
    ),
    OnboardingData(
      title: 'easy_shopping_title'.tr,
      description: 'easy_shopping_description'.tr,
      icon: Icons.store_outlined,
      color: Colors.blue,
    ),
    OnboardingData(
      title: 'fast_delivery_title'.tr,
      description: 'fast_delivery_description'.tr,
      icon: Icons.local_shipping_outlined,
      color: Colors.orange,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void completeOnboarding() {
    // Mark onboarding as completed
    Hive.box(Constants.boxConfig).put('onboarding_completed', true);

    // Navigate to login screen
    Get.offAll(() => ScreenLogin());
  }
}
