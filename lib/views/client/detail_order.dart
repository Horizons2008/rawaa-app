import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rawaa_app/controller/order_controller.dart';
import 'package:rawaa_app/model/model_detail.dart';
import 'package:rawaa_app/model/model_order.dart';
import 'package:rawaa_app/styles/constants.dart';

class OrderDetailWidget extends StatelessWidget {
  const OrderDetailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détails de la Commande',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Constants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: GetBuilder<OrderController>(
        builder: (ctrl) {
          return Column(
            children: [
              // Header with order information
              _buildOrderHeader(ctrl.selectedOrder!),

              // List of order items
              Expanded(child: _buildOrderItemsList()),

              // Footer with total
              _buildOrderFooter(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderHeader(MOrder order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Commande #${order.id}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildStatusChip(order.status),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${_formatDate(DateTime.parse(order.dateDemande))}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  Text(
                    Constants.currentUser!.role == 'client'
                        ? 'Vendeur: ${order.vendeurName}'
                        : 'Client: ${order.clientName}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              Text(
                _formatCurrency(order.total * 1.0),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsList() {
    OrderController ctrl = Get.find();
    return ListView.builder(
      itemCount: ctrl.listeDetail.length,
      itemBuilder: (context, index) {
        final item = ctrl.listeDetail[index];
        return _buildOrderItem(item);
      },
    );
  }

  Widget _buildOrderItem(MDetail item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Constants.getTitle(item.productName, Constants.lang),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem('Quantité', '${item.qte}'),
                _buildInfoItem(
                  'Prix Unitaire',
                  '${_formatCurrency(item.price * 1.0)}',
                ),
                _buildInfoItem(
                  'Sous-total',
                  '${_formatCurrency(item.price * item.qte * 1.0)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildOrderFooter() {
    // INSERT_YOUR_CODE
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                OrderController ctrl = Get.find();
                ctrl.changeStatus(1);
                // Action to accept order
                // TODO: Implement accept logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Accepter',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                OrderController ctrl = Get.find();
                ctrl.changeStatus(2);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Refuser',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(int status) {
    Color backgroundColor;
    Color textColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Constants.getStatusColor(status),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        Constants.getStatusLabel(status),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)} €';
  }
}

// Example usage
