import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rawaa_app/model/model_commune.dart';
import 'package:rawaa_app/model/model_wilaya.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/location_picker_screen.dart';

class RegistrationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<MWilaya> listWilaya = <MWilaya>[];
  List<MCommune> listCommune = <MCommune>[];
  GlobalKey<FormState> registrationKey = GlobalKey<FormState>();
  ListeStatus statusStore = ListeStatus.none;
  ListeStatus statusWilaya = ListeStatus.none;
  ListeStatus statusCommune = ListeStatus.none;
  ListeStatus statusLocation = ListeStatus.none;
  ListeStatus statusUsername = ListeStatus.none;
  ListeStatus statusPhone = ListeStatus.none;

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
  var isPhoneVerified = false.obs;
  var isVerifyingPhone = false.obs;

  // Location coordinates
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    getWilaya();
    checkLocationPermission();
  }

  Future<bool> checkUsername(String username) async {
    bool result = false;
    await Constants.reposit.repCheckUsername(username).then((value) {
      if (value['status'] == 'success') {
        result = true;
      } else {
        result = false;
      }
    });
    return result;
  }

  // Async username validation for real-time checking
  Future<void> validateUsernameAsync(String username) async {
    if (username.isEmpty || username.length < 3) return;

    statusUsername = ListeStatus.loading;
    update();

    try {
      bool isAvailable = await checkUsername(username);
      if (isAvailable) {
        statusUsername = ListeStatus.success;
      } else {
        statusUsername = ListeStatus.error;
      }
    } catch (e) {
      statusUsername = ListeStatus.error;
      print('Error validating username: $e');
    }

    update();
  }

  checkPhone(String phone) async {
    var result = await Constants.reposit.repCheckPhone(phone);

    return result;
  }

  // Async phone validation for real-time checking
  Future<void> validatePhoneAsync(String phone) async {
    if (phone.isEmpty || phone.length < 10) return;

    statusPhone = ListeStatus.loading;
    update();

    try {
      var result = await checkPhone(phone);

      if (result != null && result['status'] == 'success') {
        statusPhone = ListeStatus.success;
      } else {
        statusPhone = ListeStatus.error;
      }
    } catch (e) {
      statusPhone = ListeStatus.error;
      print('Error validating phone: $e');
    }

    update();
  }

  getWilaya() async {
    statusWilaya = ListeStatus.loading;
    update();
    try {
      await Constants.reposit.repGetWilaya().then((value) {
        print(value);
        if (value['status'] != null &&
            value['status'] == 'success' &&
            value['data'] != null &&
            value['data'] is List) {
          statusWilaya = ListeStatus.success;

          listWilaya = value['data']
              .map<MWilaya>((e) => MWilaya.fromJson(e))
              .toList();
          print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${listWilaya.length}");
          update();
        }
      });
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee $e");
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
        Constants.showSnackBar('erreur'.tr, 'choisir_type_compte'.tr);

        return;
      } else if (selectedWilaya == null) {
        Constants.showSnackBar('erreur'.tr, 'choisir_wilaya'.tr);

        return;
      } else if (selectedCommune == null) {
        Constants.showSnackBar('erreur'.tr, 'choisir_commune'.tr);

        return;
      } else if (statusUsername != ListeStatus.success) {
        Get.snackbar(
          "Erreur",
          "Veuillez vérifier que le nom d'utilisateur est disponible",
        );
        return;
      } else if (statusPhone != ListeStatus.success) {
        Get.snackbar(
          "Erreur",
          "Veuillez vérifier que le numéro de téléphone est disponible",
        );
        return;
      } else {
        try {
          String tt = "";
          switch (typeCompte) {
            case 0:
              tt = "client";
              break;
            case 1:
              tt = "vendeur";
              break;
            case 2:
              tt = "driver";
              break;
            default:
          }

          statusStore = ListeStatus.loading;
          update();
          await Constants.reposit
              .repRegister({
                "name": 'name',
                "phone": phoneController.text,
                "username": usernameController.text,
                "password": passwordController.text,
                "wilaya_id": selectedWilaya!.id,
                "commune_id": selectedCommune!.id,
                "latitude": latitude.value,
                "longitude": longitude.value,

                "role": tt,
                "address": 'Algerie',
                "confirmed_phone": 0,
                "confirmed_compte": 0,
              })
              .then((value) {
                print("vvvvvvvvvvvvvvvvvvvvv $value");
                if (value['status'] != null && value['status'] == "success") {
                  statusStore = ListeStatus.success;
                  Get.back();
                  Get.snackbar(
                    "Success",
                    "Votre compte a été créé avec succès",
                    colorText: Colors.white,
                    backgroundColor: Colors.black,
                    borderRadius: 25,
                    snackPosition: SnackPosition.BOTTOM,
                  );
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

  // Open location picker with Google Maps
  Future<void> openLocationPicker() async {
    try {
      final result = await Get.to(
        () => LocationPickerScreen(
          initialLatitude: latitude.value != 0.0 ? latitude.value : null,
          initialLongitude: longitude.value != 0.0 ? longitude.value : null,
        ),
      );

      if (result != null) {
        latitude.value = result['latitude'];
        longitude.value = result['longitude'];
        currentLocation.value = result['address'];

        Get.snackbar(
          'Location Updated',
          'Localisation mise à jour avec succès',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('Error opening location picker: $e');
      Get.snackbar(
        'Error',
        'Impossible d\'ouvrir le sélecteur de localisation',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

  // Format phone number with country code
  String formatPhoneNumber(String phone) {
    // Remove all non-digit characters
    String cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    // If it starts with 0, remove it
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }
    
    // Add country code +213 for Algeria
    return '+213$cleaned';
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

    if (phoneController.text.length != 10) {
      Get.snackbar(
        'Error',
        'Phone number must be 10 digits',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isVerifyingPhone.value = true;
      String formattedPhone = formatPhoneNumber(phoneController.text);

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("tttttttttttttttt verification completed");
          // Auto-verification completed
          await _auth.signInWithCredential(credential);
          isOtpSent.value = true;
          isPhoneVerified.value = true;
          isVerifyingPhone.value = false;
          Get.snackbar(
            'Success',
            'Phone number verified successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          isVerifyingPhone.value = false;
          isPhoneVerified.value = false;
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
          print("=========================================");
          print("OTP CODE SENT:");
          print("Verification ID: $verificationId");
          print("Phone Number: ${phoneController.text}");
          print("Formatted Phone: ${formatPhoneNumber(phoneController.text)}");
          print("Resend Token: $resendToken");
          print("=========================================");
          this.verificationId.value = verificationId;
          isOtpSent.value = true;
          isVerifyingPhone.value = false;
          Get.snackbar(
            'OTP Sent',
            'Verification code sent to ${phoneController.text}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Show OTP dialog
          _showOtpDialog();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      isVerifyingPhone.value = false;
      isPhoneVerified.value = false;
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

  // Show OTP verification dialog
  void _showOtpDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Verify Phone Number'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter the OTP sent to ${phoneController.text}'),
            SizedBox(height: 16),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'OTP Code',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              otpController.clear();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              verifyOtp();
            },
            child: Text('Verify'),
          ),
        ],
      ),
    );
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

    // Validate verification ID exists
    if (verificationId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Verification session expired. Please request a new OTP.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Trim whitespace and get the OTP code
      String enteredOtp = otpController.text.trim();
      String formattedPhone = formatPhoneNumber(phoneController.text);
      
      // Log for debugging
      print("=========================================");
      print("OTP VERIFICATION DEBUG:");
      print("Entered OTP Code: '$enteredOtp'");
      print("OTP Code Length: ${enteredOtp.length}");
      print("Verification ID: ${verificationId.value}");
      print("Phone Number: ${phoneController.text}");
      print("Formatted Phone: $formattedPhone");
      print("=========================================");

      // Sign out any existing user to prevent false positives
      User? existingUser = _auth.currentUser;
      if (existingUser != null) {
        print("Signing out existing user before verification...");
        await _auth.signOut();
        await Future.delayed(Duration(milliseconds: 200));
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: enteredOtp,
      );

      print("Attempting to verify with credential...");
      
      User? verifiedUser;
      
      try {
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        verifiedUser = userCredential.user;
        print("✓ OTP Verification SUCCESS!");
      } catch (signInError) {
        // Check if this is the known type casting error
        String errorStr = signInError.toString();
        if (errorStr.contains('PigeonUserDetails') || 
            errorStr.contains('type \'List<Object?>\' is not a subtype')) {
          print("Known Firebase plugin bug detected, checking user state...");
          
          // Wait for Firebase to process
          await Future.delayed(Duration(milliseconds: 500));
          
          // Get current user after error
          verifiedUser = _auth.currentUser;
          if (verifiedUser == null) {
            print("✗ No user signed in after plugin bug");
            throw FirebaseAuthException(
              code: 'invalid-verification-code',
              message: 'Verification failed',
            );
          }
          print("✓ User found after plugin bug - will verify phone number");
        } else {
          // Real error - rethrow
          rethrow;
        }
      }
      
      // Verify user is signed in
      if (verifiedUser == null) {
        throw Exception("User not signed in after verification");
      }
      
      // CRITICAL: Verify phone number matches
      String? verifiedPhone = verifiedUser.phoneNumber;
      if (verifiedPhone == null) {
        await _auth.signOut();
        throw Exception("Phone number not found in verified user");
      }
      
      // Normalize phone numbers for comparison
      String normalizedVerified = verifiedPhone.replaceAll(' ', '').replaceAll('-', '');
      String normalizedExpected = formattedPhone.replaceAll(' ', '').replaceAll('-', '');
      
      if (normalizedVerified != normalizedExpected) {
        print("✗ PHONE NUMBER MISMATCH:");
        print("  Verified: $normalizedVerified");
        print("  Expected: $normalizedExpected");
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'invalid-verification-code',
          message: 'Phone number does not match',
        );
      }
      
      print("✓ Final verification - User signed in:");
      print("  User ID: ${verifiedUser.uid}");
      print("  Phone: ${verifiedPhone}");
      print("  Phone matches: ✓");

      // Phone verified successfully
      isPhoneVerified.value = true;
      isLoading.value = false;
      Get.back(); // Close OTP dialog
      
      Get.snackbar(
        'Success',
        'Phone number verified successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      isLoading.value = false;
      isPhoneVerified.value = false;
      
      // Sign out on error to prevent false positives
      try {
        User? errorUser = _auth.currentUser;
        if (errorUser != null) {
          await _auth.signOut();
        }
      } catch (signOutError) {
        print("Error signing out: $signOutError");
      }
      
      // Detailed error logging
      print("=========================================");
      print("OTP VERIFICATION ERROR:");
      print("Entered OTP: '${otpController.text.trim()}'");
      print("Error Type: ${e.runtimeType}");
      print("Error Message: ${e.toString()}");
      if (e is FirebaseAuthException) {
        print("Firebase Error Code: ${e.code}");
        print("Firebase Error Message: ${e.message}");
      }
      print("=========================================");
      
      String errorMessage = 'Invalid OTP. Please try again.';
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-verification-code') {
          errorMessage = 'Invalid verification code. Please check the code and try again.';
        } else if (e.code == 'session-expired') {
          errorMessage = 'Verification session expired. Please request a new code.';
        } else {
          errorMessage = 'Error: ${e.message ?? e.code}';
        }
      }
      
      Get.snackbar(
        'Verification Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
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
