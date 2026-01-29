import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rawaa_app/controller/order_controller.dart';
import 'package:rawaa_app/model/model_detail.dart';
import 'package:rawaa_app/model/model_order.dart';
import 'package:rawaa_app/my_widgets/custom_button.dart';
import 'package:rawaa_app/my_widgets/custom_text.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/controller/chat_controller.dart';
import 'package:rawaa_app/model/model_contact.dart';
import 'package:rawaa_app/views/client/screen_message.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailWidget extends StatelessWidget {
  const OrderDetailWidget({Key? key}) : super(key: key);

  // Static map to store expansion state for delivery details
  static final Map<String, bool> _deliveryDetailsExpanded = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'detail_order'.tr,
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
              _buildOrderHeader(context, ctrl.selectedOrder!, ctrl),

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

  Widget _buildOrderHeader(
    BuildContext context,
    MOrder order,
    OrderController ctrl,
  ) {
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
                '${"order".tr} #${order.id}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildStatusChip(order.status),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        Text(
                          ' ${_formatDate(DateTime.parse(order.dateDemande))}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person, size: 14, color: Colors.grey),
                        Text(
                          Constants.currentUser!.role == 'client'
                              ? order.vendeurName
                              : order.clientName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),

                        // Boutons d'action rapide
                        /*   _buildQuickActionButtons(
                          context,
                          Constants.currentUser!.role == 'client'
                              ? order.vendeurId
                              : order.clientId,
                        ),*/
                      ],
                    ),
                  ],
                ),
              ),
              /*  Text(
                Constants.currency(order.total * 1.0),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),*/
            ],
          ),
          const SizedBox(height: 12),
          // Buttons for client and vendeur details
          Row(
            children: [
              Expanded(
                child: _buildUserDetailCard(
                  context: context,
                  icon: Icons.person,
                  title: 'detail_client'.tr,
                  subtitle: order.clientName,
                  color: Colors.blue,
                  onTap: () {
                    _showUserDetails(
                      context,
                      order.clientId,

                      order.clientName,
                      'Client',
                      ctrl.detailClient['phone'],
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildUserDetailCard(
                  context: context,
                  icon: Icons.store,
                  title: 'detail_vendeur'.tr,
                  subtitle: order.vendeurName,
                  color: Colors.green,
                  onTap: () => _showUserDetails(
                    context,
                    order.vendeurId,
                    order.vendeurName,
                    'Vendeur',
                    ctrl.detailVendeur['phone'],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Delivery status widget
          _buildDeliveryStatus(order, ctrl),
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
                _buildInfoItem('qte'.tr, '${item.qte}'),
                _buildInfoItem('prix'.tr, Constants.currency(item.price * 1.0)),
                _buildInfoItem(
                  'total'.tr,
                  Constants.currency(item.price * item.qte * 1.0),
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
    return Constants.currentUser!.role == 'vendeur'
        ? Padding(
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
                    child: Text(
                      'accepter_order'.tr,
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
                    child: Text(
                      'refuser_order'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Constants.currentUser!.role == 'driver'
        ? Padding(
            padding: EdgeInsetsGeometry.all(15),
            child: CustomButton(
              titre: CustomText(
                text: "prix_propose".tr,
                coul: Colors.white,
                size: 18,
                weight: FontWeight.w600,
              ),
              onclick: () {
                // Show dialog to input price value with confirmation button
                TextEditingController priceController = TextEditingController();
                showDialog(
                  context: Get.context!,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header with gradient
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange[400]!,
                                    Colors.orange[600]!,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.price_check,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'prix_propose'.tr,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Entrez le prix proposé pour cette livraison',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            // Content section
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: TextField(
                                      controller: priceController,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'prix'.tr,
                                        hintText: '0.00',
                                        prefixIcon: Container(
                                          margin: const EdgeInsets.all(8),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.orange[100],
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.euro,
                                            color: Colors.orange[700],
                                            size: 20,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.orange[400]!,
                                            width: 2,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 16,
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Action buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            side: BorderSide(
                                              color: Colors.grey[400]!,
                                            ),
                                          ),
                                          child: Text(
                                            'cancel'.tr,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            String value = priceController.text
                                                .trim();
                                            if (value.isEmpty ||
                                                double.tryParse(value) ==
                                                    null) {
                                              Get.snackbar(
                                                'Erreur',
                                                'Veuillez entrer un prix valide',
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                              );
                                              return;
                                            }
                                            double proposedPrice = double.parse(
                                              value,
                                            );
                                            OrderController ctrl = Get.find();
                                            ctrl.proposePrice(proposedPrice);
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange[600],
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: Text(
                                            'confirmation'.tr,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
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
                      ),
                    );
                  },
                );
              },
            ),
          )
        : SizedBox();
  }

  Widget _buildStatusChip(int status) {
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

  void _showUserDetails(
    BuildContext context,
    int userId,
    String userName,
    String role,
    String phoneNumber2,
  ) async {
    // Récupérer les détails complets de l'utilisateur
    String? phoneNumber;
    String? userRole = role;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Center(child: CircularProgressIndicator()),
      ),
    );

    try {
      // Récupérer le numéro de téléphone et le rôle depuis l'API
      /* final response = await Constants.reposit.repGetUserById(userId);
      if (response['status'] == 'SUCCESS' && response['user'] != null) {
        phoneNumber = response['user']['phone']?.toString();
        userRole = response['user']['role']?.toString() ?? role;
      }*/
      phoneNumber = phoneNumber2;
      userRole = role;
    } catch (e) {
      print('Error fetching user details: $e');
      // Si l'API n'est pas disponible, on continue sans le numéro
    } finally {
      if (context.mounted) {
        Navigator.of(context).pop(); // Fermer le dialog de chargement
      }
    }

    // Afficher le dialog avec les informations
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with gradient background
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Constants.primaryColor,
                          Constants.primaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Profile picture with border
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.network(
                              "${Constants.photoUrl}user/$userId.jpg",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // User name
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Role badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            userRole ?? role,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content section
                  Padding(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User information card
                        // Communication panel
                        _buildCommunicationPanel(
                          context,
                          userId,
                          userName,
                          userRole ?? role,
                          phoneNumber,
                        ),
                      ],
                    ),
                  ),
                  // Close button
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Fermer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildCommunicationPanel(
    BuildContext context,
    int userId,
    String userName,
    String userRole,
    String? phoneNumber,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.blue[100]!.withOpacity(0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Buttons in a row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Bouton Appeler
              if (phoneNumber != null && phoneNumber.isNotEmpty)
                _buildSmallCommunicationButton(
                  icon: Icons.phone,
                  label: 'Appeler',
                  color: Colors.green,
                  onPressed: () => _makePhoneCall(phoneNumber),
                ),
              // Bouton WhatsApp
              if (phoneNumber != null && phoneNumber.isNotEmpty)
                _buildSmallCommunicationButton(
                  icon: Icons.chat_bubble,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  onPressed: () => _openWhatsApp(phoneNumber),
                ),
              // Bouton Message via application
              _buildSmallCommunicationButton(
                icon: Icons.message,
                label: 'Message',
                color: Colors.blue,
                onPressed: () => _openChat(context, userId, userName, userRole),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommunicationButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white),
          label: Text(label, style: const TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallCommunicationButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        Get.snackbar(
          'Erreur',
          'Impossible d\'ouvrir l\'application téléphone',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de l\'appel: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    try {
      // Nettoyer le numéro de téléphone (enlever les espaces, +, etc.)
      String cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

      // Remove leading zeros if present
      if (cleanPhone.startsWith('0')) {
        cleanPhone = cleanPhone.substring(1);
      }

      // Ensure phone number is not empty
      if (cleanPhone.isEmpty) {
        Get.snackbar(
          'Erreur',
          'Numéro de téléphone invalide',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Try direct WhatsApp app scheme first (whatsapp://send?phone=)
      final Uri whatsappDirectUri = Uri.parse(
        'whatsapp://send?phone=$cleanPhone',
      );

      // Try to launch WhatsApp directly
      if (await canLaunchUrl(whatsappDirectUri)) {
        await launchUrl(
          whatsappDirectUri,
          mode: LaunchMode.externalApplication,
        );
        return;
      }

      // Fallback: Use web WhatsApp URL (https://wa.me/)
      final Uri whatsappWebUri = Uri.parse('https://wa.me/$cleanPhone');

      if (await canLaunchUrl(whatsappWebUri)) {
        await launchUrl(whatsappWebUri, mode: LaunchMode.externalApplication);
      } else {
        // Last resort: try external non-browser
        await launchUrl(
          whatsappWebUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
      }
    } catch (e) {
      // If all methods fail, show error
      Get.snackbar(
        'Erreur',
        'Impossible d\'ouvrir WhatsApp. Assurez-vous que WhatsApp est installé sur votre appareil.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      print('Error opening WhatsApp: $e');
    }
  }

  void _openChat(
    BuildContext context,
    int userId,
    String userName,
    String userRole,
  ) {
    Navigator.of(context).pop(); // Fermer le dialog

    try {
      // Get or initialize ChatController
      ChatController chatController;
      if (Get.isRegistered<ChatController>()) {
        chatController = Get.find<ChatController>();
      } else {
        chatController = Get.put(ChatController());
      }

      // Create MContact from user data
      final contact = MContact(id: userId, name: userName, role: userRole);

      // Set selected contact and navigate to chat screen
      chatController.setSelectedContact(contact);
      Get.to(() => const ScreenDiscussion());
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible d\'ouvrir le chat: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildQuickActionButtons(BuildContext context, int userId) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bouton Appel direct
        IconButton(
          onPressed: () => _quickCall(context, userId),
          icon: const Icon(Icons.phone, color: Colors.green, size: 20),
          tooltip: 'Appeler',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 4),
        // Bouton WhatsApp
        IconButton(
          onPressed: () => _quickWhatsApp(context, userId),
          icon: const Icon(
            Icons.chat_bubble,
            color: Color(0xFF25D366),
            size: 20,
          ),
          tooltip: 'WhatsApp',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Future<void> _quickCall(BuildContext context, int userId) async {
    try {
      // Récupérer le numéro de téléphone
      final response = await Constants.reposit.repGetUserById(userId);
      if (response['status'] == 'SUCCESS' && response['user'] != null) {
        final phoneNumber = response['user']['phone']?.toString();
        if (phoneNumber != null && phoneNumber.isNotEmpty) {
          await _makePhoneCall(phoneNumber);
        } else {
          Get.snackbar(
            'Information',
            'Numéro de téléphone non disponible',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Erreur',
          'Impossible de récupérer le numéro de téléphone',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de la récupération des informations: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _quickWhatsApp(BuildContext context, int userId) async {
    try {
      // Récupérer le numéro de téléphone
      final response = await Constants.reposit.repGetUserById(userId);
      if (response['status'] == 'SUCCESS' && response['user'] != null) {
        final phoneNumber = response['user']['phone']?.toString();
        if (phoneNumber != null && phoneNumber.isNotEmpty) {
          await _openWhatsApp(phoneNumber);
        } else {
          Get.snackbar(
            'Information',
            'Numéro de téléphone non disponible',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Erreur',
          'Impossible de récupérer le numéro de téléphone',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de la récupération des informations: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildUserDetailCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: color.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Constants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Constants.primaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryStatus(MOrder order, OrderController ctrl) {
    String statusText;
    Color statusColor;
    IconData statusIcon;
    String? additionalInfo;

    switch (order.livraison) {
      case 0:
        // Commande sans livraison
        statusText = 'sans_livraison'.tr;
        statusColor = Colors.grey;
        statusIcon = Icons.cancel;
        break;
      case 1:
        // Client demande livraison
        statusText = 'Client demande livraison';
        statusColor = Colors.blue;
        statusIcon = Icons.local_shipping;
        break;
      case 2:
        // Livreur propose un prix
        statusText = 'Livreur propose un prix';
        statusColor = Colors.orange;
        statusIcon = Icons.price_check;
        if (order.fraisLivraison != null && order.fraisLivraison! > 0) {
          additionalInfo =
              'Prix proposé: ${_formatCurrency(order.fraisLivraison!)}';
        }
        break;
      case 3:
        // Client accepte le prix
        statusText = 'Client accepte le prix';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        if (order.fraisLivraison != null && order.fraisLivraison! > 0) {
          additionalInfo =
              'Prix accepté: ${_formatCurrency(order.fraisLivraison!)}';
        }
        break;
      case 5:
        // Client refuse le prix
        statusText = 'Client refuse le prix';
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        if (order.fraisLivraison != null && order.fraisLivraison! > 0) {
          additionalInfo =
              'Prix refusé: ${_formatCurrency(order.fraisLivraison!)}';
        }
        break;
      default:
        // Statut inconnu
        statusText = 'Statut de livraison inconnu';
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    // Get client location details
    dynamic clientData = ctrl.detailClient;
    String? wilaya;
    String? commune;
    String? latitude;
    String? longitude;

    // Debug: Print client data structure
    print('=== CLIENT DATA DEBUG ===');
    print('Client Dataaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa: $clientData');
    print('Client Data Type: ${clientData.runtimeType}');
    if (clientData != null && clientData is Map) {
      print('Client Data Keys: ${clientData.keys.toList()}');
      // Print all key-value pairs for debugging
      clientData.forEach((key, value) {
        print('  $key: $value (${value.runtimeType})');
      });
    }

    if (clientData != null) {
      // Helper function to safely extract string from dynamic value
      String? extractString(dynamic value) {
        if (value == null) return null;
        if (value is String) return value;
        if (value is num) return value.toString();
        if (value is Map) {
          return value['title']?.toString() ??
              value['name']?.toString() ??
              value.toString();
        }
        return value.toString();
      }

      // Try to get wilaya - check multiple possible paths
      wilaya = extractString(
        Constants.getTitle(
          jsonEncode(clientData['wilaya']['title']),
          Constants.lang,
        ),
      );

      // Try to get commune - check multiple possible paths
      commune = extractString(
        Constants.getTitle(
          jsonEncode(clientData['commune']['title']),
          Constants.lang,
        ),
      );

      // Get GPS coordinates - try different possible field names and paths
      // Check direct fields first
      latitude =
          extractString(clientData['latitude']) ??
          extractString(clientData['latidude']) ??
          extractString(clientData['lat']) ??
          extractString(clientData['Latitude']) ??
          extractString(clientData['LATITUDE']);

      longitude =
          extractString(clientData['longitude']) ??
          extractString(clientData['lng']) ??
          extractString(clientData['lon']) ??
          extractString(clientData['Longitude']) ??
          extractString(clientData['LONGITUDE']);

      // If not found, check in nested 'user' object
      if (clientData['user'] != null && clientData['user'] is Map) {
        dynamic userData = clientData['user'];
        latitude =
            latitude ??
            extractString(userData['latitude']) ??
            extractString(userData['latidude']) ??
            extractString(userData['lat']);
        longitude =
            longitude ??
            extractString(userData['longitude']) ??
            extractString(userData['lng']) ??
            extractString(userData['lon']);
      }

      // If still not found, check in nested 'client' object
      if (clientData['client'] != null && clientData['client'] is Map) {
        dynamic nestedClientData = clientData['client'];
        latitude =
            latitude ??
            extractString(nestedClientData['latitude']) ??
            extractString(nestedClientData['latidude']) ??
            extractString(nestedClientData['lat']);
        longitude =
            longitude ??
            extractString(nestedClientData['longitude']) ??
            extractString(nestedClientData['lng']) ??
            extractString(nestedClientData['lon']);
      }

      // Debug: Print extracted values
      print('=== EXTRACTED VALUES ===');
      print('Wilaya: $wilaya');
      print('Commune: $commune');
      print('Latitude: $latitude');
      print('Longitude: $longitude');
      print('========================');
    } else {
      print('Client Data is NULL!');
    }

    return StatefulBuilder(
      builder: (context, setState) {
        // Use a key based on order ID to maintain state per order
        final expansionKey = 'delivery_details_${order.id}';
        final isExpanded = _deliveryDetailsExpanded[expansionKey] ?? true;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery status row with collapse/expand button
              InkWell(
                onTap: () {
                  setState(() {
                    _deliveryDetailsExpanded[expansionKey] = !isExpanded;
                  });
                },
                child: Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'status_livraison'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                          if (additionalInfo != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                additionalInfo,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Collapse/Expand icon
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ],
                ),
              ),
              // Client location details - Show for all delivery orders (collapsible)
              if (order.livraison > 0 && isExpanded)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.blue[700],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'adresse_libvraison'.tr,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Always show location fields, even if data is missing
                        _buildLocationInfoRow(
                          'wilaya'.tr,
                          wilaya ?? 'Non disponible',
                        ),
                        _buildLocationInfoRow(
                          'commune'.tr,
                          commune ?? 'Non disponible',
                        ),
                        _buildLocationInfoRow(
                          'position_gps'.tr,
                          (latitude != null && longitude != null)
                              ? '$latitude, $longitude'
                              : 'Non disponible',
                        ),
                        // Show Google Maps button only if coordinates are available
                        if (latitude != null &&
                            longitude != null &&
                            latitude.isNotEmpty &&
                            longitude.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final lat = double.tryParse(latitude ?? '0');
                                  final lng = double.tryParse(longitude ?? '0');
                                  if (lat != null && lng != null) {
                                    _openGoogleMaps(lat, lng);
                                  } else {
                                    Get.snackbar(
                                      'Erreur',
                                      'Coordonnées GPS invalides',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                                icon: const Icon(Icons.map, size: 18),
                                label: Text('voir_sur_maps'.tr),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[700],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // Debug info (remove in production)
                        if (clientData == null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '⚠️ Données client non disponibles',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.orange[700],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              // Boutons d'acceptation/refus pour le client quand livreur propose un prix
              if (order.livraison == 2 &&
                  Constants.currentUser!.role == 'client')
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          OrderController ctrl = Get.find();
                          ctrl.acceptePrice();
                        },
                        icon: const Icon(Icons.check_circle, size: 24),
                        color: Colors.green,
                        tooltip: 'Accepter le prix',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _refuseDeliveryPrice(order),
                        icon: const Icon(Icons.cancel, size: 24),
                        color: Colors.red,
                        tooltip: 'Refuser le prix',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openGoogleMaps(double latitude, double longitude) async {
    // Create Google Maps URL
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final Uri mapsUri = Uri.parse(googleMapsUrl);

    try {
      if (await canLaunchUrl(mapsUri)) {
        await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Erreur',
          'Impossible d\'ouvrir Google Maps',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de l\'ouverture de Google Maps: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _acceptDeliveryPrice(MOrder order) async {
    try {
      final response = await Constants.reposit
          .repAcceptePrice({"id": order.id})
          .then((onValue) {
            print("accccccccccccepte $onValue");
          });
      if (response['status'] == 'success') {
        // Mettre à jour le statut de livraison
        OrderController ctrl = Get.find();
        ctrl.selectedOrder!.livraison = 3; // Client accepte le prix
        ctrl.update();

        Constants.showSnackBar('Succès', 'Prix de livraison accepté');
      } else {
        Constants.showSnackBar(
          'Erreur',
          response['message'] ?? 'Erreur lors de l\'acceptation',
        );
      }
    } catch (e) {
      Constants.showSnackBar('Erreur', 'Erreur: $e');
      print('Error accepting delivery price: $e');
    }
  }

  Future<void> _refuseDeliveryPrice(MOrder order) async {
    try {
      final response = await Constants.reposit.reprefusePrice({"id": order.id});
      if (response['status'] == 'success') {
        // Mettre à jour le statut de livraison
        OrderController ctrl = Get.find();
        ctrl.selectedOrder!.livraison = 1; // Client refuse le prix
        ctrl.selectedOrder!.fraisLivraison = null; // Client refuse le prix

        ctrl.update();

        Constants.showSnackBar('Succès', 'Prix de livraison refusé');
      } else {
        Constants.showSnackBar(
          'Erreur',
          response['message'] ?? 'Erreur lors du refus',
        );
      }
    } catch (e) {
      Constants.showSnackBar('Erreur', 'Erreur: $e');
      print('Error refusing delivery price: $e');
    }
  }
}

// Example usage
