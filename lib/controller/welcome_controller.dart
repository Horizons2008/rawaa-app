import 'package:get/get.dart';
import 'package:rawaa_app/model/model_categorie.dart';
import 'package:rawaa_app/model/model_pannier.dart';
import 'package:rawaa_app/model/model_stock.dart';
import 'package:rawaa_app/services/service_cart.dart';
import 'package:rawaa_app/styles/constants.dart';

class WelcomeClientController extends GetxController {
  List<MCat> listeCat = [];
  List<MStock> listeStock = [];
  double qte = 1;
  double total = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCategorie();
    getStock();
  }

  getCategorie() {
    Constants.reposit.repGetCategorie().then((value) {
      listeCat = value['data'].map<MCat>((e) => MCat.fromJson(e)).toList();
      update();
    });
  }

  getStock() {
    Constants.reposit.repGetAllStock().then((value) {
      listeStock = value['data']
          .map<MStock>((e) => MStock.fromJson(e))
          .toList();
      update();
    });
  }

  addToCart(MStock stock) {
    print("tttttttttttttttttttt ${stock.vendeurId}");
    print("tttttttttttttttttttt ${stock.vendeurName}");

    CartItem item = CartItem(
      productTitle: stock.productTitle,
      categorieTitle: stock.catTitle,
      stockId: stock.id,
      price: stock.price,
      qte: qte,
      position: 0,
      vendeurId: stock.vendeurId,
      vendeurTitle: stock.vendeurName,
    );
    CartService.addToCart(item);
    print("xxxxxxxxxxxxxxxx ${CartService.getItemCount()}");
    update();
  }
}
