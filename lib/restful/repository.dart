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

  Future<dynamic> repUpdateFcmToken(var data) async {
    return await Constants.ws.post("updateToken", data);
  }

  Future<dynamic> repGetProfile() async {
    return await Constants.ws.get("getProfile", null);
  }

  Future<dynamic> repGetUserById(int userId) async {
    return await Constants.ws.get("getUserById/$userId", null);
  }

  Future<dynamic> repGetAllUser() async {
    return await Constants.ws.get("getAllUsers", null);
  }

  Future<dynamic> repStoreMsg(var data) async {
    return await Constants.ws.post("messages", data);
  }

  Future<dynamic> repGetMsg(int id) async {
    return await Constants.ws.get("messages/$id", null);
  }

  Future<dynamic> repGetOrderById() async {
    return await Constants.ws.get("orderById", null);
  }

  Future<dynamic> repProposePrice(dynamic data) async {
    return await Constants.ws.post("proposePrice", data);
  }

  Future<dynamic> repAcceptePrice(dynamic data) async {
    return await Constants.ws.post("acceptePrice", data);
  }

  Future<dynamic> reprefusePrice(dynamic data) async {
    return await Constants.ws.post("refusePrice", data);
  }

  Future<dynamic> repGetStock(String id) async {
    return await Constants.ws.get("getStockByVendeur/$id", null);
  }

  Future<dynamic> repGetDetailByOrderId(int id) async {
    return await Constants.ws.get("detailByOrderId/$id", null);
  }

  Future<dynamic> repChangeStatus(int id, int status) async {
    return await Constants.ws.get("changeStatus/$id/$status", null);
  }

  Future<dynamic> repGetAllStock() async {
    return await Constants.ws.get("stock", null);
  }

  Future<dynamic> repStoreOrder(dynamic data) async {
    return await Constants.ws.post("order", data);
  }

  Future<dynamic> repStoreStock(var data, List<File> imageList) async {
    List<MultipartFile> multipartFiles = [];

    for (int i = 0; i < imageList.length; i++) {
      multipartFiles.add(
        await MultipartFile.fromFile(
          imageList[i].path,
          filename: 'image$i.jpg',
          contentType: DioMediaType(
            'image',
            'jpeg',
          ), // Use MediaType instead of DioMediaType
        ),
      );
    }
    FormData formData = FormData();
    for (int i = 0; i < multipartFiles.length; i++) {
      formData.files.add(MapEntry('images[]', multipartFiles[i]));
    }

    if (data is Map<String, dynamic>) {
      data.forEach((key, value) {
        if (key != 'images') {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });
    }
    return await Constants.ws.post("stock", formData);
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

  Future<dynamic> repDeleteStock(int id) async {
    return await Constants.ws.delete("stock/$id");
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

  //************************************************ */
}
