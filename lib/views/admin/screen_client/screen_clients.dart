import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/admin/client_controller.dart';
import 'package:rawaa_app/my_widgets/custom_search_bar.dart';
import 'package:rawaa_app/my_widgets/loading.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/admin/screen_client/display_liste.dart';
import 'package:rawaa_app/views/admin/screen_client/display_grid.dart';

class ScreenClients extends StatelessWidget {
  const ScreenClients({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CtrlClient>(
      init: CtrlClient(),
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
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            ),

            title: Text(
              'liste_clients'.tr,
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Column(
              children: [
                customSearchBar(
                  ctrl.searchController,
                  "taper_chercher".tr,
                  () {
                    ctrl.searchController.text = "";
                    ctrl.filterClient(ctrl.searchController.text);
                  },
                  (v) {
                    ctrl.filterClient(v);
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
                  child: ctrl.listeFilterClietns.isEmpty
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
