import 'dart:convert';

import 'package:rawaa_app/styles/constants.dart';

class MStock {
  late final int id;
  late final String productTitle;
  late final String productId;
  late final String vendeurId;
  late final String vendeurName;
  late final double qte;
  late final double price;
  MStock({
    required this.id,
    required this.productTitle,
    required this.productId,
    required this.vendeurId,
    required this.vendeurName,
    required this.qte,
    required this.price,
  });

  MStock.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productTitle = getTitle(json['product_title']);
    productId = json['product_id'].toString();
    vendeurId = json['vendeur_id'].toString();
    vendeurName = json['vendeur_name'];
    qte = json['qte'] * 1.0;
    price = json['price'] * 1.0;
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

  String getTitle(String s) {
    // Convert the input string `s` to JSON and return the value of 'fr'
    try {
      final Map<String, dynamic> jsonMap = json.decode(s);
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
