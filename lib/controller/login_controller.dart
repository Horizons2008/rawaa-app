import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/dashboard/dashboard.dart';

class CtrlLogin extends GetxController {
  TextEditingController contUsername = TextEditingController(text: ("admin"));
  TextEditingController contpassword = TextEditingController(text: "password");
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  String? errorLogin;
  bool showPassword = true;
  ListeStatus status = ListeStatus.none;

  switchPassword() {
    showPassword = !showPassword;
    update();
  }

  Future<void> checkLogin() async {
    errorLogin = null;
    if (loginKey.currentState!.validate()) {
      status = ListeStatus.loading;
      update();
      //  await Future.delayed(const Duration(seconds: 1));

      await Constants.reposit
          .checkLogin(contUsername.text, contpassword.text)
          .then((val) {
            print("--------------------------- val : $val");
            if (val["status"] == "SUCCESS") {
              status = ListeStatus.success;
              errorLogin = null;
              Hive.box(Constants.boxConfig).put("logged", true);
              Firebase.initializeApp();
              FirebaseMessaging.instance.getToken().then((newToken) {
                newToken != null
                    ? Constants.reposit.repUpdateFcmToken(newToken).then((
                        value,
                      ) {
                        debugPrint("8888 $value");
                      })
                    : null;
              });

              Hive.box(Constants.boxConfig).put("current_user", val);

              Get.offAll(() => ScreenDashboard());
            } else if (val["status"] == "NOT_FOUND") {
              status = ListeStatus.error;
              errorLogin = "Compte introuvable";
            } else if (val["status"] == "Bloque") {
              status = ListeStatus.error;
              errorLogin = "Compte Bloqué";
            } else if (val["status"] == "INVALID_CREDENTIALS") {
              status = ListeStatus.error;
              errorLogin = "IDENTIFIANTS INVALIDES";
            } else if (val["status"] == "ERROR") {
              status = ListeStatus.error;
              errorLogin = val["error"];
            }
            update();
          })
          .catchError((err) {});
      /* else {
        errorLogin = "Compte introuvable";
      }*/
    }
    update();
  }
}
