// lib/models/message.dart
import 'package:rawaa_app/model/muser.dart';

class Message1 {
  final int id;
  final String message;
  final Muser user;
  final DateTime createdAt;

  Message1({
    required this.id,
    required this.message,
    required this.user,
    required this.createdAt,
  });

  factory Message1.fromJson(Map<String, dynamic> json) {
    return Message1(
      id: json['id'],
      message: json['message'],
      user: Muser.fromJson(json['user']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
