import 'dart:convert';

import 'package:rawaa_app/styles/constants.dart';

class MCat {
  late final int id;
  late final String title;
  late final String? image;
  MCat({required this.id, required this.title, this.image});

  //from json
  MCat.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    title = jsonEncode(json['title']);
    image = json['image'];
  }

  //to json
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'image': image};
}
