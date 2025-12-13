import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/views/chat/screen_chat.dart';
import 'package:rawaa_app/views/client/screen_order.dart';
import 'package:rawaa_app/views/client/screen_chat.dart';
import 'package:rawaa_app/views/settings/screen_settings.dart';
import 'package:rawaa_app/views/vendeur/my_stock.dart';

class DashVendeurController extends GetxController {
  int indexPage = 0;
  Widget page = MyStock();

  changePage(int index) {
    indexPage = index;
    switch (indexPage) {
      case 0:
        page = MyStock();
        break;
      case 1:
        page = ScreenOrder();

        break;
      case 2:
        page = ChatRoom();
        break;
      case 3:
        page = ScreenSettings();
        break;

      default:
    }
    update();
  }
}
