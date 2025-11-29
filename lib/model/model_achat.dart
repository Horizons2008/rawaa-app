// models/purchase_request.dart
class PurchaseRequest {
  final String id;
  final String formationName;
  final String client;
  final double price;
  final String formateur;
  final RequestStatus status;

  PurchaseRequest({
    required this.id,
    required this.formationName,
    required this.client,
    required this.price,
    required this.formateur,
    this.status = RequestStatus.pending,
  });
}

class MAchat {
  late final int id;
  late final int idClient;
  late final int idFormation;
  late final String nameClient;
  late final String nameFormateur;

  late final String titleFormation;
  late final double price;
  late final String status;
  late final DateTime date;

  MAchat({
    required this.id,
    required this.idFormation,
    required this.idClient,
    required this.price,
    required this.nameFormateur,
    required this.nameClient,

    required this.titleFormation,
    required this.status,
    required this.date,
  });
  MAchat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idClient = json['client_id'];
    idFormation = json['formation_id'];
    nameClient = json['client']['name'];
    nameFormateur = json['formation']['prof_name'];

    titleFormation = json['formation']['title'];
    price = double.parse(json['price']);
    status = json['status'];
    date = DateTime.parse(json['date']);
  }
}

enum RequestStatus { pending, accepted, refused }
