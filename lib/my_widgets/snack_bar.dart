import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar(String msg) {
  Get.snackbar(
    "",
    msg,
    colorText: Colors.white,
    backgroundColor: Colors.black,
    borderRadius: 15,
    snackPosition: SnackPosition.BOTTOM,
    margin: EdgeInsets.all(3),
    duration: Duration(milliseconds: 500),
  );
}
