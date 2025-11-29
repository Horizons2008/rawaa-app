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
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket_rounded),
                label: 'Pannier',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Commande',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cast_for_education),
                label: 'Formation',
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Messagerie',
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
