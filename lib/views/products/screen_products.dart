import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/controller_product.dart';
import 'package:rawaa_app/model/model_categorie.dart';
import 'package:rawaa_app/my_widgets/custom_search_bar.dart';
import 'package:rawaa_app/my_widgets/custom_text.dart';
import 'package:rawaa_app/my_widgets/liste_vide.dart';
import 'package:rawaa_app/my_widgets/loading.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/products/add_product.dart';

class ScreenProduct extends StatefulWidget {
  const ScreenProduct({super.key});

  @override
  State<ScreenProduct> createState() => _ScreenProductState();
}

class _ScreenProductState extends State<ScreenProduct> {
  // true = Grid view, false = Horizontal list view
  bool _isGrid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: GetBuilder<ControllerProducts>(
          builder: (ctrl) {
            return AppBar(
              backgroundColor: Constants.primaryColor,
              title: CustomText(
                text: "products".tr,
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
                      AddProduct(selectedPRoduct: null),
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
        child: GetBuilder<ControllerProducts>(
          init: ControllerProducts(),
          builder: (ctrl) {
            if (ctrl.status == ListeStatus.loading) {
              return const WidgetLoading();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customSearchBar(
                  ctrl.searchController,
                  'taper_chercher'.tr,
                  () {
                    ctrl.searchController.text = "";
                    ctrl.filterProduct(ctrl.searchController.text);
                  },
                  (val) {
                    ctrl.filterProduct(val);
                  },
                ),
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

  Widget _buildGridView(ControllerProducts ctrl) {
    if (ctrl.listFiltred.isEmpty) {
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
      itemCount: ctrl.listFiltred.length,
      itemBuilder: (context, index) {
        return _productCard(ctrl, index);
      },
    );
  }

  Widget _buildHorizontalList(ControllerProducts ctrl) {
    if (ctrl.listFiltred.isEmpty) {
      return const ListeVide();
    }
    return SizedBox(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ctrl.listFiltred.length,
        itemBuilder: (context, index) {
          final item = ctrl.listFiltred[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(20),
              title: Text(
                Constants.getTitle(item.title, Constants.lang),
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                Constants.getTitle(item.categorieTitle, Constants.lang),
                style: const TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      MCat cat = ctrl.listCat.firstWhere(
                        (element) => element.id == item.categorieId,
                      );
                      ctrl.selectedCat = cat;
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
                      ctrl.update();
                      Get.bottomSheet(
                        AddProduct(selectedPRoduct: item),
                        isScrollControlled: true,
                      );
                    },
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
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
                                ctrl.deleteProduct(item.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
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

  Widget _productCard(ControllerProducts ctrl, int index) {
    final item = ctrl.listFiltred[index];
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Constants.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.shopping_bag,
                  size: 60,
                  color: Constants.primaryColor.withOpacity(0.5),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  Constants.getTitle(item.title, Constants.lang),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  Constants.getTitle(item.categorieTitle, Constants.lang),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                        MCat cat = ctrl.listCat.firstWhere(
                          (element) => element.id == item.categorieId,
                        );
                        ctrl.selectedCat = cat;
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
                        ctrl.update();
                        Get.bottomSheet(
                          AddProduct(selectedPRoduct: item),
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
                                  ctrl.deleteProduct(item.id);
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
