import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/views/client/screen_chat.dart';

import 'package:rawaa_app/views/client/screen_cart.dart';
import 'package:rawaa_app/views/client/screen_order.dart';
import 'package:rawaa_app/views/settings/screen_settings.dart';

class DashDriverController extends GetxController {
  int indexPage = 0;
  Widget page = ScreenOrder();

  void changePage(int index) {
    indexPage = index;
    switch (index) {
      case 0:
        page = ScreenOrder();
        break;
      case 1:
        page = ScreenCart();
        break;
      case 2:
        page = ChatRoom();
        break;
      case 3:
        page = ScreenSettings();
        break;
      case 4:
        page = ScreenSettings();
        break;
      default:
        page = Container();
        break;
    }
    update();
  }
}
