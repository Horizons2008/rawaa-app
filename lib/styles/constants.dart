import 'dart:convert';

import 'package:rawaa_app/model/muser.dart';

import 'package:rawaa_app/my_widgets/custom_text.dart';

import 'package:rawaa_app/restful/repository.dart';
import 'package:rawaa_app/restful/web_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

// enum StatusAttente {attente,consulte,annule}
enum ListeStatus { none, success, loading, error }

enum ReceptionStatus { initial, processing, received }

abstract class Constants {
  static final String boxConfig = "piscine_boxConfig";
  static final String boxUser = "piscine_boxUsers";
  static final Box boxUsers = Hive.box(boxUser);
  static Muser? currentUser;
  static String profileImageVer = "";

  static final String boxHoraire = "piscine_boxHoraire";
  static final Box boxHoraires = Hive.box(boxHoraire);

  static final String boxStudent = "piscine_boxstudent";
  static final Box boxStudents = Hive.box(boxStudent);

  static final String boxAttente = "cabinet_box_attente";
  static final Box boxAttentes = Hive.box(boxAttente);
  static final String boxRecette = "cabinet_box_recette";
  static final Box boxRecettes = Hive.box(boxRecette);
  static final Box boxCart = Hive.box('myCart');

  static Color primaryColor = Colors.green;
  static String lang = "fr";

  Color secondaryColor = Colors.green.shade400;

  // static final String baseUrl = "http://10.28.163.177:8000";
  // static final String photoUrl = "http://10.28.163.177:8000/storage/";
  static final String baseUrl = "https://rawaa-dz.com";
  static final String photoUrl = "https://rawaa-dz.com/storage/";

  static final String prefixe = "api";
  static WebService ws = WebService();
  static Repository reposit = Repository(ws);
  static String boxPackaging = "boxPackaging";

  static String currency(var price) {
    // INSERT_YOUR_CODE
    if (price is int) {
      return "$price.00${'symbol'.tr}";
    } else if (price is double) {
      return price.toStringAsFixed(2) + "symbol".tr;
    } else if (price is String) {
      int? intPrice = int.tryParse(price);
      if (intPrice != null) {
        return "$intPrice.00{'symbol'.tr}";
      }
    }
    return "$price";
  }

  static Color getStatusColor(dynamic status) {
    if (status is int) {
      switch (status) {
        case 2:
          return Colors.red;
        case 0:
          return Colors.orange;
        case 1:
          return Colors.green;
        default:
          return Colors.grey;
      }
    } else if (status is String) {
      switch (status) {
        case "confirmed":
          return Colors.green;
        case "waitting":
          return Colors.orange;
        default:
          return Colors.amber;
      }
    } else {
      return Colors.grey;
    }
  }

  static String getStatusLabel(dynamic status) {
    if (status is int) {
      switch (status) {
        case 0:
          return "attente".tr;
        case 1:
          return "accepted".tr;
        case 2:
          return "rejected".tr;
        default:
          status.toString();
      }
    } else if (status is String) {
      switch (status) {
        case "confirmed":
          return "confirmed".tr;
        case "waiting":
          return "attente".tr;
        default:
          return status;
      }
    }
    return "inconnue";
  }

  static void showSnackBar(String? title, String msg) {
    Get.rawSnackbar(
      borderRadius: 20,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      titleText: null,
      backgroundColor: Colors.black,
      messageText: Container(
        decoration: BoxDecoration(),
        alignment: Alignment.center,
        child: CustomText(
          text: msg,
          size: 14,
          weight: FontWeight.w400,
          coul: Colors.white,
        ),
      ),
    );
  }

  static String getTitle(String title, String lang) {
    try {
      final Map<String, dynamic> jsonMap = json.decode(title);
      switch (lang) {
        case "fr":
          return jsonMap['fr'];

        case "en":
          return jsonMap['en'];

        case "ar":
          return jsonMap['ar'];

        default:
          return jsonMap[Constants.lang];
      }
    } catch (e) {
      return "title";
    }
  }
}
