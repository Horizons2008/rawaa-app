import 'package:hive/hive.dart';
import 'package:rawaa_app/model/model_pannier.dart';

class CartService {
  static Box<CartItem> get _cartBox => Hive.box<CartItem>('cartBox');

  // Add item to cart
  static Future<void> addToCart(CartItem item) async {
    print(item.vendeurId);
    print(item.vendeurTitle);

    final cartList = getAllCartItems();

    // Check if item already exists
    final existingIndex = cartList.indexWhere((c) => c.stockId == item.stockId);

    if (existingIndex >= 0) {
      // Update quantity if exists
      cartList[existingIndex].qte += item.qte;
      await cartList[existingIndex].save();
    } else {
      // Add new item
      await _cartBox.add(item);
    }
  }

  // Get all cart items
  static List<CartItem> getAllCartItems() {
    return _cartBox.values.toList();
  }

  // Get total price
  static double getTotalPrice() {
    return CartItem.getTotal(getAllCartItems());
  }

  // Update item quantity
  static Future<void> updateQuantity(int stockId, double newQte) async {
    final item = _cartBox.values.firstWhere((item) => item.stockId == stockId);
    item.qte = newQte;
    await item.save();
  }

  // Remove item from cart
  static Future<void> removeFromCart(int stockId) async {
    final item = _cartBox.values.firstWhere((item) => item.stockId == stockId);
    await item.delete();
  }

  // Clear entire cart
  static Future<void> clearCart() async {
    await _cartBox.clear();
  }

  // Get item count
  static int getItemCount() {
    return _cartBox.values.length;
  }
}
