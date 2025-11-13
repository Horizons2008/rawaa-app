import 'dart:convert';

import 'package:get/get.dart';
import 'package:rawaa_app/controller/dash_client_controller.dart';
import 'package:rawaa_app/model/model_pannier.dart';
import 'package:rawaa_app/services/service_cart.dart';
import 'package:rawaa_app/styles/constants.dart';

class CartController extends GetxController {
  List<CartItem> cart = [];
  double total = 0.0;
  int itemCount = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getCartItems();
  }

  Future<void> getCartItems() async {
    itemCount = CartService.getAllCartItems().length;
    cart = CartService.getAllCartItems();
    total = CartService.getTotalPrice();
    update();
  }

  sendORder(bool livraison) async {
    List<Map<String, dynamic>> cartJson = cart
        .map((item) => item.toJson())
        .toList();

    // Send to REST API
    String jsonString = jsonEncode(cartJson);

    Map<String, dynamic> data = {
      'client_id': Constants.currentUser!.id,
      'vendeur_id': cart[0].vendeurId,
      'total': total,
      'items': jsonString,
      'livraison': livraison == true ? 1 : 0,
    };
    try {
      await Constants.reposit.repStoreOrder(data).then((onValue) {
        if (onValue['status'] == 'success') {
          CartService.clearCart();
          DashClientController ctrl = Get.find();
          ctrl.changePage(0);
          ctrl.update();
          Constants.showSnackBar(
            "Confirmation",
            "Votre demande est prise encharge",
          );
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
