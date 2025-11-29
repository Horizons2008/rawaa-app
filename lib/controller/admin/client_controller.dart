import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/model/model_client.dart';
import 'package:rawaa_app/styles/constants.dart';

class CtrlClient extends GetxController {
  ListeStatus status = ListeStatus.none;
  bool displayMode = false;
  List<MClient> listeClietns = [];
  List<MClient> listeFilterClietns = [];
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getListeClients();
  }

  filterClient(String word) {
    if (word.isEmpty) {
      listeFilterClietns = List.from(listeClietns);
    } else {
      listeFilterClietns = List.from(
        listeClietns
            .where(
              (element) =>
                  element.username.toLowerCase().contains(word.toLowerCase()),
            )
            .toList(),
      );
    }
    update();
  }

  getListeClients() async {
    status = ListeStatus.loading;
    update();
    // await Future.delayed(const Duration(seconds: 2));
    await Constants.reposit.repGetClient().then((value) {
      print(value);
      listeClietns = value['data']
          .map<MClient>((e) => MClient.fromJson(e))
          .toList();
      listeFilterClietns = List.from(listeClietns);
      status = ListeStatus.success;
      update();
    });

    update();
  }
}
