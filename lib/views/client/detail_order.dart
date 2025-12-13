import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rawaa_app/controller/order_controller.dart';
import 'package:rawaa_app/model/model_detail.dart';
import 'package:rawaa_app/model/model_order.dart';
import 'package:rawaa_app/model/muser.dart';
import 'package:rawaa_app/my_widgets/custom_button.dart';
import 'package:rawaa_app/my_widgets/custom_text.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/chat/screen_chat.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailWidget extends StatelessWidget {
  const OrderDetailWidget({Key? key}) : super(key: key);

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
              _buildOrderHeader(context, ctrl.selectedOrder!),

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

  Widget _buildOrderHeader(BuildContext context, MOrder order) {
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${"date".tr} : ${_formatDate(DateTime.parse(order.dateDemande))}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            Constants.currentUser!.role == 'client'
                                ? '${"vendeur".tr} : ${order.vendeurName}'
                                : 'Client: ${order.clientName}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        // Boutons d'action rapide
                        _buildQuickActionButtons(
                          context,
                          Constants.currentUser!.role == 'client'
                              ? order.vendeurId
                              : order.clientId,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                Constants.currency(order.total * 1.0),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Buttons for client and vendeur details
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showUserDetails(
                    context,
                    order.clientId,
                    order.clientName,
                    'Client',
                  ),
                  icon: const Icon(Icons.person, size: 18),
                  label: Text('detail_client'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showUserDetails(
                    context,
                    order.vendeurId,
                    order.vendeurName,
                    'Vendeur',
                  ),
                  icon: const Icon(Icons.store, size: 18),
                  label: Text('detail_vendeur'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Delivery status widget
          _buildDeliveryStatus(order),
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
                text: "Proposer un prix",
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
                    return AlertDialog(
                      title: const Text('Proposer un prix'),
                      content: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Prix proposé',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.euro),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Annuler'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            String value = priceController.text.trim();
                            if (value.isEmpty ||
                                double.tryParse(value) == null) {
                              // Optionally show an error
                              Get.snackbar(
                                'Erreur',
                                'Veuillez entrer un prix valide',
                              );
                              return;
                            }
                            // Do something with the value, e.g. send to controller
                            double proposedPrice = double.parse(value);
                            OrderController ctrl = Get.find();
                            ctrl.proposePrice(proposedPrice);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Confirmer'),
                        ),
                      ],
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
  ) async {
    // Récupérer les détails complets de l'utilisateur
    String? phoneNumber;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Center(child: CircularProgressIndicator()),
      ),
    );

    try {
      // Récupérer le numéro de téléphone depuis l'API
      final response = await Constants.reposit.repGetUserById(userId);
      if (response['status'] == 'SUCCESS' && response['user'] != null) {
        phoneNumber = response['user']['phone']?.toString();
      }
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
        builder: (context) => AlertDialog(
          title: Text('Détails $role'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo de profil
                Center(
                  child: ClipOval(
                    child: Image.network(
                      "${Constants.photoUrl}user/$userId.jpg",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person, size: 40),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Informations utilisateur
                _buildUserInfoRow('ID', userId.toString()),
                _buildUserInfoRow('Nom', userName),
                _buildUserInfoRow('Rôle', role),
                const SizedBox(height: 16),
                // Panneau de communication
                _buildCommunicationPanel(
                  context,
                  userId,
                  userName,
                  phoneNumber,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildCommunicationPanel(
    BuildContext context,
    int userId,
    String userName,
    String? phoneNumber,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Moyens de communication',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          // Bouton Appeler
          if (phoneNumber != null && phoneNumber.isNotEmpty)
            _buildCommunicationButton(
              icon: Icons.phone,
              label: 'Appeler',
              color: Colors.green,
              onPressed: () => _makePhoneCall(phoneNumber),
            ),
          // Bouton WhatsApp
          if (phoneNumber != null && phoneNumber.isNotEmpty)
            _buildCommunicationButton(
              icon: Icons.chat_bubble,
              label: 'WhatsApp',
              color: const Color(0xFF25D366),
              onPressed: () => _openWhatsApp(phoneNumber),
            ),
          // Bouton Message via application
          _buildCommunicationButton(
            icon: Icons.message,
            label: 'Envoyer un message',
            color: Colors.blue,
            onPressed: () => _openChat(context, userId, userName),
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
    // Nettoyer le numéro de téléphone (enlever les espaces, +, etc.)
    String cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Format WhatsApp: https://wa.me/CODE_PAYS_NUMERO
    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanPhone');

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Erreur',
          'WhatsApp n\'est pas installé sur cet appareil',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de l\'ouverture de WhatsApp: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _openChat(BuildContext context, int userId, String userName) {
    Navigator.of(context).pop(); // Fermer le dialog
    // Créer un objet Muser pour le chat
    final recipientUser = Muser(
      id: userId.toString(),
      name: userName,
      role: '',
      username: '',
      token: '',
    );
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

  Widget _buildDeliveryStatus(MOrder order) {
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
          Row(
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
            ],
          ),
          // Boutons d'acceptation/refus pour le client quand livreur propose un prix
          if (order.livraison == 2 && Constants.currentUser!.role == 'client')
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
