import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

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
  File? selectedFicheTechnique;
  final ImagePicker _picker = ImagePicker();

  List<MStock> listeStock = <MStock>[];
  List<MStock> filteredList = <MStock>[];
  final TextEditingController searchController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController qteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  MCat? selectedCat;
  MProduct? selectedProd;
  MStock? selectedStock;

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
      print("ffffffffffffffffffffffffffffffffffff $value");
      if (value['status'] == "success") {
        listeProd = value['data']
            .map<MProduct>((e) => MProduct.fromJson(e))
            .toList();
        update();
      }
    });
  }

  editStock(MStock stock) async {
    selectedStock = stock;
    selectedCat = listeCat.firstWhere(
      (element) => element.id.toString() == stock.catId,
    );
    await getProduct(selectedCat!.id);
    selectedProd = listeProd.firstWhere(
      (element) => element.id.toString() == stock.productId,
    );
    priceController.text = stock.price.toString();
    qteController.text = stock.qte.toString();
    descriptionController.text = stock.description;

    images.clear();
    for (var image in stock.images) {
      try {
        var url = "${Constants.photoUrl}stock/$image";
        var tempDir = Directory.systemTemp;
        var tempPath = '${tempDir.path}/$image';
        await Dio().download(url, tempPath);
        images.add(File(tempPath));
      } catch (e) {
        print("Error downloading image $image: $e");
      }
    }

    if (stock.ficheTechniquePath != null &&
        stock.ficheTechniquePath!.isNotEmpty) {
      try {
        var url =
            "${Constants.photoUrl}stock/fiches/${stock.ficheTechniquePath}";
        var tempDir = Directory.systemTemp;
        var tempPath = '${tempDir.path}/${stock.ficheTechniquePath}';
        await Dio().download(url, tempPath);
        selectedFicheTechnique = File(tempPath);
      } catch (e) {
        print("Error downloading fiche technique: $e");
      }
    }

    update();
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

  Future<void> pickFicheTechnique() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        selectedFicheTechnique = File(result.files.single.path!);
        update();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick file: ${e.toString()}',
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
      print("gggggggggggggggggggggggggggggggggggggggg $value");
      if (value['status'] == "success") {
        status = ListeStatus.success;
        listeStock = value['data']
            .map<MStock>((e) => MStock.fromJson(e))
            .toList();
        filteredList = listeStock;
        update();
      } else {
        status = ListeStatus.error;
        update();
      }
    });
  }

  void reset() {
    images = [];
    selectedImage = null;
    selectedProd = null;
    selectedCat = null;
    selectedStock = null;
    selectedFicheTechnique = null;
    priceController.clear();
    qteController.clear();
    descriptionController.clear();
    update();
  }

  storeStock() async {
    // Validate required fields
    if (selectedProd == null) {
      Constants.showSnackBar("Erreur", "Veuillez sélectionner un produit");
      return;
    }

    if (priceController.text.isEmpty || qteController.text.isEmpty) {
      Constants.showSnackBar("Erreur", "Veuillez remplir tous les champs");
      return;
    }

    if (images.isEmpty) {
      Constants.showSnackBar(
        "Erreur",
        "Veuillez sélectionner au moins une image",
      );
      return;
    }

    statusStore = ListeStatus.loading;
    update();

    try {
      final value = await Constants.reposit.repStoreStock(
        {
          "id": selectedStock?.id,
          "product_id": selectedProd!.id,
          "vendeur_id": Constants.currentUser!.id,
          "price": priceController.text,
          "qte": qteController.text,
          "promo": "0",
          "description": descriptionController.text,
        },
        images,
        ficheTechnique: selectedFicheTechnique,
      );

      if (value['status'] == "success") {
        statusStore = ListeStatus.success;
        Get.back();
        Constants.showSnackBar("Success", "Stock added successfully");
        reset();

        getStock();
        // Clear form after success
        update();
      } else {
        Constants.showSnackBar(
          "Erreur",
          value['message'] ?? "Une erreur est survenue",
        );
        statusStore = ListeStatus.error;
        update();
      }
    } catch (e) {
      Constants.showSnackBar(
        "Erreur",
        "Erreur lors de l'envoi: ${e.toString()}",
      );
      statusStore = ListeStatus.error;
      update();
    }
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
