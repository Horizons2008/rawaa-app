import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:rawaa_app/styles/constants.dart';

class Intercepteur extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String token = Constants.currentUser?.token ?? "12";

    options.headers["Authorization"] = "Bearer $token";

    /*  int typeRequest = 1;
typeRequest == 1
        ? options.headers["Content-Type"] = "multipart/form-data"
        : options.headers["Content-Type"] = "application/json";*/

    if (options.data is FormData) {
      options.headers["Content-Type"] = "multipart/form-data";
    } else {
      options.headers["Content-Type"] = "application/json";
    }

    options.headers["Accept"] = "application/json";

    print("option header ${options.headers}");
    print("option data ${options.data}");

    // TODO: implement onRequest
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
    print("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrresponse ${response.data}");
  }

  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      print('  Response Headers: ${err.response!.headers}');
      print('  Response Data: ${err.response!.data}');
    }

    if (err.error is SocketException) {
      print('  Socket Exception: ${err.error}');
    }
    print("error1111111111111111111111111111111 ${err}");
    if (err.response?.statusCode == 404 &&
        err.response?.data != null &&
        err.response?.data["status"] != null) {
      // Handle 404 with data in error interceptor
      // You can modify the error or create a custom response
      final response = err.response!;
      handler.resolve(response); // This will treat it as a successful response
    } else {
      handler.next(err);
    }
  }
}
