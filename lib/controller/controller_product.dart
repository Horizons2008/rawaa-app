import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rawaa_app/controller/dashboard_controller.dart';
import 'package:rawaa_app/model/model_categorie.dart';
import 'package:rawaa_app/model/model_product.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'dart:io';

class ControllerProducts extends GetxController {
  // Observable list to hold categories
  List<MCat> listCat = <MCat>[];
  List<MProduct> listProduct = <MProduct>[];
  List<MProduct> listFiltred = <MProduct>[];

  MCat? selectedCat;
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

  File? selectedImage;
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts();
  }

  filterProduct(String ch) {
    listFiltred = List.from(
      listProduct
          .where(
            (element) => element.title.toLowerCase().contains(ch.toLowerCase()),
          )
          .toList(),
    );
    update();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await Constants.reposit.repGetCategorie();
      if (response['status'] == 'success' && response['data'] != null) {
        listCat = response['data'].map<MCat>((e) => MCat.fromJson(e)).toList();
      } else {}
    } catch (e) {
    } finally {
      update();
    }
  }

  Future<void> fetchProducts() async {
    try {
      status = ListeStatus.loading;
      update();
      final response = await Constants.reposit.repGetProduct();

      if (response['status'] == 'success' && response['data'] != null) {
        status = ListeStatus.success;

        listProduct = response['data']
            .map<MProduct>((e) => MProduct.fromJson(e))
            .toList();
        listFiltred = List.from(listProduct);

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

  // Add new category
  Future<void> addProduct(int? id) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      addStatus = ListeStatus.loading;
      update();

      // Prepare category data
      Map<String, dynamic> categoryData = {
        "title":
            '{"ar":"${arabicController.text.trim()}","fr":"${frenchController.text.trim()}","en":"${englishController.text.trim()}"}',
        'categorie_id': selectedCat!.id,
        'id': id,
      };

      // Call API to add category
      final response = await Constants.reposit.repAddProduct(categoryData);

      if (response['status'] == 'success') {
        addStatus = ListeStatus.success;

        // Clear form
        arabicController.clear();
        frenchController.clear();
        englishController.clear();
        selectedCat = null;
        CtrlDashboard ctrl = Get.find();
        ctrl.loadDashboardData();

        // Refresh categories list
        await fetchProducts();
        Get.back();

        Get.snackbar(
          'Success',
          'Category added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Close bottom sheet
        Get.back();
      } else {
        addStatus = ListeStatus.error;
        Get.snackbar(
          'Error',
          'Failed to add category: ${response['message'] ?? 'Unknown error'}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      addStatus = ListeStatus.error;
      Get.snackbar(
        'Error',
        'Failed to add category: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
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
        ctrl.loadDashboardData();
        Get.snackbar(
          'Success',
          'Produit dSupprimé avec Succés',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Close bottom sheet
        fetchCategories();
        Get.back();
      }
    } catch (e) {}
  }

  @override
  void onClose() {
    arabicController.dispose();
    frenchController.dispose();
    englishController.dispose();
    super.onClose();
  }
}
