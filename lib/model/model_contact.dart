class MContact {
  late final int id;
  late final String name;
  late final String role;
  MContact({required this.id, required this.name, required this.role});

  MContact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['username'];
    role = json['role'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['role'] = role;
    return data;
  }
}
