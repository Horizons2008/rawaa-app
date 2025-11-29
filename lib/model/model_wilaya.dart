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

  String getTitle(String s) {
    // Convert the input string `s` to JSON and return the value of 'fr'
    try {
      final Map<String, dynamic> jsonMap = s.isNotEmpty
          ? Map<String, dynamic>.from(jsonDecode(s))
          : {};
      return jsonMap['fr'] ?? '';
    } catch (e) {
      return s;
    }
  }
}
