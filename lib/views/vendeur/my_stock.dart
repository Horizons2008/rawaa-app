import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rawaa_app/controller/controller_stock.dart';
import 'package:rawaa_app/my_widgets/custom_text.dart';
import 'package:rawaa_app/my_widgets/error_restful.dart';
import 'package:rawaa_app/my_widgets/loading.dart';
import 'package:rawaa_app/model/model_stock.dart';
import 'package:rawaa_app/my_widgets/space_hor.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/vendeur/add_stock.dart';

class MyStock extends StatelessWidget {
  const MyStock({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: CustomText(
          text: "title_stock".tr,
          coul: Colors.white,
          size: 20,
          weight: FontWeight.bold,
        ),
        centerTitle: true,
        backgroundColor: Constants.primaryColor,
      ),
      body: GetBuilder<ControllerStock>(
        init: ControllerStock(),
        builder: (ctrl) {
          return ctrl.status == ListeStatus.loading
              ? WidgetLoading()
              : ctrl.status == ListeStatus.error
              ? WidgetError()
              : Column(
                  children: [
                    // Header Section

                    // Search Bar Section

                    // Stock List Section
                    Expanded(
                      child: ctrl.filteredList.isEmpty
                          ? _buildEmptyState()
                          : _buildStockList(ctrl),
                    ),
                  ],
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ControllerStock  ctrl=Get.find<ControllerStock>();
          ctrl.reset();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) {
              // For demo: Static lists for categories & products -- in real use, you would fetch with a controller.

              // For this demonstration, you can replace above lists with your dynamic data

              return Padding(
                padding: EdgeInsets.only(
                  // Make sheet fit above keyboard
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 20,
                  right: 20,
                  top: 32,
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    // You may want to fetch categories & products here if dynamic
                    return AddStock();
                  },
                ),
              );
            },
          );
        },
        backgroundColor: Constants.primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStockList(ControllerStock ctrl) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 80),
        itemCount: ctrl.filteredList.length,
        itemBuilder: (context, index) {
          MStock stock = ctrl.filteredList[index];
          return _buildStockItem(stock, context);
        },
      ),
    );
  }

  Widget _buildStockItem(MStock stock, BuildContext context) {
    return GetBuilder<ControllerStock>(
      builder: (ctrl) {
        return Card(
          elevation: 2,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
            child: Column(
              children: [
                ListTile(
                  leading: ClipOval(
                    child: Image.network(
                      "${Constants.photoUrl}stock/${stock.images[0]}",
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    "${stock.productTitle}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          ctrl.editStock(stock);
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            builder: (context) {
                              // For demo: Static lists for categories & products -- in real use, you would fetch with a controller.

                              // For this demonstration, you can replace above lists with your dynamic data

                              return Padding(
                                padding: EdgeInsets.only(
                                  // Make sheet fit above keyboard
                                  bottom: MediaQuery.of(
                                    context,
                                  ).viewInsets.bottom,
                                  left: 20,
                                  right: 20,
                                  top: 32,
                                ),
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    // You may want to fetch categories & products here if dynamic
                                    return AddStock();
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: Icon(
                          Icons.edit,
                          color: Colors.blue[700],
                          size: 20,
                        ),
                      ),
                      SpaceH(w: 15),
                      InkWell(
                        onTap: () {
                          Get.dialog(
                            AlertDialog(
                              title: CustomText(
                                text: "Supprimer le produit",
                                coul: Colors.red,
                                size: 16,
                                weight: FontWeight.bold,
                              ),
                              content: CustomText(
                                text:
                                    "Are you sure you want to delete this product?",
                                coul: Colors.grey,
                                size: 14,
                                weight: FontWeight.normal,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: CustomText(
                                    text: "Cancel",
                                    coul: Colors.grey,
                                    size: 14,
                                    weight: FontWeight.normal,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Constants.reposit
                                        .repDeleteStock(stock.id)
                                        .then((value) {
                                          if (value['status'] == "success") {
                                            Get.back();
                                            ctrl.getStock();
                                            Constants.showSnackBar(
                                              null,
                                              "Produit supprimé avec succés",
                                            );
                                          } else {
                                            Constants.showSnackBar(
                                              null,
                                              "Erreur lors de la suppression",
                                            );
                                          }
                                        });
                                  },
                                  child: CustomText(
                                    text: "Delete",
                                    coul: Colors.red,
                                    size: 14,
                                    weight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          );

                          /*
                              Constants.reposit.repDeleteStock(stock.id).then((
                                value,
                              ) {
                                if (value['status'] == "success") {
                                  Constants.showSnackBar(
                                    null,
                                    "Produit supprimé avec succés",
                                  );
                                  ctrl.getStock();
                                } else {
                                  Constants.showSnackBar(
                                    null,
                                    "Erreur lors de la suppression",
                                  );
                                }
                              });
                           */
                        },

                        child: Icon(
                          Icons.delete_outline_outlined,
                          color: Colors.red[700],
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "${'prix'.tr}:  ${Constants.currency(stock.price)}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    SpaceH(w: 5),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "${'qte'.tr} :${stock.qte}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Product Image

            // Product Details

            //SizedBox(width: 12),

            // Price
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text(
            "No Products Found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Try adjusting your search or add a new product.",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
