import 'dart:io';

import 'package:dio/dio.dart';
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

  Future<dynamic> repCheckUsername(var data) async {
    return await Constants.ws.get("checkUsername", data);
  }

  Future<dynamic> repChangePassword(
    String oldPassword,
    String newPasswordv,
  ) async {
    return await Constants.ws.post("changePassword", {
      "old_password": oldPassword,
      "new_password": newPasswordv,
    });
  }

  Future<dynamic> repCheckPhone(var data) async {
    return await Constants.ws.get("checkPhone", data);
  }

  Future<dynamic> repGetProfile() async {
    return await Constants.ws.get("getProfile", null);
  }

  Future<dynamic> repGetStock(String id) async {
    return await Constants.ws.get("getStockByVendeur/$id", null);
  }

  Future<dynamic> repStoreStock(var data) async {
    return await Constants.ws.post("stock", data);
  }

  Future<dynamic> repUpdateProfile(var data, File image) async {
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        image.path,
        filename: 'image.jpg', // or get from file
        contentType: DioMediaType(
          'image',
          'jpeg',
        ), // adjust based on your file type
      ),
    });
    // Add all fields from 'data' to formData except 'image', since it's handled separately
    if (data is Map<String, dynamic>) {
      data.forEach((key, value) {
        if (key != 'image')
          formData.fields.add(MapEntry(key, value.toString()));
      });
    }

    return await Constants.ws.post("updateProfile", formData);
  }

  Future<dynamic> repGetCategorie() async {
    return await Constants.ws.get("categorie", null);
  }

  Future<dynamic> repGetDashboard() async {
    return await Constants.ws.get("getDashboard", null);
  }

  Future<dynamic> repGetProduct() async {
    return await Constants.ws.get("product", null);
  }

  Future<dynamic> repGetProdByCat(int catId) async {
    return await Constants.ws.get("getproductByCat/$catId", null);
  }

  Future<dynamic> repAddCategorie(int? id, String title, File? image) async {
    var formData;

    image != null
        ? {
            formData = FormData.fromMap({
              "id": id,
              "title": title,
              "image": await MultipartFile.fromFile(
                image.path,
                filename: 'image.jpg', // or get from file
                contentType: DioMediaType(
                  'image',
                  'jpeg',
                ), // adjust based on your file type
              ),
            }),
          }
        : {
            formData = {"id": id, "title": title},
          };
    return await Constants.ws.post("categorie", formData);
  }

  Future<dynamic> repAddProduct(var data) async {
    return await Constants.ws.post("product", data);
  }

  Future<dynamic> repDeleteCategorie(int id) async {
    return await Constants.ws.delete("categorie/$id");
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
