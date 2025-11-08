import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/utils.dart';
import 'package:rawaa_app/controller/dash_vendeur_controller.dart';

class DashboardVendeur extends StatelessWidget {
  const DashboardVendeur({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<DashVendeurController>(
        init: DashVendeurController(),
        builder: (ctrl) {
          return ctrl.page;
        },
      ),
      bottomNavigationBar: GetBuilder<DashVendeurController>(
        builder: (ctrl) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Catégories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket),
                label: 'Commande',
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
