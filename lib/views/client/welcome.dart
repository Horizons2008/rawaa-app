import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/welcome_controller.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/client/detail_stock.dart';

class ScreenWelcomClient extends StatelessWidget {
  const ScreenWelcomClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
        child: GetBuilder<WelcomeClientController>(
          init: WelcomeClientController(),
          builder: (ctrl) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Profile
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipOval(
                      child: Image.network(
                        "${Constants.photoUrl}users/${Constants.currentUser!.id}.jpg",

                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return CircleAvatar(
                            radius: 20,
                            child: Icon(Icons.person, size: 30),
                          );
                        },
                      ),
                    ),

                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Constants.currentUser!.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            Constants.currentUser!.role,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Categories section
                Text(
                  'categories'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 110,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: ctrl.listeCat.length,
                    separatorBuilder: (c, i) => SizedBox(width: 18),
                    itemBuilder: (context, idx) {
                      final cat = ctrl.listeCat[idx];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            padding: EdgeInsets.all(2),

                            child: ClipOval(
                              child: Image.network(
                                "${Constants.photoUrl}categorie/${cat.id}.jpg",
                                fit: BoxFit.cover,

                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error);
                                },
                              ),
                            ),
                          ),

                          SizedBox(height: 7),
                          Text(
                            Constants.getTitle(cat.title, Constants.lang),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 32),

                // Products section
                Text(
                  'products'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 14),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: ctrl.listeStock.length,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.71,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 18,
                  ),
                  itemBuilder: (context, idx) {
                    final prod = ctrl.listeStock[idx];
                    return InkWell(
                      onTap: () {
                        ctrl.qte = 1;
                        ctrl.total = prod.price;
                        Get.to(() => ProductDetailScreen(stock: prod));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(18),
                              ),
                              child: Image.network(
                                "${Constants.photoUrl}stock/${prod.images[0]}",
                                height: 90,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            SizedBox(height: 15),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    prod.productTitle,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${"prix".tr}: ${Constants.currency(prod.price)}',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.inventory_2,
                                        size: 16,
                                        color: Colors.orange,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        '${"qte".tr}: ${prod.qte}',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 2),
                                      Flexible(
                                        child: Text(
                                          prod.vendeurName,
                                          style: TextStyle(fontSize: 13),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
