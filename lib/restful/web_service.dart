import 'package:dio/dio.dart';

import 'package:rawaa_app/restful/dioException.dart';
import 'package:rawaa_app/restful/intercepeur.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:flutter/material.dart';

class WebService {
  late Dio dio;

  WebService() {
    dio = Dio();

    dio.interceptors.add(Intercepteur());
  }

  //********************************************************** */
  wsPing() async {
    String url = "${Constants.baseUrl}ping";
    Response response = await dio.get(url);
    return response.data;
  }

  //************************************************************ */

  wsRestoreData() async {
    String url = "${Constants.baseUrl}getAllData";

    try {
      Response response = await dio.post(url, data: {});
      print("responde data ${response.data}");
      return response.data;
    } on DioException catch (e) {
      print("error11 ${DioExceptions.fromDioError(e).message} ");
      return (<String, String>{"error": DioExceptions.fromDioError(e).message});
    }
  }

  //************************************************************* */
  post(String endPoint, dynamic data) async {
    String url = "${Constants.baseUrl}/${Constants.prefixe}/$endPoint";
    print("*********************************url $url");
    try {
      Response response = await dio.post(url, data: data);
      // print("responde data ${response.data}");
      return response.data;
    } on DioException catch (e) {
      print("error catch webservice ${DioExceptions.fromDioError(e).message}");
      return (<String, String>{
        "status": "ERROR",
        "error": DioExceptions.fromDioError(e).message,
      });
    }
  }

  //************************************************************* */
  get(String endPoint, dynamic data) async {
    try {
      String url = "${Constants.baseUrl}/${Constants.prefixe}/${endPoint}";
      // url = "https://md.tassiliweb.com/api/checkLogin";
      // url = "https://ful.youchaa.com/api/V1/login";
      print("uuuuuuuuuuuuuuuuuu $url");

      Response response = await dio.get(url, data: data);
      // print("ttttttttttttttttt ${response.data}");

      return response.data;

      //return response.data;
    } on DioException catch (e) {
      debugPrint("catch web servicie ${DioExceptions.fromDioError(e).message}");
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
        print('Response status: ${e.response?.statusCode}');
        print('Response headers: ${e.response?.headers}');
      }
      return (<String, String>{
        "status": "ERROR",
        "error": DioExceptions.fromDioError(e).message,
      });
    }
  }
  //************************************************************ */

  Future wsLogin(String username, String password) async {
    String url = "https://ful.youchaa.com/api/V1/login/";
    // String url = "https://md.tassiliweb.com/api/ping";
    //String url = "${Constants.baseUrl}/${Constants.prefixe}/login";
    print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuurl2 $url");
    print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuurl2 $username");
    print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuurl2 password");

    try {
      Response response = await dio.get(
        url,
        data: {"username": "username", "password": "password"},
      );

      print(response.data);

      //return response.data;
    } on DioException catch (e) {
      print(e.response?.data); // This shows what the server actually returned
      print(e.response?.statusCode);
      print(e.response?.headers);
      return (<String, String>{"error": DioExceptions.fromDioError(e).message});
    }
  }
}
