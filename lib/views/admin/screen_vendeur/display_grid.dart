import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/admin/vendeur_controller.dart';
import 'package:rawaa_app/my_widgets/liste_vide.dart';
import 'package:rawaa_app/styles/constants.dart';

class DisplayGrid extends StatelessWidget {
  const DisplayGrid({super.key});

  @override
  Widget build(BuildContext context) {
    CtrlVendeur ctrl = Get.find();

    if (ctrl.listeFilterVendeur.isEmpty) {
      return const ListeVide();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: ctrl.listeFilterVendeur.length,
      itemBuilder: (context, index) {
        return _vendeurCard(ctrl, index);
      },
    );
  }

  Widget _vendeurCard(CtrlVendeur ctrl, int index) {
    final item = ctrl.listeFilterVendeur[index];
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Constants.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    item.image != null && item.image!.isNotEmpty
                        ? "${Constants.photoUrl}users/${item.image}"
                        : "${Constants.photoUrl}users/${item.userId}.jpg",
                  ),
                  onBackgroundImageError: (exception, stackTrace) {},
                  child: item.username.isNotEmpty
                      ? Text(
                          item.username.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            fontSize: 30,
                            color: Constants.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  item.username,
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
                  item.name,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: _itemFooter(
                        const Icon(Icons.location_on, size: 12),
                        "${Constants.getTitle(item.commune, Constants.lang)}",
                        isCompact: true,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: _itemFooter(
                        const Icon(Icons.phone, size: 12),
                        item.phone,
                        isCompact: true,
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

  Widget _itemFooter(Icon icon, String text, {bool isCompact = false}) {
    return Row(
      mainAxisSize: isCompact ? MainAxisSize.min : MainAxisSize.max,
      children: [
        icon,
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            text,
            style: TextStyle(fontSize: isCompact ? 10 : 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
