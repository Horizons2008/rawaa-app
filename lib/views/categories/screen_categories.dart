import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/controller_categories.dart';
import 'package:rawaa_app/my_widgets/custom_search_bar.dart';
import 'package:rawaa_app/my_widgets/custom_text.dart';
import 'package:rawaa_app/my_widgets/error_restful.dart';
import 'package:rawaa_app/my_widgets/liste_vide.dart';
import 'package:rawaa_app/my_widgets/loading.dart';
import 'package:rawaa_app/my_widgets/outlined_edit.dart';

import 'package:rawaa_app/styles/constants.dart';
import 'dart:io';

import 'package:rawaa_app/views/categories/add_categorie.dart';

class ScreenCategorie extends StatefulWidget {
  const ScreenCategorie({super.key});

  @override
  State<ScreenCategorie> createState() => _ScreenCategorieState();
}

class _ScreenCategorieState extends State<ScreenCategorie> {
  // true = Grid view, false = Horizontal list view
  bool _isGrid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: GetBuilder<ControllerCategories>(
          builder: (ctrl) {
            return AppBar(
              backgroundColor: Constants.primaryColor,
              title: CustomText(
                text: "categories".tr,
                coul: Colors.white,
                size: 20,
                weight: FontWeight.bold,
              ),
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Get.bottomSheet(
                      AddCategorie(selectedCat: null),
                      isScrollControlled: true,
                    );
                  },
                  icon: const Icon(Icons.add, size: 25, color: Colors.white),
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
            if (ctrl.status == ListeStatus.loading) {
              return const WidgetLoading();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customSearchBar(ctrl.searchController, 'taper_chercher'.tr, (
                  val,
                ) {
                  ctrl.filterCategories(val);
                }),
                // Toggle panel
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  child: IconButton(
                    icon: Icon(_isGrid ? Icons.grid_view : Icons.list),
                    tooltip: _isGrid ? 'grid_view'.tr : 'list_view'.tr,
                    onPressed: () {
                      setState(() {
                        _isGrid = !_isGrid;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: _isGrid
                      ? _buildGridView(ctrl)
                      : _buildHorizontalList(ctrl),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridView(ControllerCategories ctrl) {
    if (ctrl.listFilted.isEmpty) {
      return const ListeVide();
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: ctrl.listFilted.length,
      itemBuilder: (context, index) {
        return _categoryCard(ctrl, index);
      },
    );
  }

  Widget _buildHorizontalList(ControllerCategories ctrl) {
    if (ctrl.listFilted.isEmpty) {
      return const ListeVide();
    }
    return SizedBox(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ctrl.listFilted.length,
        itemBuilder: (context, index) {
          final item = ctrl.listFilted[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 20),

            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            child: ListTile(
              contentPadding: const EdgeInsets.all(20),
              leading: ClipOval(
                child: Image.network(
                  "${Constants.photoUrl}categorie/${item.id}.jpg",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 50,
                    height: 50,
                    color: Constants.primaryColor.withOpacity(0.1),
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              title: Text(
                Constants.getTitle(item.title, Constants.lang),
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      ctrl.arabicController.text = Constants.getTitle(
                        item.title,
                        "ar",
                      );
                      ctrl.englishController.text = Constants.getTitle(
                        item.title,
                        "en",
                      );
                      ctrl.frenchController.text = Constants.getTitle(
                        item.title,
                        "fr",
                      );
                      Get.bottomSheet(
                        AddCategorie(selectedCat: item),
                        isScrollControlled: true,
                      );
                    },
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('title_delete'.tr),
                          content: Text('content_delete'.tr),
                          actions: [
                            TextButton(
                              child: Text('cancel_delete'.tr),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: Text(
                                'confirm_delete'.tr,
                                style: const TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                ctrl.deleteCategory(item.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _categoryCard(ControllerCategories ctrl, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Image.network(
                "${Constants.photoUrl}categorie/${ctrl.listFilted[index].id}.jpg",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Constants.primaryColor.withOpacity(0.1),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  Constants.getTitle(
                    ctrl.listFilted[index].title,
                    Constants.lang,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        ctrl.arabicController.text = Constants.getTitle(
                          ctrl.listFilted[index].title,
                          "ar",
                        );
                        ctrl.englishController.text = Constants.getTitle(
                          ctrl.listFilted[index].title,
                          "en",
                        );
                        ctrl.frenchController.text = Constants.getTitle(
                          ctrl.listFilted[index].title,
                          "fr",
                        );
                        Get.bottomSheet(
                          AddCategorie(selectedCat: ctrl.listFilted[index]),
                          isScrollControlled: true,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('title_delete'.tr),
                            content: Text('content_delete'.tr),
                            actions: [
                              TextButton(
                                child: Text('cancel_delete'.tr),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: Text(
                                  'confirm_delete'.tr,
                                  style: const TextStyle(color: Colors.red),
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
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
