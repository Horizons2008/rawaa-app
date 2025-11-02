class Muser {
  late String name;
  late String id;

  late String role;
  late String phone;
  late String username;

  late String wilayaTitle;
  late String communeTitle;
  String token = "";

  Muser({
    required this.id,

    required this.name,
    required this.role,
    required this.phone,
    required this.username,
    required this.wilayaTitle,
    required this.communeTitle,
    required this.token,
  });
  Muser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    role = json['role'];
    phone = json['phone'];
    username = json['username'];
    wilayaTitle = json['wilaya_title'];
    communeTitle = json['commune_title'];
    id = json['id'].toString();
  }
}
