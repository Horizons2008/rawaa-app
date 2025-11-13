import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rawaa_app/controller/order_controller.dart';
import 'package:rawaa_app/model/model_order.dart';
import 'package:rawaa_app/my_widgets/custom_text.dart';
import 'package:rawaa_app/my_widgets/liste_vide.dart';
import 'package:rawaa_app/my_widgets/loading.dart';
import 'package:rawaa_app/my_widgets/space_hor.dart';
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
                                      SpaceH(w: 15),
                                      _buildDeliveryStatusChip(order),
                                    ],
                                  ),
                                  SpaceV(h: 8),
                                  // Statut de livraison détaillé
                                  _buildDeliveryStatusText(order),
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

  Widget _buildDeliveryStatusChip(MOrder order) {
    String text;
    Color color;

    switch (order.livraison) {
      case 0:
        text = "Sans Livraison";
        color = Colors.grey;
        break;
      case 1:
        text = " demandée";
        color = Colors.blue;
        break;
      case 2:
        text = "Prix proposé";
        color = Colors.orange;
        break;
      case 3:
        text = "Prix accepté";
        color = Colors.green;
        break;
      case 4:
        text = "Prix refusé";
        color = Colors.red;
        break;
      default:
        text = "Livraison";
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getDeliveryIcon(order.livraison), size: 14, color: color),
          SizedBox(width: 4),
          CustomText(
            text: text,
            size: 11,
            weight: FontWeight.w500,
            coul: color,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryStatusText(MOrder order) {
    if (order.livraison == 0) {
      return SizedBox.shrink();
    }

    String statusText = '';
    Color textColor = Colors.grey[600]!;

    switch (order.livraison) {
      case 1:
        statusText = 'En attente d\'acceptation livreur';
        textColor = Colors.blue;
        break;
      case 2:
        statusText = order.fraisLivraison != null && order.fraisLivraison! > 0
            ? 'Prix proposé: ${_formatCurrency(order.fraisLivraison!)} Livreur ${order.driverName}'
            : 'Livreur propose un prix';
        textColor = Colors.orange;
        break;
      case 3:
        statusText = order.fraisLivraison != null && order.fraisLivraison! > 0
            ? 'Prix accepté: ${_formatCurrency(order.fraisLivraison!)}'
            : 'Prix accepté';
        textColor = Colors.green;
        break;
      case 5:
        statusText = 'Prix refusé';
        textColor = Colors.red;
        break;
    }

    if (statusText.isEmpty) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: 4),
      child: CustomText(
        text: statusText,
        size: 11,
        weight: FontWeight.w400,
        coul: textColor,
      ),
    );
  }

  IconData _getDeliveryIcon(int livraison) {
    switch (livraison) {
      case 0:
        return Icons.cancel;
      case 1:
        return Icons.local_shipping;
      case 2:
        return Icons.price_check;
      case 4:
        return Icons.check_circle;
      case 5:
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)} €';
  }
}
