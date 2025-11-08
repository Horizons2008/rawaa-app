class MDetail {
  MDetail({
    required this.id,
    required this.productId,
    required this.productName,
    required this.qte,
    required this.price,
  });
  late final int id;
  late final int productId;
  late final String productName;
  late final int qte;
  late final int price;

  MDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    productName = json['product_name'];
    qte = json['qte'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['product_id'] = productId;
    _data['product_name'] = productName;
    _data['qte'] = qte;
    _data['price'] = price;
    return _data;
  }
}
