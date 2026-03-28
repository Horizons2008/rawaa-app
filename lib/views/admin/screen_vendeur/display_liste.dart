import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/admin/vendeur_controller.dart';
import 'package:rawaa_app/styles/constants.dart';

class DisplayListe extends StatelessWidget {
  const DisplayListe({super.key});

  @override
  Widget build(BuildContext context) {
    CtrlVendeur ctrl = Get.find();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: ctrl.listeFilterVendeur.length,
      itemBuilder: (context, index) {
        final item = ctrl.listeFilterVendeur[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 20),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Text(
                    item.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(item.name),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      item.image != null && item.image!.isNotEmpty
                          ? "${Constants.photoUrl}users/${item.image}"
                          : "${Constants.photoUrl}users/${item.userId}.jpg",
                    ),
                    onBackgroundImageError: (exception, stackTrace) {},
                    child: item.username.isNotEmpty
                        ? Text(
                            item.username.substring(0, 1).toUpperCase(),
                            style: const TextStyle(color: Colors.black),
                          )
                        : null,
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _itemFooter(
                      const Icon(Icons.location_on, size: 15),
                      "${Constants.getTitle(item.commune, Constants.lang)} [${Constants.getTitle(item.wilaya, Constants.lang)}]",
                    ),
                    _itemFooter(const Icon(Icons.phone, size: 15), item.phone),
                    _itemFooter(
                      const Icon(Icons.circle, size: 15),
                      item.status,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _itemFooter(Icon icon, String text) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 3),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
