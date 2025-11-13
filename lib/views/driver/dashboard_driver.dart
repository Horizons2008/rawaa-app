import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rawaa_app/controller/dash_client_controller.dart';
import 'package:rawaa_app/controller/dash_driver_controller.dart';

class DashboardDriver extends StatelessWidget {
  const DashboardDriver({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<DashDriverController>(
        init: DashDriverController(),
        builder: (ctrl) {
          return ctrl.page;
        },
      ),
      bottomNavigationBar: GetBuilder<DashDriverController>(
        init: DashDriverController(),
        builder: (ctrl) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Accueil',
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Commande',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Message',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Paramètres',
              ),
            ],
            currentIndex: ctrl
                .indexPage, // You may use a stateful widget/controller to manage this
            onTap: (int index) {
              ctrl.changePage(index);
              // TODO: Implement navigation to respective screens
            },
          );
        },
      ),
    );
  }
}
