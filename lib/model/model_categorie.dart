import 'dart:convert';

import 'package:rawaa_app/styles/constants.dart';

class MCat {
  late final int id;
  late final String title;
  MCat({required this.id, required this.title});

  //from json
  MCat.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    title = jsonEncode(json['title']);
  }

  //to json
  Map<String, dynamic> toJson() => {'id': id, 'title': title};
}
