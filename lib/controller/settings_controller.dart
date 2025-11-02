import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/settings/change_password.dart';

class SettingsController extends GetxController {
  // Profile data observables
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  GlobalKey<FormState> passwordkey = GlobalKey<FormState>();
  final showOldPassword = false.obs;
  final showNewPassword = false.obs;
  final showConfirmPassword = false.obs;
  ListeStatus statusChangePassword = ListeStatus.none;
  ListeStatus statusLoadProfile = ListeStatus.none;
  ListeStatus statusUpdateProfile = ListeStatus.none;

  var profileData = null;

  String? msgError;
  String profileImagePath = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  TextEditingController addresse = TextEditingController(text: "1212");

  // Loading states
  final isLoading = false.obs;
  final isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void toggleOldPasswordVisibility() => showOldPassword.toggle();
  void toggleNewPasswordVisibility() => showNewPassword.toggle();
  void toggleConfirmPasswordVisibility() => showConfirmPassword.toggle();

  changePassword() async {
    msgError = null;
    update();
    if (passwordkey.currentState!.validate()) {
      statusChangePassword = ListeStatus.loading;

      update();
      await Constants.reposit
          .repChangePassword(
            oldPasswordController.text,
            newPasswordController.text,
          )
          .then((value) {
            if (value['status'] == 'success') {
              statusChangePassword = ListeStatus.success;
              Get.back();
              Get.snackbar(
                'Success',
                'Mot de passe changé avec succès',
                backgroundColor: Colors.black,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
              oldPasswordController.clear();
              newPasswordController.clear();
              confirmPasswordController.clear();
            } else if (value['status'] == 'NOT_EXISTE') {
              msgError = "L'ancien mot de passe est incorrect";
              statusChangePassword = ListeStatus.error;
            } else {
              statusChangePassword = ListeStatus.error;
            }
          });
    }
    update();
  }

  // Load initial profile data
  void loadProfileData() async {
    statusLoadProfile = ListeStatus.loading;
    update();
    await Constants.reposit.repGetProfile().then((value) {
      if (value['status'] == 'SUCCESS') {
        statusLoadProfile = ListeStatus.success;

        profileData = value['user'];

        nameController.text = profileData['name'];
        adresseController.text = profileData['adresse'] ?? "adrrrr";
        phoneController.text = profileData['phone'] ?? "pppppppppphone";
        locationController.text =
            " ${profileData['latitude']}, ${profileData['longitude']}";
      } else {
        statusLoadProfile = ListeStatus.error;
      }
    });
    update();
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        profileImagePath = image.path;
        update();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  // Capture image from camera
  Future<void> captureImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        profileImagePath = image.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture image: $e');
    }
  }

  // Get current location using GPS
  void getCurrentLocation() async {
    try {
      isLoading.value = true;

      // Simulate GPS location fetch
      await Future.delayed(const Duration(seconds: 2));

      // In real app, use: https://pub.dev/packages/geolocator
      //   location.value = 'Current Location: 40.7128° N, 74.0060° W';

      Get.snackbar('Success', 'Location updated from GPS');
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Save profile changes
  Future<void> saveProfile() async {
    statusUpdateProfile = ListeStatus.loading;
    update();
    profileData['name'] = nameController.text;
    profileData['phone'] = phoneController.text;
    profileData['latidude'] = locationController.text.split(',')[0];
    profileData['longitude'] = locationController.text.split(',')[1];

    profileData['name'] = nameController.text;
    

    await Constants.reposit
        .repUpdateProfile(profileData, File(profileImagePath))
        .then((value) {
          if (value['status'] == 'success') {
            Constants.currentUser?.name = nameController.text;
            Get.back();
            Get.snackbar('Success', 'Profile updated successfully');
            update();
          }
        });

    // Simulate API call to save profile

    // Save logic here (API call, local storage, etc.)

    isUpdating.value = false;
    // Go back to previous screen
  }

  // Clear all fields
  void clearProfile() {
    nameController.text = '';

    profileImagePath = '';
    update();
  }
}
