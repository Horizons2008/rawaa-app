import 'package:get/get.dart';


class CtrlDashboard extends GetxController {
  bool collapsed = false;
  double drawerWidth = 80;
  int currentPage = 0;
  int indexHover = -1;
  
  void collapse() {
    collapsed = !collapsed;
    collapsed == true ? drawerWidth = 300 : drawerWidth = 80;
    update();
  }

 
  
}
