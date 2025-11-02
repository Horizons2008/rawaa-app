import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  // Text controllers
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Password visibility observables
  final showOldPassword = false.obs;
  final showNewPassword = false.obs;
  final showConfirmPassword = false.obs;

  // Loading state
  final isLoading = false.obs;

  // Toggle password visibility
  void toggleOldPasswordVisibility() => showOldPassword.toggle();
  void toggleNewPasswordVisibility() => showNewPassword.toggle();
  void toggleConfirmPasswordVisibility() => showConfirmPassword.toggle();

  // Change password method
  void changePassword() {
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'New passwords do not match');
      return;
    }

    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar('Success', 'Password changed successfully');

      // Clear fields
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    });
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
