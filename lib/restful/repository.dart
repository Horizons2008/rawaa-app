import 'package:rawaa_app/restful/web_service.dart';
import 'package:rawaa_app/styles/constants.dart';

class Repository {
  final WebService ws;
  Repository(this.ws);

  Future<dynamic> repGetWilaya() async {
    return await Constants.ws.get("getWilaya", null);
  }

  Future<dynamic> repGetCommune(int idWilaya) async {
    return await Constants.ws.get("getCommune/$idWilaya", null);
  }

  Future<dynamic> repRegister(var data) async {
    return await Constants.ws.post("register", data);
  }

  //******************************************************* */
  Future checkLogin(String username, String password) async {
    return await ws.post("login", {"username": username, "password": password});
  }

  Future<dynamic> repPing() async {
    return await Constants.ws.wsPing();
  }

  Future repGetAllReceivedData() async {
    return await Constants.ws.get("receptions", {"warehouse_id": "1"});
  }

  Future repGetAllPckingData() async {
    return await Constants.ws.get("picking_list", {"warehouse_id": "1"});
  }

  Future repCheckPin(String pin) async {
    return await Constants.ws.get("check_pin", {"pin": pin});
  }

  Future repgetPackagingList() async {
    return await Constants.ws.get("packaging", {"warehouse_id": "1"});
  }

  Future repUpdateFcmToken(String fcm_token) async {
    return await Constants.ws.get("update_fcm_token", {
      "warehouse_id": "1",
      "fcm_token": fcm_token,
    });
  }

  //************************************************ */
}
