import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:rawaa_app/model/muser.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/dashboard/dashboard_admin.dart';
import 'package:rawaa_app/views/dashboard/dashboard_client.dart';
import 'package:rawaa_app/views/dashboard/dashboard_vendeur.dart';
import 'package:rawaa_app/views/login/screen_login.dart';

class ContSplash extends GetxController {
  bool firstRun = false;
  //Box box = Hive.box(Constants.boxUser);
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 1), () async {
      // int x = box.values.toList().length;

      //firstRun = Hive.box(Constants.boxConfig).get("firstRun") ?? false;
      /*  if (x == 0) {
        box.add(MUser(
            password: "admin",
            role: "A",
            status: "active",
            uploaded: false,
            username: "admin"));
        // Hive.box(Constants.boxConfig).put("firstRun", true);
        x = Hive.box<MUser>(Constants.boxUser).values.toList().length;

        Get.offAll(() => ScreenLogin());
      } else*/
      {
        bool logged = Hive.box(Constants.boxConfig).get("logged") ?? false;

        if (logged) {
          //  await Constants.reposit.repRestoreAllData1();
          var rr = await Hive.box(
            Constants.boxConfig,
          ).get("current_user")['user'];
          String tok =
              await Hive.box(
                Constants.boxConfig,
              ).get("current_user")['access_token'] ??
              "ttookkeenn";
          Constants.currentUser = Muser(
            id: rr['id'].toString(),
            name: rr['name'],
            role: rr['role'],
            username: rr['username'],
            token: tok,
          );
          switch (Constants.currentUser!.role) {
            case 'admin':
              Get.offAll(() => DashboardAdmin());
              break;
            case 'client':
              Get.offAll(() => DashboardClient());
              break;
            case 'vendeur':
              Get.offAll(() => DashboardVendeur());
              break;
            case 'livreur':
              Get.offAll(() => DashboardAdmin());
              break;
          }
        } else {
          Get.offAll(() => ScreenLogin());
        }
      }
    });
  }
}
