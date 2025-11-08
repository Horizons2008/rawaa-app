import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rawaa_app/controller/order_controller.dart';
import 'package:rawaa_app/my_widgets/custom_text.dart';
import 'package:rawaa_app/my_widgets/liste_vide.dart';
import 'package:rawaa_app/my_widgets/loading.dart';
import 'package:rawaa_app/my_widgets/space_ver.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/client/detail_order.dart';

class ScreenOrder extends StatelessWidget {
  const ScreenOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        title: CustomText(
          text: "Mes commandes",
          coul: Colors.white,
          weight: FontWeight.bold,
          size: 18,
        ),
      ),
      body: GetBuilder<OrderController>(
        init: OrderController(),
        builder: (ctrl) {
          return ctrl.status == ListeStatus.loading
              ? WidgetLoading()
              : ctrl.status == ListeStatus.error
              ? ErrorWidget("")
              : ctrl.listeOrder.isEmpty
              ? ListeVide()
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final order = ctrl.listeOrder[index];
                    return InkWell(
                      onTap: () {
                        ctrl.getDetailOrder(order);
                        Get.to(() => OrderDetailWidget());
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order #: ${order.id}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),

                                  Text(
                                    DateFormat(
                                      'dd MMMM yyyy',
                                    ).format(DateTime.parse(order.dateDemande)),

                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SpaceV(h: 15),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 15,
                                        color: Colors.grey,
                                      ),
                                      CustomText(
                                        text:
                                            Constants.currentUser!.role ==
                                                'client'
                                            ? order.vendeurName
                                            : order.clientName,
                                        size: 12,
                                        weight: FontWeight.w400,
                                        coul: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Constants.getStatusColor(
                                        order.status,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      Constants.getStatusLabel(order.status),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "\$${order.total.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: ctrl.listeOrder.length,
                );
        },
      ),
    );

    // Helper function to get status color
  }
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'shipped':
      return Colors.green;
    case 'accepted':
      return Colors.blue;
    case 'en attente':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}
