import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:rawaa_app/controller/controller_product.dart';
import 'package:rawaa_app/model/model_categorie.dart';
import 'package:rawaa_app/my_widgets/custom_text.dart';
import 'package:rawaa_app/my_widgets/error_restful.dart';
import 'package:rawaa_app/my_widgets/liste_vide.dart';
import 'package:rawaa_app/my_widgets/loading.dart';
import 'package:rawaa_app/my_widgets/outlined_edit.dart';

import 'package:rawaa_app/styles/constants.dart';
import 'dart:io';

import 'package:rawaa_app/views/products/add_product.dart';

class ScreenProduct extends StatelessWidget {
  const ScreenProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            AddProduct(selectedPRoduct: null),
            isScrollControlled: true,
          );
        },

        backgroundColor: Constants.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),

        child: GetBuilder<ControllerProducts>(
          builder: (ctrl) {
            return AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: ctrl.isSearching == true
                  ? Colors.white
                  : Constants.primaryColor,
              title: ctrl.isSearching == true
                  ? OutlinedEdit(
                      onChange: (value) {
                        ctrl.filterProduct(value);
                      },
                      controller: ctrl.searchController,
                      iconGauche: IconButton(
                        onPressed: () {
                          print(ctrl.searchController.text);
                          ctrl.searchController.text.isNotEmpty
                              ? {ctrl.searchController.text = ""}
                              : ctrl.isSearching = false;
                          ctrl.update();
                        },
                        icon: Icon(Icons.arrow_back),
                      ),

                      iconDroite: ctrl.searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                ctrl.searchController.text = "";
                                ctrl.update();
                              },
                              icon: Icon(Icons.close),
                            )
                          : SizedBox(),
                    )
                  : CustomText(
                      text: "product".tr,
                      coul: Colors.white,
                      size: 20,
                      weight: FontWeight.bold,
                    ),

              actions: [
                ctrl.isSearching == true
                    ? SizedBox()
                    : IconButton(
                        onPressed: () {
                          ctrl.isSearching = true;
                          ctrl.update();
                        },
                        icon: Icon(Icons.search, size: 25, color: Colors.white),
                      ),
              ],
            );
          },
        ),
      ),
      body: SafeArea(
        child: GetBuilder<ControllerProducts>(
          init: ControllerProducts(),
          builder: (ctrl) {
            return ctrl.status == ListeStatus.loading
                ? WidgetLoading()
                : ctrl.status == ListeStatus.error
                ? WidgetError()
                : ctrl.status == ListeStatus.success
                ? ctrl.listFiltred.isEmpty
                      ? ListeVide()
                      : ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: ctrl.listFiltred.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                title: Text(
                                  ctrl.listFiltred[index].title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: CustomText(
                                  text: ctrl.listFiltred[index].categorieTitle,
                                  size: 16,
                                  weight: FontWeight.w600,
                                  coul: Colors.grey,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        MCat cat = ctrl.listCat.firstWhere(
                                          (element) =>
                                              element.id ==
                                              ctrl
                                                  .listFiltred[index]
                                                  .categorieId,
                                        );
                                        ctrl.selectedCat = cat;
                                        ctrl.arabicController.text =
                                            Constants.getTitle(
                                              ctrl.listFiltred[index].title,
                                              'ar',
                                            );
                                        ctrl.frenchController.text =
                                            Constants.getTitle(
                                              ctrl.listFiltred[index].title,
                                              'fr',
                                            );
                                        ctrl.englishController.text =
                                            Constants.getTitle(
                                              ctrl.listFiltred[index].title,
                                              'en',
                                            );
                                        ctrl.update();

                                        Get.bottomSheet(
                                          AddProduct(
                                            selectedPRoduct:
                                                ctrl.listFiltred[index],
                                          ),
                                          isScrollControlled: true,
                                        );
                                      },
                                    ),

                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Confirm Deletion'),
                                            content: Text(
                                              'Are you sure you want to delete this category?',
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text('Cancel'),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              ),
                                              TextButton(
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  ctrl.deleteCategory(
                                                    ctrl.listCat[index].id,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                        return;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                : Container();
          },
        ),
      ),
    );
  }
}
