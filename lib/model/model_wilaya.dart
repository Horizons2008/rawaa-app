import 'dart:convert';

class MWilaya {
  MWilaya({required this.id, required this.title});
  late final int id;
  late final String title;

  MWilaya.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = getTitle(json['title']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    // _data['title'] = title.toJson();
    return _data;
  }

  String getTitle(dynamic s) {
    // Convert the input string `s` to JSON and return the value of 'fr'
    try {
      final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(s);

      return jsonMap['fr'] ?? '';
    } catch (e) {
      return s;
    }
  }
}
