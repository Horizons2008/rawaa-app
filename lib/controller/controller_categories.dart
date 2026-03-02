import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rawaa_app/controller/dash_client_controller.dart';
import 'package:rawaa_app/controller/dashboard_controller.dart';
import 'package:rawaa_app/model/model_categorie.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'dart:io';

import 'package:rawaa_app/views/admin/dashboard_admin.dart';

class ControllerCategories extends GetxController {
  // Observable list to hold categories
  List<MCat> listCat = <MCat>[];
  List<MCat> listFilted = <MCat>[];
  bool isSearching = false;

  // Observable for loading state
  ListeStatus status = ListeStatus.none;
  ListeStatus addStatus = ListeStatus.none;

  // Form controllers for adding new category
  final arabicController = TextEditingController();
  final frenchController = TextEditingController();
  final englishController = TextEditingController();
  final searchController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Image picker
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  filterCategories(String query) {
    listFilted = List.from(
      listCat
          .where((cat) => cat.title.toLowerCase().contains(query.toLowerCase()))
          .toList(),
    );

    update();
  }

  Future<void> fetchCategories() async {
    print("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrfetchCategories");
    try {
      status = ListeStatus.loading;
      update();
      final response = await Constants.reposit.repGetCategorie();

      if (response['status'] == 'success' && response['data'] != null) {
        status = ListeStatus.success;

        listCat = response['data'].map<MCat>((e) => MCat.fromJson(e)).toList();
        listFilted = List.from(listCat);

        update();
      } else {
        status = ListeStatus.error;
        update();
        Get.snackbar(
          'Error',
          'Failed to load categories: ${response['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load categories: ${e.toString()}');
    }
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage = File(image.path);
        update();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Add new category
  Future<void> addCategory(int? id) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    /* if (selectedImage == null) {
      Get.snackbar(
        'Error',
        'Please select an image for the category',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }*/

    try {
      addStatus = ListeStatus.loading;
      update();

      // Prepare category data

      // Call API to add category
      await Constants.reposit
          .repAddCategorie(
            id,
            '{"ar":"${arabicController.text.trim()}","fr":"${frenchController.text.trim()}","en":"${englishController.text.trim()}"}',

            selectedImage,
          )
          .then((value) {
            print("rrrrrrrrrrrespponse add categorie ${value}");
            if (value['status'] == 'success') {
              if (id == null) {
                CtrlDashboard ctrl = Get.find();
                ctrl.catCount++;
                ctrl.update();
              }

              addStatus = ListeStatus.success;

              // Clear form
              arabicController.clear();
              frenchController.clear();
              englishController.clear();
              selectedImage = null;
              Get.back();

              // Refresh categories list
              fetchCategories();

              Get.snackbar(
                'Success',
                'Category added successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );

              // Close bottom sheet
            } else {
              addStatus = ListeStatus.error;
              Get.snackbar(
                'Error',
                'Failed to add category: ${value['message'] ?? 'Unknown error'}',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.blue,
                colorText: Colors.white,
              );
            }
          });
    } catch (e) {
      addStatus = ListeStatus.error;
      Get.snackbar(
        'Error',
        'Failed to add category: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }

    update();
  }

  // Clear form
  void clearForm() {
    arabicController.clear();
    frenchController.clear();
    englishController.clear();
    selectedImage = null;
    update();
  }

  deleteCategory(int id) async {
    try {
      var response = await Constants.reposit.repDeleteCategorie(id);
      if (response['status'] == 'success') {
        CtrlDashboard ctrl = Get.find();
        ctrl.catCount--;
        ctrl.update();
        Get.snackbar(
          'Success',
          'Category deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Close bottom sheet
        fetchCategories();
        Get.back();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onClose() {
    arabicController.dispose();
    frenchController.dispose();
    englishController.dispose();
    super.onClose();
  }
}
