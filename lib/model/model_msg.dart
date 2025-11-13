import 'package:rawaa_app/styles/constants.dart';

class MMessage {
  late int id;
  late String content;
  late int senderId;
  late int receiverId;
  late DateTime time;

  late bool isMe;
  MMessage({
    required this.id,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.time,
    this.isMe = false,
  });

  MMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['message'];
    senderId = json['id_sender'];
    receiverId = json['id_receiver'];
    time = DateTime.parse(json['time_sending']);

    isMe = senderId.toString() == Constants.currentUser!.id ? true : false;
  }
}
