import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/model/model_contact.dart';
import 'package:rawaa_app/model/model_message.dart';
import 'package:rawaa_app/model/model_msg.dart';
import 'package:rawaa_app/styles/constants.dart';

class ChatController extends GetxController {
  List<MContact> listeContact = [];
  TextEditingController TecMessage = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<MMessage> listeMessage = [];
  MContact? selectedContact;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchUser();
  }

  Future fetchUser() async {
    await Constants.reposit.repGetAllUser().then((value) {
      listeContact = value['data']
          .map<MContact>((e) => MContact.fromJson(e))
          .toList();
      update();
    });
  }

  storeMsg() async {
    Map<String, String> data = {
      'message': TecMessage.text,
      'id_receiver': selectedContact!.id.toString(),
    };
    await Constants.reposit.repStoreMsg(data).then((value) {
      TecMessage.clear();
      update();
      fetchMsg();
    });
  }

  setSelectedContact(MContact contact) {
    selectedContact = contact;
    fetchMsg();
    update();
  }

  fetchMsg() async {
    await Constants.reposit.repGetMsg(selectedContact!.id).then((value) {
      listeMessage = value['data']
          .map<MMessage>((e) => MMessage.fromJson(e))
          .toList();

      update();
    });
  }
}
