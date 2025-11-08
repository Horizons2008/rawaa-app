import 'package:hive/hive.dart';

part 'model_pannier.g.dart';

@HiveType(typeId: 0)
class CartItem extends HiveObject {
  @HiveField(0)
  String productTitle;

  @HiveField(1)
  String categorieTitle;

  @HiveField(2)
  int stockId;

  @HiveField(3)
  double price;

  @HiveField(4)
  double qte;
  @HiveField(5)
  int position;
  @HiveField(6)
  String vendeurId;
  @HiveField(7)
  String vendeurTitle;

  CartItem({
    required this.productTitle,
    required this.categorieTitle,
    required this.stockId,
    required this.price,
    required this.qte,
    required this.position,
    required this.vendeurId,
    required this.vendeurTitle,
  });
  // Method to add a CartItem to a List<CartItem>

  // Method to get total price of items in a List<CartItem>
  static double getTotal(List<CartItem> cartList) {
    return cartList.fold(0.0, (sum, item) => sum + (item.price * item.qte));
  }

  Map<String, dynamic> toJson() {
    return {
      'productTitle': productTitle,
      'categorieTitle': categorieTitle,
      'stockId': stockId,
      'price': price,
      'qte': qte,
      'position': position,
      'vendeurId': vendeurId,
      'vendeurTitle': vendeurTitle,
    };
  }
}
