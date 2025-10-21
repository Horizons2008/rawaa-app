import 'dart:convert';

class MCommune {
  MCommune({required this.id, required this.title});
  late final int id;
  late final int wilaya_id;

  late final String title;

  MCommune.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wilaya_id = json['wilaya_id'];
    title = getTitle(json['title']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['wilaya_id'] = wilaya_id;
    _data['title'] = title;
    return _data;
  }

  String getTitle(String s) {
    // Convert the input string `s` to JSON and return the value of 'fr'
    try {
      final Map<String, dynamic> jsonMap = json.decode(s);
      return jsonMap['fr'];
    } catch (e) {
      return s;
    }
  }
}
