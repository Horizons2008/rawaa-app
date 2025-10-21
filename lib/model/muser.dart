import 'package:hive/hive.dart';


part 'muser.g.dart';

@HiveType(typeId: 1)
class MUser extends HiveObject {
  @HiveField(0)
  int position;

  @HiveField(1)
  String username;
  @HiveField(2)
  String password;

  @HiveField(3)
  String role;

  @HiveField(4)
  String status;
  @HiveField(5)
  bool uploaded;
  @HiveField(6)
  int updatetAt;
  @HiveField(7)
  int userId;
  @HiveField(8)
  MUser({
    required this.password,
    required this.role,
    required this.status,
    required this.uploaded,
    required this.username,
    required this.updatetAt,
    required this.userId,
    required this.position,
  });
}
