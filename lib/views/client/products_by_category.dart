import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/welcome_controller.dart';
import 'package:rawaa_app/model/model_categorie.dart';
import 'package:rawaa_app/styles/constants.dart';

class ProductsByCategoryScreen extends StatelessWidget {
  final MCat category;

  const ProductsByCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Constants.getTitle(category.title, Constants.lang),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: GetBuilder<WelcomeClientController>(
        init: WelcomeClientController(),
        builder: (ctrl) {
          // Fetch products when screen loads (only once)
          if (ctrl.status == ListeStatus.none ||
              (ctrl.currentCategoryId != category.id && !ctrl.isFetching)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ctrl.getProductsByCategory(category.id);
            });
          }

          if (ctrl.status == ListeStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ctrl.status == ListeStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'error_loading_products'.tr,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ctrl.getProductsByCategory(category.id);
                    },
                    child: Text('retry'.tr),
                  ),
                ],
              ),
            );
          }

          if (ctrl.listeProduct.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'no_products_found'.tr,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 18,
            ),
            itemCount: ctrl.listeProduct.length,
            itemBuilder: (context, idx) {
              final product = ctrl.listeProduct[idx];
              return InkWell(
                onTap: () {
                  // Navigate to product detail or stock list for this product
                  // You can implement navigation to a product detail screen here
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.shopping_bag,
                            size: 50,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Constants.getTitle(product.title, Constants.lang),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.category,
                                  size: 14,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    Constants.getTitle(
                                      product.categorieTitle,
                                      Constants.lang,
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
