import 'package:get/get.dart';
import 'package:rawaa_app/model/model_detail.dart';
import 'package:rawaa_app/model/model_order.dart';
import 'package:rawaa_app/styles/constants.dart';

class OrderController extends GetxController {
  ListeStatus status = ListeStatus.none;
  List<MOrder> listeOrder = [];
  List<MDetail> listeDetail = [];
  dynamic detailClient;
  dynamic detailVendeur;

  MOrder? selectedOrder;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchOrder();
  }

  fetchOrder() async {
    status = ListeStatus.loading;
    update();
    try {
      await Constants.reposit.repGetOrderById().then((value) {
       
        if (value['status'] == 'success') {
          detailClient = value['client'];
          detailVendeur = value['vendeur'];
          listeOrder = value['data']
              .map<MOrder>((e) => MOrder.fromJson(e))
              .toList();

          status = ListeStatus.success;
          update();
        } else if (value['status'] == 'error') {
          status = ListeStatus.error;
          print(value);
          update();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  proposePrice(double price) async {
    dynamic data = {"id": selectedOrder!.id, "price": price};
    await Constants.reposit.repProposePrice(data).then((value) {
      selectedOrder!.livraison = 1;
      selectedOrder!.fraisLivraison = price;
      update();
      fetchOrder();
      Get.back();
    });
  }

  acceptePrice() async {
    dynamic data = {"id": selectedOrder!.id};
    print('selected order $data');
    await Constants.reposit.repAcceptePrice(data).then((value) {
      
      selectedOrder!.livraison = 3;

      update();
      fetchOrder();
      Get.back();
    });
  }

  refusePrice() async {
    dynamic data = {"id": selectedOrder!.id};
    await Constants.reposit.repProposePrice(data).then((value) {
      selectedOrder!.livraison = 1;
      selectedOrder!.fraisLivraison = null;
      selectedOrder!.driverId = null;

      update();
      fetchOrder();
      Get.back();
    });
  }

  Future<void> changeStatus(int status) async {
    await Constants.reposit.repChangeStatus(selectedOrder!.id, status).then((
      value,
    ) {
      selectedOrder!.status = status;
      update();
      Get.back();
      Constants.showSnackBar('Success', 'Status changé avec succées ');
    });
  }

  getDetailOrder(MOrder ord) async {
    selectedOrder = ord;
    await Constants.reposit.repGetDetailByOrderId(selectedOrder!.id).then((
      value,
    ) {
      
      detailClient = value['client'];
      detailVendeur = value['vendeur'];
      listeDetail = value['data']
          .map<MDetail>((e) => MDetail.fromJson(e))
          .toList();
    });
    update();
  }
}
