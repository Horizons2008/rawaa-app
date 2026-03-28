class Muser {
  late String name;
  late String id;

  late String role;
  late String username;

  late String? image;
  String token = "";

  Muser({
    required this.id,
    this.image,
    required this.name,
    required this.role,
    required this.username,
    required this.token,
  });
  Muser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    role = json['role'];

    username = json['username'];
    image = json['image'];
    id = json['id'].toString();
  }
}
