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

    title = jsonEncode(json['title']);
    categorieId = json['categorie_id'];
    categorieTitle = json['categorie_title'].toString();
  }

  //to json

  //to json
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'categorie_id': categorieId,
    'categorie_title': categorieTitle,
  };
}
