import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/views/client/welcome.dart';
import 'package:rawaa_app/views/settings/screen_settings.dart';

class DashClientController extends GetxController {
  int indexPage = 0;
  Widget page = Container();

  void changePage(int index) {
    indexPage = index;
    switch (index) {
      case 0:
        page = ScreenWelcomClient();
        break;
      case 1:
        page = Center(child: Text("Page 2 Client"));
        break;
      case 2:
        page = Center(child: Text("Page 3 Client"));
        break;
      case 3:
        page = ScreenSettings();
        break;
      default:
        page = Container();
        break;
    }
    update();
  }
}
