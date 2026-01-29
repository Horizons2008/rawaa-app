import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/model/model_contact.dart';
import 'package:rawaa_app/model/model_msg.dart';
import 'package:rawaa_app/styles/constants.dart';

class ChatController extends GetxController {
  List<MContact> listeContact = [];
  TextEditingController TecMessage = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<MMessage> listeMessage = [];
  List<MMessage> listeRecent = [];

  MContact? selectedContact;
  @override
  void onInit() {
    super.onInit();
    fetchUser();
    getRecent();
  }

  Future fetchUser() async {
    await Constants.reposit.repGetAllUser().then((value) {
      listeContact = value['data']
          .map<MContact>((e) => MContact.fromJson(e))
          .toList();
      update();
    });
  }

  getRecent() async {
    await Constants.reposit.repGetRecentMsg().then((value) {
      listeRecent = value['data']
          .map<MMessage>((e) => MMessage.fromJson(e))
          .toList();

      // Sort by time_sending (hour, minute, second) - ascending order (oldest first)
      listeRecent.sort((a, b) => a.time.compareTo(b.time));

      update();
    });
  }

  String getName(MMessage item) {
    int id = item.receiverId.toString() == Constants.currentUser!.id
        ? item.senderId
        : item.receiverId;
    MContact contact = listeContact.firstWhere((element) => element.id == id);
    return contact.name;
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
      getRecent();
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

      // Sort by time_sending (hour, minute, second) - ascending order (oldest first)
      listeMessage.sort((a, b) => a.time.compareTo(b.time));

      update();
    });
  }
}
