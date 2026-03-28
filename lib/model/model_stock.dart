import 'dart:convert';

import 'package:rawaa_app/styles/constants.dart';

class MStock {
  late final int id;
  late final String productTitle;
  late final String productId;
  late final String catTitle;
  late final String catId;
  late final String vendeurId;
  late final String vendeurName;
  late final String? vendeurPhone;
  late final dynamic vendeurWilaya; // JSON map {ar, fr, en} or null
  late final dynamic vendeurCommune; // JSON map {ar, fr, en} or null
  late final String? vendeurPicture; // full URL or null
  late final double qte;
  late final double price;
  late final String description;
  late final List<String> images;
  late final String? ficheTechniquePath;

  MStock({
    required this.id,
    required this.productTitle,
    required this.productId,
    required this.catTitle,
    required this.catId,
    required this.description,

    required this.vendeurId,
    required this.vendeurName,
    this.vendeurPhone,
    this.vendeurWilaya,
    this.vendeurCommune,
    this.vendeurPicture,
    required this.qte,
    required this.price,
    required this.images,
    this.ficheTechniquePath,
  });

  MStock.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productTitle = getTitle(json['product_title']);
    productId = json['product_id'].toString();
    catTitle = getTitle((json['categorie_title']));
    catId = json['categorie_id'].toString();

    vendeurId = json['vendeur_id'].toString();
    vendeurName = json['vendeur_name'] ?? '';
    vendeurPhone = json['vendeur_phone'];
    vendeurWilaya = json['vendeur_wilaya']; // raw map from API
    vendeurCommune = json['vendeur_commune']; // raw map from API
    vendeurPicture = json['vendeur_picture'];
    qte = json['qte'] * 1.0;
    price = json['price'] * 1.0;
    description = json['description'];
    images = List<String>.from(
      json['images'].split(',').map((e) => e.trim()).toList(),
    );
    ficheTechniquePath = json['fiche_technique_path'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_title': productTitle,
      'product_id': productId,
      'vendeur_id': vendeurId,
      'vendeur_name': vendeurName,
      'qte': qte,
      'price': price,
    };
  }

  String getTitle(dynamic s) {
    // Convert the input string `s` to JSON and return the value of 'fr'
    try {
      final Map<String, dynamic> jsonMap = s;
      switch (Constants.lang) {
        case "fr":
          return jsonMap['fr'];

        case "en":
          return jsonMap['en'];

        case "ar":
          return jsonMap['ar'];

        default:
          return jsonMap['fr'];
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeee $e");
      return s;
    }
  }
}
