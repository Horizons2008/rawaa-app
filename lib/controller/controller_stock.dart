import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rawaa_app/model/model_categorie.dart';
import 'package:rawaa_app/model/model_product.dart';
import 'package:rawaa_app/model/model_stock.dart';
import 'package:rawaa_app/styles/constants.dart';

class ControllerStock extends GetxController {
  ListeStatus statusCat = ListeStatus.none;
  ListeStatus status = ListeStatus.none;
  ListeStatus statusProd = ListeStatus.none;
  ListeStatus statusStore = ListeStatus.none;
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  List<MStock> listeStock = <MStock>[];
  List<MStock> filteredList = <MStock>[];
  final TextEditingController searchController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController qteController = TextEditingController();
  MCat? selectedCat;
  MProduct? selectedProd;

  List<MCat> listeCat = <MCat>[];
  List<MProduct> listeProd = <MProduct>[];
  List<File> images = [];

  getCat() async {
    await Constants.reposit.repGetCategorie().then((value) {
      if (value['status'] == "success") {
        listeCat = value['data'].map<MCat>((e) => MCat.fromJson(e)).toList();
        update();
      }
    });
  }

  changeCat(MCat cat) {
    selectedCat = cat;
    listeProd = [];
    selectedProd = null;
    update();
    getProduct(cat.id);
  }

  getProduct(int id) async {
    await Constants.reposit.repGetProdByCat(id).then((value) {
      if (value['status'] == "success") {
        listeProd = value['data']
            .map<MProduct>((e) => MProduct.fromJson(e))
            .toList();
        update();
      }
    });
  }

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
        images.add(selectedImage!);
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

  // getStock() async {

  getStock() async {
    status = ListeStatus.loading;
    update();
    await Constants.reposit.repGetStock(Constants.currentUser!.id).then((
      value,
    ) {
      if (value['status'] == "success") {
        status = ListeStatus.success;
        listeStock = value['data']
            .map<MStock>((e) => MStock.fromJson(e))
            .toList();
        filteredList = listeStock;
        update();
        print("ttttttttttttt ${listeStock.length}");
      } else {
        status = ListeStatus.error;
        update();
      }
    });
  }

  storeStock() async {
    statusStore = ListeStatus.loading;
    update();
    await Constants.reposit
        .repStoreStock({
          "product_id": selectedProd!.id,
          "vendeur_id": Constants.currentUser!.id,
          "price": priceController.text,
          "qte": qteController.text,
          "promo": "0",
        }, images)
        .then((value) {
          print("store stooooooooooooooooooooooooooooooock $value");
          if (value['status'] == "success") {
            statusStore = ListeStatus.success;
            Get.back();
            getStock();
            Constants.showSnackBar(
              "Confirmation",
              "Votre produit est attribué avec succés",
            );

            update();
          } else if (value['status'] == "product existe") {
            Constants.showSnackBar("Erreur", "Ce produit est déja attribué à ");
            statusStore = ListeStatus.error;
            update();
          } else {
            status = ListeStatus.error;
            update();
          }
        });
  }

  void filterStocks(String query) {
    if (query.isEmpty) {
      filteredList = listeStock;
    } else {
      filteredList = listeStock.where((stock) {
        return stock.productTitle.toLowerCase().contains(query.toLowerCase()) ||
            stock.vendeurName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getStock();
    getCat();
    searchController.addListener(() {
      filterStocks(searchController.text);
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
