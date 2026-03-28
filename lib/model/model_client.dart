import 'dart:convert';

class MClient {
  late final int id;
  late final int userId;

  late final String name;
  late final String username;
  late final String phone;
  late final String commune;
  late final String wilaya;

  late final String status;
  late final String? image;

  MClient({
    required this.id,
    required this.userId,
    required this.commune,
    required this.name,
    required this.phone,
    required this.status,
    required this.wilaya,
    required this.username,
  });

  //from json
  MClient.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userId = json['user_id'] ?? 0;

    name = json['name']?.toString() ?? "";
    commune = json['commune'] != null
        ? jsonEncode(json['commune']['title'])
        : "";
    wilaya = json['wilaya'] != null ? jsonEncode(json['wilaya']['title']) : "";
    phone = json['phone']?.toString() ?? "";
    status = json['status']?.toString() ?? "";
    username = json['user']?['username']?.toString() ?? "";
    image = json['user']?['image']?.toString();
  }

  //to json
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
