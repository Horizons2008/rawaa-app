import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rawaa_app/model/model_commune.dart';
import 'package:rawaa_app/model/model_wilaya.dart';

import 'package:rawaa_app/styles/constants.dart';

class RegistrationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<MWilaya> listWilaya = <MWilaya>[];
  List<MCommune> listCommune = <MCommune>[];
  GlobalKey<FormState> registrationKey = GlobalKey<FormState>();
  ListeStatus statusStore = ListeStatus.none;
  ListeStatus statusWilaya = ListeStatus.none;
  ListeStatus statusCommune = ListeStatus.none;
  ListeStatus statusLocation = ListeStatus.none;

  // Form controllers
  final nameController = TextEditingController(text: "");
  final phoneController = TextEditingController(text: "");
  final usernameController = TextEditingController(text: "");
  final passwordController = TextEditingController(text: "");
  final adresseController = TextEditingController(text: "");
  int typeCompte = -1;
  MWilaya? selectedWilaya;
  MCommune? selectedCommune;

  final otpController = TextEditingController();

  // Observable variables
  var isLoading = false.obs;
  var isOtpSent = false.obs;
  var verificationId = ''.obs;
  var currentLocation = ''.obs;
  var locationPermissionGranted = false.obs;

  // Location coordinates
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    getWilaya();
    checkLocationPermission();
  }

  getWilaya() async {
    statusWilaya = ListeStatus.loading;
    update();
    try {
      await Constants.reposit.repGetWilaya().then((value) {
        if (value['status'] != null &&
            value['status'] == 'success' &&
            value['data'] != null &&
            value['data'] is List) {
          statusWilaya = ListeStatus.success;

          listWilaya = value['data']
              .map<MWilaya>((e) => MWilaya.fromJson(e))
              .toList();
          update();
        }
      });
    } catch (e) {
      statusWilaya = ListeStatus.error;
      update();
    }
  }

  getCommune() async {
    statusCommune = ListeStatus.loading;
    update();
    try {
      await Constants.reposit.repGetCommune(selectedWilaya!.id).then((value) {
        print(value);
        if (value['status'] != null &&
            value['status'] == 'success' &&
            value['data'] != null &&
            value['data'] is List) {
          listCommune = value['data']
              .map<MCommune>((e) => MCommune.fromJson(e))
              .toList();
          update();
        }
      });
    } catch (e) {
      statusCommune = ListeStatus.error;
      update();
    }
  }

  store() async {
    if (registrationKey.currentState!.validate()) {
      if (typeCompte == -1) {
        Get.snackbar("Erreur", "Veuillez choisir le type de compte");
        return;
      } else if (selectedWilaya == null) {
        Get.snackbar("Erreur", "Veuillez choisir la wilaya");
        return;
      } else if (selectedCommune == null) {
        Get.snackbar("Erreur", "Veuillez choisir la commune");
        return;
      } else {
        try {
          String tt = "";
          switch (typeCompte) {
            case 0:
              tt = "client";
              break;
            case 1:
              tt = "fournisseur";
              break;
            case 2:
              tt = "transporter";
              break;
            default:
          }

          print("*********** $tt");
          print("*********** $typeCompte");
          statusStore = ListeStatus.loading;
          update();
          await Constants.reposit
              .repRegister({
                "name": nameController.text,
                "phone": phoneController.text,
                "username": usernameController.text,
                "password": passwordController.text,
                "wilaya_id": selectedWilaya!.id,
                "commune_id": selectedCommune!.id,
                "latitude": latitude.value,
                "longitude": longitude.value,

                "role": tt,
                "address": adresseController.text,
                "confirmed_phone": 0,
                "confirmed_compte": 0,
              })
              .then((value) {
                print("*********** $value");
                if (value['status'] != null && value['status'] == "success") {
                  statusStore = ListeStatus.success;
                  update();
                } else {
                  statusStore = ListeStatus.error;
                  update();
                }
              });
        } catch (e) {
          statusStore = ListeStatus.error;
          update();
        }
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }

  // Check and request location permission
  Future<void> checkLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationPermissionGranted.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        locationPermissionGranted.value = false;
        Get.snackbar(
          'Permission Required',
          'Location permissions are permanently denied. Please enable them in settings.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      locationPermissionGranted.value = true;
      await getCurrentLocation();
    } catch (e) {
      print('Error checking location permission: $e');
      locationPermissionGranted.value = false;
    }
  }

  // Get current location
  Future<void> getCurrentLocation() async {
    if (!locationPermissionGranted.value) {
      await checkLocationPermission();
      return;
    }

    try {
      isLoading.value = true;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // Set location coordinates
      currentLocation.value =
          '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
    } catch (e) {
      print('Error getting location: $e');
      Get.snackbar(
        'Location Error',
        'Failed to get current location: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Send OTP to phone number
  Future<void> sendOtp() async {
    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("tttttttttttttttt verification completed");
          // Auto-verification completed
          await _auth.signInWithCredential(credential);
          isOtpSent.value = true;
          isLoading.value = false;
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          print("senttttttttttttttttt verification field ${e.message}");
          Get.snackbar(
            'Verification Failed',
            e.message ?? 'Failed to send OTP',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          print("tttttttttttttttt  code sent");
          this.verificationId.value = verificationId;
          isOtpSent.value = true;
          isLoading.value = false;
          Get.snackbar(
            'OTP Sent',
            'Verification code sent to ${phoneController.text}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      isLoading.value = false;
      print("senttttttttttttttttt field to send otp $e");
      Get.snackbar(
        'Error',
        'Failed to send OTP: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Verify OTP
  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter the OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otpController.text,
      );

      await _auth.signInWithCredential(credential);

      // Registration successful
      Get.snackbar(
        'Success',
        'Phone number verified successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to next screen or complete registration
      // Get.offNamed('/dashboard'); // Uncomment when ready to navigate
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Verification Failed',
        'Invalid OTP. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Complete registration
  Future<void> completeRegistration() async {
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!isOtpSent.value) {
      Get.snackbar(
        'Error',
        'Please verify your phone number first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Update user profile
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(nameController.text);
      }

      Get.snackbar(
        'Registration Complete',
        'Welcome ${nameController.text}!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to dashboard
      // Get.offNamed('/dashboard'); // Uncomment when ready to navigate
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to complete registration: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Resend OTP
  Future<void> resendOtp() async {
    await sendOtp();
  }
}
