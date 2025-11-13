class MOrder {
  MOrder({
    required this.id,
    required this.total,
    required this.dateDemande,
    required this.vendeurId,
    required this.vendeurName,
    required this.clientId,
    required this.clientName,
    required this.status,
    required this.livraison,
    required this.fraisLivraison,
  });
  late final int id;
  late final int total;
  late final String dateDemande;
  late final int vendeurId;
  late final String vendeurName;
  late final int? driverId;
  late final String? driverName;
  late final int clientId;
  late final String clientName;
  late int livraison;
  late double? fraisLivraison;

  late int status;

  MOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    dateDemande = json['dateDemande'];
    vendeurId = json['vendeur_id'];
    vendeurName = json['vendeur_name'];
    clientId = json['client_id'];
    clientName = json['client_name'];
    driverId = json['livreur_id'];
    driverName = json['livreur_name'];
    status = json['status'];
    livraison = json['livraison'];
    fraisLivraison = json['fraisLivraison'] is int
        ? json['fraisLivraison'] * 1.0
        : json['fraisLivraison'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['total'] = total;
    _data['dateDemande'] = dateDemande;
    _data['vendeur_id'] = vendeurId;
    _data[' vendeur_name'] = vendeurName;
    _data['client_id'] = clientId;
    _data['client_name'] = clientName;
    _data['status'] = status;
    return _data;
  }
}
