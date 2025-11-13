import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/controller_categories.dart';
import 'package:rawaa_app/my_widgets/custom_text.dart';
import 'package:rawaa_app/my_widgets/error_restful.dart';
import 'package:rawaa_app/my_widgets/liste_vide.dart';
import 'package:rawaa_app/my_widgets/loading.dart';
import 'package:rawaa_app/my_widgets/outlined_edit.dart';

import 'package:rawaa_app/styles/constants.dart';
import 'dart:io';

import 'package:rawaa_app/views/categories/add_categorie.dart';

class ScreenCategorie extends StatelessWidget {
  const ScreenCategorie({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            AddCategorie(selectedCat: null),
            isScrollControlled: true,
          );
        },

        backgroundColor: Constants.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),

        child: GetBuilder<ControllerCategories>(
          builder: (ctrl) {
            return AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: ctrl.isSearching == true
                  ? Colors.white
                  : Constants.primaryColor,
              title: ctrl.isSearching == true
                  ? OutlinedEdit(
                      onChange: (value) {
                        ctrl.filterCategories(value);
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
                      text: "Categories".tr,
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
        child: GetBuilder<ControllerCategories>(
          init: ControllerCategories(),
          builder: (ctrl) {
            return ctrl.status == ListeStatus.loading
                ? WidgetLoading()
                : ctrl.status == ListeStatus.error
                ? WidgetError()
                : ctrl.status == ListeStatus.success
                ? ctrl.listFilted.isEmpty
                      ? ListeVide()
                      : ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: ctrl.listFilted.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                leading: ClipOval(
                                  child: Image.network(
                                    "${Constants.photoUrl}categorie/${ctrl.listFilted[index].id}.jpg",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Constants.primaryColor
                                              .withValues(alpha: 0.2),
                                        ),
                                        child: Center(
                                          child: CustomText(
                                            text: Constants.getTitle(
                                              ctrl.listFilted[index].title,
                                              Constants.lang,
                                            )[0],

                                            size: 20,
                                            weight: FontWeight.w500,
                                            coul: Constants.primaryColor,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                title: Text(
                                  Constants.getTitle(
                                    ctrl.listFilted[index].title,
                                    Constants.lang,
                                  ),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        ctrl.arabicController.text =
                                            Constants.getTitle(
                                              ctrl.listFilted[index].title,
                                              "ar",
                                            );
                                        ctrl.englishController.text =
                                            Constants.getTitle(
                                              ctrl.listFilted[index].title,
                                              "en",
                                            );
                                        ctrl.frenchController.text =
                                            Constants.getTitle(
                                              ctrl.listFilted[index].title,
                                              "fr",
                                            );

                                        Get.bottomSheet(
                                          AddCategorie(
                                            selectedCat: ctrl.listFilted[index],
                                          ),
                                          isScrollControlled: true,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      tooltip: 'add_new_category'.tr,
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
                                                    ctrl.listFilted[index].id,
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
