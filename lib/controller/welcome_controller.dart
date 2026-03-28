import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/model/model_categorie.dart';
import 'package:rawaa_app/model/model_pannier.dart';
import 'package:rawaa_app/model/model_product.dart';
import 'package:rawaa_app/model/model_stock.dart';
import 'package:rawaa_app/services/service_cart.dart';
import 'package:rawaa_app/styles/constants.dart';

class WelcomeClientController extends GetxController {
  List<MCat> listeCat = [];
  List<MStock> listeStock = [];
  List<MStock> filteredStock = [];
  List<MProduct> listeProduct = [];
  List<MProduct> filteredProduct = [];
  List<MStock> listeStockByProduct = [];
  double qte = 1;
  double total = 0;
  ListeStatus status = ListeStatus.none;
  int? currentCategoryId;
  bool isFetching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCategorie();
    getStock();
    searchController.addListener(() {
      filterProducts(searchController.text);
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  getCategorie() {
    Constants.reposit.repGetCategorie().then((value) {
      listeCat = value['data'].map<MCat>((e) => MCat.fromJson(e)).toList();
      update();
    });
  }

  getStock() {
    try {
      Constants.reposit.repGetAllStock().then((value) {
        listeStock = value['data']
            .map<MStock>((e) => MStock.fromJson(e))
            .toList();
        filteredStock = List.from(listeStock);
        update();
      });
    } catch (e) {}
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredStock = List.from(listeStock);
    } else {
      filteredStock = listeStock.where((stock) {
        final productTitle = stock.productTitle.toLowerCase();
        final searchQuery = query.toLowerCase();
        return productTitle.contains(searchQuery);
      }).toList();
    }
    update();
  }

  getProductsByCategory(int categoryId) async {
    // Prevent multiple simultaneous fetches for the same category
    if (isFetching && currentCategoryId == categoryId) {
      return;
    }

    // If we already have data for this category, don't fetch again
    if (currentCategoryId == categoryId &&
        status == ListeStatus.success &&
        listeProduct.isNotEmpty) {
      return;
    }

    isFetching = true;
    currentCategoryId = categoryId;
    status = ListeStatus.loading;
    update();

    try {
      final value = await Constants.reposit.repGetProductsByCategory(
        categoryId,
      );
      // Check for error status
      if (value['status'] == 'ERROR' || value['status'] == 'error') {
        listeProduct = [];
        status = ListeStatus.error;
        isFetching = false;
        update();
        return;
      }

      // Check if data exists and is not empty
      if (value['status'] == 'success' && value['data'] != null) {
        final dataList = value['data'];
        print(
          "vvvvvvvvv00000vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvalue ${dataList is List}",
        );

        // Check if data is an empty array
        if (dataList is List && dataList.isEmpty) {
          listeProduct = [];
          status = ListeStatus.success; // Success but empty
          isFetching = false;
          update();
          return;
        }

        // Parse the data using MProduct.fromJson
        try {
          listeProduct = (dataList as List)
              .map<MProduct>((e) => MProduct.fromJson(e))
              .toList();
          filteredProduct = List.from(listeProduct);
          status = ListeStatus.success;
        } catch (parseError) {
          print('Error parsing product data: $parseError');
          listeProduct = [];
          status = ListeStatus.error;
        }
      } else {
        listeProduct = [];
        status = ListeStatus.error;
      }
    } catch (e) {
      print('Error fetching products by category: $e');
      listeProduct = [];
      status = ListeStatus.error;
    } finally {
      isFetching = false;
      update();
    }
  }

  void filterProductsByCategory(String query) {
    if (query.isEmpty) {
      filteredProduct = List.from(listeProduct);
    } else {
      filteredProduct = listeProduct.where((product) {
        final title = Constants.getTitle(
          product.title,
          Constants.lang,
        ).toLowerCase();
        final searchQuery = query.toLowerCase();
        return title.contains(searchQuery);
      }).toList();
    }
    update();
  }

  getStockByProduct(int productId) async {
    status = ListeStatus.loading;
    update();
    try {
      final value = await Constants.reposit.repGetStockByProduct(productId);
      if (value['status'] == "success") {
        listeStockByProduct = value['data']
            .map<MStock>((e) => MStock.fromJson(e))
            .toList();
        status = ListeStatus.success;
      } else {
        status = ListeStatus.error;
      }
    } catch (e) {
      status = ListeStatus.error;
    } finally {
      update();
    }
  }

  addToCart(MStock stock) {
    CartItem item = CartItem(
      productTitle: stock.productTitle,
      categorieTitle: stock.catTitle,
      stockId: stock.id,
      price: stock.price,
      qte: qte,
      position: 0,
      vendeurId: stock.vendeurId,
      vendeurTitle: stock.vendeurName,
    );
    CartService.addToCart(item);

    update();
    Get.back();
    Constants.showSnackBar("Confirmation", "Produit ajouté au panier");
  }
}
