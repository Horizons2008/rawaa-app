class MClient {
  late final int id;
  late final int userId;

  late final String name;
  late final String username;
  late final String phone;
  late final String commune;
  late final String wilaya;

  late final String status;

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
    id = json['id'];
    userId = json['user_id'];

    name = json['name'];
    commune = json['commune']['title'];
    wilaya = json['wilaya']['title'];
    phone = json['phone'];
    status = json['status'];
    username = json['user']['username'];
  }

  //to json
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
