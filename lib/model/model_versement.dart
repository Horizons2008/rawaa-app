class MVersement {
  late final int id;
  late final int studentId;
  late final double montant;
  late final VersementStatus status;
  late final DateTime dateStart;
  late final int duration; // day_count

  MVersement({
    required this.id,
    required this.studentId,
    required this.montant,
    required this.status,
    required this.dateStart,
    required this.duration,
  });

  // Create from JSON
  MVersement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    montant = json['montant'] is int
        ? json['montant'] * 1.0
        : json['montant'] is String
            ? double.parse(json['montant'])
            : json['montant'];
    status = _parseStatus(json['status']);
    dateStart = DateTime.parse(json['date_start']);
    duration = json['duration'] is String
        ? int.parse(json['duration'])
        : json['duration'];
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'montant': montant,
      'status': _statusToString(status),
      'date_start': dateStart.toIso8601String(),
      'duration': duration,
    };
  }

  // Parse status from string to enum
  VersementStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'waiting':
        return VersementStatus.waiting;
      case 'confirmed':
        return VersementStatus.confirmed;
      case 'rejected':
        return VersementStatus.rejected;
      default:
        return VersementStatus.waiting;
    }
  }

  // Convert enum to string
  String _statusToString(VersementStatus status) {
    switch (status) {
      case VersementStatus.waiting:
        return 'waiting';
      case VersementStatus.confirmed:
        return 'confirmed';
      case VersementStatus.rejected:
        return 'rejected';
    }
  }
}

enum VersementStatus {
  waiting,
  confirmed,
  rejected,
}

