import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/welcome_controller.dart';
import 'package:rawaa_app/views/admin/screen_formation.dart';
import 'package:rawaa_app/views/chat/screen_chat.dart';

import 'package:rawaa_app/views/client/screen_cart.dart';
import 'package:rawaa_app/views/client/screen_chat.dart';
import 'package:rawaa_app/views/client/screen_order.dart';
import 'package:rawaa_app/views/client/welcome.dart';
import 'package:rawaa_app/views/settings/screen_settings.dart';

class DashClientController extends GetxController {
  int indexPage = 0;
  Widget page = ScreenWelcomClient();

  void changePage(int index) {
    indexPage = index;
    switch (index) {
      case 0:
        page = ScreenWelcomClient();
        break;
      case 1:
        page = ScreenCart();
        break;
      case 2:
        page = ScreenOrder();
        break;
      case 3:
        page = ScreenFormation();
        break;

      case 4:
        page = ChatRoom();
        break;
      case 5:
        page = ScreenSettings();
        break;
      default:
        page = Container();
        break;
    }
    update();
  }
}
