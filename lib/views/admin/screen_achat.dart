// screens/purchase_requests_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/admin/achat_controller.dart';
import 'package:rawaa_app/model/model_achat.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/admin/image_editor.dart';

class PurchaseRequestsScreen extends StatelessWidget {
  PurchaseRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PurchaseController>(
        init: PurchaseController(),
        builder: (controller) {
          return Column(
            children: [
              //  _buildSearchBar(controller),
              _buildFilterTabs(controller),
              const Divider(height: 1),
              _buildRequestsList(controller),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(PurchaseController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher par formation...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        onChanged: controller.setSearchQuery,
      ),
    );
  }

  Widget _buildFilterTabs(PurchaseController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFilterTab('tous'.tr, 'all', controller),
          _buildFilterTab('attente'.tr, 'waiting', controller),
          _buildFilterTab('accepte'.tr, 'confirmed', controller),
          _buildFilterTab('refuse'.tr, 'rejected', controller),
        ],
      ),
    );
  }

  Widget _buildFilterTab(
    String text,
    String status,
    PurchaseController controller,
  ) {
    final isSelected = controller.selectedFilter == status;

    return GestureDetector(
      onTap: () => controller.setFilter(status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRequestsList(PurchaseController controller) {
    if (controller.listeFiltreAchat.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'Aucune demande ${_getStatusText(controller.selectedFilter)}',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: controller.listeFiltreAchat.length,
        itemBuilder: (context, index) {
          return _buildRequestCard(
            controller.listeFiltreAchat[index],
            controller,
          );
        },
      ),
    );
  }

  Widget _buildRequestCard(MAchat request, PurchaseController controller) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // INSERT_YOUR_CODE
          GestureDetector(
            onTap: () {
              Get.to(
                () => ImageEditorScreen(
                  imageUrl: request.image != null && request.image!.isNotEmpty
                      ? "${Constants.photoUrl}recus_payement/${request.image}"
                      : "${Constants.photoUrl}recus_payement/${request.id}.jpg",
                  heroTag: 'receipt_${request.id}',
                ),
              );
            },
            child: Hero(
              tag: 'receipt_${request.id}',
              child: Container(
                height: 120,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      request.image != null && request.image!.isNotEmpty
                          ? "${Constants.photoUrl}recus_payement/${request.image}"
                          : "${Constants.photoUrl}recus_payement/${request.id}.jpg",
                    ),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2),
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Text(
                      request.titleFormation,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.circle,
                      size: 12,
                      color: getColor(request.status),
                    ),
                    Text(
                      getStatus(request.status),
                      style: TextStyle(color: getColor(request.status)),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Text('${'client'.tr} : ${request.nameClient}'),
                const SizedBox(height: 4),
                Text('${'prix'.tr}: ${Constants.currency(request.price)}'),
                const SizedBox(height: 4),
                Text('${'formatteur'.tr} : ${request.nameFormateur}'),
                const SizedBox(height: 16),
                if (request.status == 'waiting')
                  _buildActionButtons(request, controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color getColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;

      case 'rejected':
        return Colors.red;
      case 'waiting':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String getStatus(String status) {
    switch (status) {
      case 'confirmed':
        return 'accepte'.tr;

      case 'rejected':
        return 'rejected'.tr;
      case 'waiting':
        return 'attente'.tr;
      default:
        return 'inconnu'.tr;
    }
  }

  Widget _buildActionButtons(MAchat request, PurchaseController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => controller.refuseRequest(request.id),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
          ),
          child: Text('refuser'.tr),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => controller.acceptRequest(request.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text('accepter'.tr),
        ),
      ],
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'waiting':
        return 'en attente';
      case 'confirmed':
        return 'acceptée';
      case 'rejected':
        return 'refusée';
      default:
        return 'inconnu';
    }
  }
}
