import 'dart:convert';

import 'package:rawaa_app/styles/constants.dart';

class MProduct {
  late final int id;
  late final String title;
  late final String categorieTitle;

  late final int categorieId;

  MProduct({
    required this.id,
    required this.title,
    required this.categorieId,
    required this.categorieTitle,
  });

  //from json
  MProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    title = getTitle(json['title']);
    categorieId = json['categorie_id'];
    categorieTitle = getTitle(json['categorie_title']);
  }

  //to json

  //to json
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'categorie_id': categorieId,
    'categorie_title': categorieTitle,
  };

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
