import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/model/model_client.dart';
import 'package:rawaa_app/styles/constants.dart';

class CtrlVendeur extends GetxController {
  ListeStatus status = ListeStatus.none;
  bool displayMode = false;
  List<MClient> listeVendeurs = [];
  List<MClient> listeFilterVendeur = [];
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getListeVendeurs();
  }

  filterVendeur(String word) {
    print("11111111111 $status");
    if (word.isEmpty) {
      listeFilterVendeur = List.from(listeVendeurs);
    } else {
      listeFilterVendeur = List.from(
        listeVendeurs
            .where(
              (element) =>
                  element.username.toLowerCase().contains(word.toLowerCase()),
            )
            .toList(),
      );
    }
    update();
  }

  getListeVendeurs() async {
    status = ListeStatus.loading;
    update();
    // await Future.delayed(const Duration(seconds: 2));
    await Constants.reposit.repGetVendeur().then((value) {
      print(value);
      listeVendeurs = value['data']
          .map<MClient>((e) => MClient.fromJson(e))
          .toList();
      listeFilterVendeur = List.from(listeVendeurs);
      status = ListeStatus.success;

      update();
    });

    update();
  }
}
