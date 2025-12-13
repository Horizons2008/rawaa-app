import 'package:flutter/material.dart';

class MFormation {
  int id;
  String title;
  String description;
  String? imageUrl;
  double price;
  bool isOnline;
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? instructor;
  Duration? duration;
  String dejaAcheter;
  List<String> playlist;

  // Constructor

  MFormation({
    required this.id,
    required this.title,
    required this.description,
    required this.playlist,
    this.imageUrl,
    this.duration,
    required this.price,
    required this.isOnline,
    this.date,
    required this.dejaAcheter,

    this.startTime,
    this.endTime,
    this.instructor,
  });

  // Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'isOnline': isOnline,
      'date': date?.millisecondsSinceEpoch,
      'startTime': startTime != null
          ? '${startTime!.hour}:${startTime!.minute}'
          : null,
      'endTime': endTime != null ? '${endTime!.hour}:${endTime!.minute}' : null,
      'instructor': instructor,
    };
  }

  // Create from map
  factory MFormation.fromMap(Map<String, dynamic> map) {
    return MFormation(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      price: double.parse(map['price']),
      isOnline: map['is_online'] ?? true,
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      startTime: map['time_start'] != null
          ? parseTime(map['time_start'])
          : null,
      endTime: map['time_end'] != null ? parseTime(map['time_end']) : null,
      instructor: map['file_path'].split(',')[0], // map['prof_name'],
      duration: map['duration'] != null ? parseDuration(map['duration']) : null,
      dejaAcheter:
          ((map['achats'] != null) && (map['achats'] as List).isNotEmpty)
          ? map['achats'][0]['status']
          : "Acheter",
      playlist: map['file_path'] != null ? map['file_path'].split(',') : [],
    );
  }

  static TimeOfDay parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static Duration parseDuration(String timeString) {
    final parts = timeString.split(':');
    return Duration(hours: int.parse(parts[0]), minutes: int.parse(parts[1]));
  }
}
