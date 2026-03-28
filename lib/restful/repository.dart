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

  Future<dynamic> repGetClient() async {
    return await Constants.ws.get("getClients", null);
  }

  Future<dynamic> repGetVendeur() async {
    return await Constants.ws.get("getVendeurs", null);
  }

  Future<dynamic> repGetCommune(int idWilaya) async {
    return await Constants.ws.get("getCommune/$idWilaya", null);
  }

  Future<dynamic> repRegister(var data) async {
    return await Constants.ws.post("register", data);
  }

  Future<dynamic> repCheckUsername(String username) async {
    return await Constants.ws.get("checkUsername/$username", null);
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

  Future<dynamic> repCheckPhone(String phone) async {
    return await Constants.ws.get("checkPhone/$phone", null);
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

  Future<dynamic> repGetRecentMsg() async {
    return await Constants.ws.get("recentMsg", null);
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

  Future<dynamic> repGetAllFormation() async {
    return await Constants.ws.get("formation", null);
  }

  Future<dynamic> repGetFormationPlaylist(int id) async {
    return await Constants.ws.get("formations/$id/playlist", null);
  }

  Future<dynamic> repDeleteFormation(int id) async {
    return await Constants.ws.delete("formation/$id");
  }

  Future<dynamic> repStoreOrder(dynamic data) async {
    return await Constants.ws.post("order", data);
  }

  Future<dynamic> repStoreStock(
    var data,
    List<File> imageList, {
    File? ficheTechnique,
  }) async {
    // Create FormData
    FormData formData = FormData();

    // Add all data fields first
    if (data is Map<String, dynamic>) {
      data.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });
    }

    // Add multiple images to FormData
    // Laravel expects images[] for array of files
    if (imageList.isNotEmpty) {
      for (int i = 0; i < imageList.length; i++) {
        MultipartFile multipartFile = await MultipartFile.fromFile(
          imageList[i].path,
          filename: 'image_${i + 1}.jpg',
          contentType: DioMediaType('image', 'jpeg'),
        );
        // Use 'images[]' key so Laravel receives it as an array
        formData.files.add(MapEntry('images[]', multipartFile));
      }
    }

    if (ficheTechnique != null) {
      String fileName = ficheTechnique.path.split(RegExp(r'[/\\]')).last;
      String extension = fileName.split('.').last.toLowerCase();
      String type = (extension == 'pdf') ? 'pdf' : 'image';
      String subtype = (extension == 'pdf') ? 'pdf' : extension;
      if (subtype == 'jpg') subtype = 'jpeg';

      formData.files.add(
        MapEntry(
          'fiche_technique',
          await MultipartFile.fromFile(
            ficheTechnique.path,
            filename: fileName,
            contentType: DioMediaType(type, subtype),
          ),
        ),
      );
    }

    return await Constants.ws.post("stock", formData);
  }

  Future<dynamic> repUpdateProfile(var data, File? image) async {
    if (image != null) {
      String fileName = image.path.split(RegExp(r'[/\\]')).last;
      String extension = fileName.split('.').last.toLowerCase();
      String type = (extension == 'png') ? 'png' : 'jpeg';

      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          image.path,
          filename: fileName,
          contentType: DioMediaType('image', type),
        ),
      });
      if (data is Map<String, dynamic>) {
        data.forEach((key, value) {
          if (key != 'image') {
            formData.fields.add(MapEntry(key, value.toString()));
          }
        });
      }
      return await Constants.ws.post("updateProfile", formData);
    } else {
      return await Constants.ws.post("updateProfile", data);
    }
  }

  Future<dynamic> repStoreFormation(
    var data,
    File? image, {
    File? document,
    Function(int, int)? onSendProgress,
  }) async {
    FormData formData = FormData();

    if (image != null) {
      formData.files.add(
        MapEntry(
          "image",
          await MultipartFile.fromFile(
            image.path,
            filename: 'image.jpg',
            contentType: DioMediaType('image', 'jpeg'),
          ),
        ),
      );
    }

    if (document != null) {
      formData.files.add(
        MapEntry(
          "document",
          await MultipartFile.fromFile(
            document.path,
            filename: document.path.split('/').last,
          ),
        ),
      );
    }

    if (data is Map<String, dynamic>) {
      data.forEach((key, value) {
        if (key != 'image' && key != 'document') {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });
    }
    return await Constants.ws.post(
      "formation",
      formData,
      onSendProgress: onSendProgress,
    );
  }

  Future<dynamic> repUploadFile(
    File file,
    Function(int, int)? onSendProgress,
  ) async {
    FormData formData = FormData();
    formData.files.add(
      MapEntry(
        "file",
        await MultipartFile.fromFile(
          file.path,

          filename: file.path.split('/').last,
        ),
      ),
    );

    return await Constants.ws.post(
      "uploadCourse",
      formData,
      onSendProgress: onSendProgress,
    );
  }

  Future<dynamic> repRemoveFile(var data) async {
    return await Constants.ws.post("removeFile", data);
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

  Future<dynamic> repGetAchats() async {
    return await Constants.ws.get("achat", null);
  }

  Future<dynamic> repAccepteAchat(int id) async {
    return await Constants.ws.get("accepteAchat/$id", null);
  }

  Future<dynamic> repRefuseAchat(int id) async {
    return await Constants.ws.get("refuseAchat/$id", null);
  }

  Future<dynamic> repGetProdByCat(int catId) async {
    return await Constants.ws.get("getproductByCat/$catId", null);
  }

  Future<dynamic> repGetProductsByCategory(int categorieId) async {
    return await Constants.ws.get("products/by-category/$categorieId", null);
  }

  Future<dynamic> repGetStockByProduct(int productId) async {
    return await Constants.ws.get("getstockByProduct/$productId", null);
  }

  Future<dynamic> repAddCategorie(int? id, String title, File? image) async {
    dynamic formData;

    if (image != null) {
      String fileName = image.path.split(RegExp(r'[/\\]')).last;
      String extension = fileName.split('.').last.toLowerCase();

      formData = FormData.fromMap({
        "id": id,
        "title": title,
        "image": await MultipartFile.fromFile(
          image.path,
          filename: fileName,
          contentType: DioMediaType('image', extension),
        ),
      });
    } else {
      formData = {"id": id, "title": title};
    }

    return await Constants.ws.post("categorie", formData);
  }

  Future<dynamic> repAddProduct(var data) async {
    return await Constants.ws.post("product", data);
  }

  Future<dynamic> repStoreAchat(var data, File image) async {
    var formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split(RegExp(r'[/\\]')).last,
        contentType: DioMediaType(
          'image',
          image.path.split('.').last.toLowerCase() == 'png' ? 'png' : 'jpeg',
        ),
      ),
    });
    print("ddddddddddddddddddddddddddddddddate $data");
    if (data is Map<String, dynamic>) {
      data.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });
    }

    return await Constants.ws.post("achat", formData);
  }

  Future<dynamic> repDeleteCategorie(int id) async {
    return await Constants.ws.delete("categorie/$id");
  }

  Future<dynamic> repDeleteProduct(int id) async {
    return await Constants.ws.delete("product/$id");
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

  Future<dynamic> repGetConfiguration() async {
    return await Constants.ws.get("getCcpNumber", null);
  }

  //************************************************ */
}
