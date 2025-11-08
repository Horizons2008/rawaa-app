import 'package:get/get.dart';
import 'package:rawaa_app/model/model_detail.dart';
import 'package:rawaa_app/model/model_order.dart';
import 'package:rawaa_app/styles/constants.dart';

class OrderController extends GetxController {
  ListeStatus status = ListeStatus.none;
  List<MOrder> listeOrder = [];
  List<MDetail> listeDetail = [];

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
    await Constants.reposit.repGetOrderById().then((value) {
      listeOrder = value['data']
          .map<MOrder>((e) => MOrder.fromJson(e))
          .toList();

      status = ListeStatus.success;
      update();
    });
  }

  Future<void> changeStatus(int status) async {
    await Constants.reposit.repChangeStatus(selectedOrder!.id, status).then((
      value,
    ) {
      selectedOrder!.status = status;
      update();
    });
  }

  getDetailOrder(MOrder ord) async {
    selectedOrder = ord;
    await Constants.reposit.repGetDetailByOrderId(selectedOrder!.id).then((
      value,
    ) {
      listeDetail = value['data']
          .map<MDetail>((e) => MDetail.fromJson(e))
          .toList();
    });
    update();
  }
}
