import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/admin/vendeur_controller.dart';
import 'package:rawaa_app/my_widgets/custom_search_bar.dart';
import 'package:rawaa_app/my_widgets/loading.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/admin/screen_vendeur/display_liste.dart';
import 'package:rawaa_app/views/admin/screen_vendeur/display_grid.dart';

class ScreenVendeurs extends StatelessWidget {
  const ScreenVendeurs({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CtrlVendeur>(
      init: CtrlVendeur(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Constants.primaryColor,
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            title: Text(
              'liste_vendeurs'.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                customSearchBar(
                  ctrl.searchController,
                  "taper_chercher".tr,
                  () {
                    ctrl.searchController.text = "";
                    ctrl.filterVendeur(ctrl.searchController.text);
                  },
                  (v) {
                    ctrl.filterVendeur(v);
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      ctrl.displayMode = !ctrl.displayMode;
                      ctrl.update();
                    },
                    icon: Icon(
                      ctrl.displayMode == false
                          ? Icons.list
                          : Icons.grid_view_outlined,
                    ),
                  ),
                ),
                Expanded(
                  child: ctrl.listeFilterVendeur.isEmpty
                      ? const WidgetLoading()
                      : ctrl.displayMode == false
                      ? const DisplayListe()
                      : const DisplayGrid(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
