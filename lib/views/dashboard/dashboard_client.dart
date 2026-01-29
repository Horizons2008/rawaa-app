import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rawaa_app/controller/dash_client_controller.dart';

class DashboardClient extends StatelessWidget {
  const DashboardClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<DashClientController>(
          init: DashClientController(),
          builder: (ctrl) {
            return ctrl.page;
          },
        ),
        bottomNavigationBar: GetBuilder<DashClientController>(
          init: DashClientController(),
          builder: (ctrl) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: Colors.green,
                unselectedItemColor: Colors.black,
                currentIndex: ctrl.indexPage,
                onTap: (int index) {
                  ctrl.changePage(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'home'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_basket_rounded),
                    label: 'panier'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_bag),
                    label: 'orders'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.school),
                    label: 'cours'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.message),
                    label: 'messages'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'settings'.tr,
                  ),
                ],
              ),
            );
          },
        ),
      
    );
  }
}
