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
  static late MUser currentUser;

  static final String boxHoraire = "piscine_boxHoraire";
  static final Box boxHoraires = Hive.box(boxHoraire);

  static final String boxStudent = "piscine_boxstudent";
  static final Box boxStudents = Hive.box(boxStudent);

  static final String boxAttente = "cabinet_box_attente";
  static final Box boxAttentes = Hive.box(boxAttente);
  static final String boxRecette = "cabinet_box_recette";
  static final Box boxRecettes = Hive.box(boxRecette);
  static Color primaryColor = Colors.green;
  static String lang = "fr";

  Color secondaryColor = Colors.green.shade400;

  static final String baseUrl = "http://192.168.1.8:8000";
  //static final String baseUrl = "https://app.rawaa_app.net";
  static final String prefixe = "api";
  static WebService ws = WebService();
  static Repository reposit = Repository(ws);
  static String boxPackaging = "boxPackaging";

  static Color getStatusColor(ReceptionStatus status) {
    switch (status) {
      case ReceptionStatus.initial:
        return Colors.red;
      case ReceptionStatus.processing:
        return Colors.orange;
      case ReceptionStatus.received:
        return Colors.green;
    }
  }

  static String getStatusLabel(ReceptionStatus status) {
    switch (status) {
      case ReceptionStatus.initial:
        return "En attente";
      case ReceptionStatus.processing:
        return "En cours";
      case ReceptionStatus.received:
        return "Terminer";
    }
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
}
