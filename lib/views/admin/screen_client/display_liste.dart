import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:rawaa_app/controller/admin/client_controller.dart';
import 'package:rawaa_app/styles/constants.dart';

class DisplayListe extends StatelessWidget {
  const DisplayListe({super.key});

  @override
  Widget build(BuildContext context) {
    CtrlClient ctrl = Get.find();
    return ListView.builder(
      itemCount: ctrl.listeFilterClietns.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                  title: Text(ctrl.listeFilterClietns[index].username),

                  subtitle: Text(ctrl.listeFilterClietns[index].name),

                  leading: CircleAvatar(
                    radius: 30,
                    child: Image.network(
                      "${Constants.photoUrl}users/${ctrl.listeFilterClietns[index].userId}.jpg",
                      errorBuilder: (context, error, stackTrace) {
                        return Text(
                          ctrl.listeFilterClietns[index].username.substring(
                            0,
                            1,
                          ),
                          style: TextStyle(color: Colors.black),
                        );
                      },
                    ),
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    itemFooter(
                      Icon(Icons.location_on, size: 15),
                      "${Constants.getTitle(ctrl.listeFilterClietns[index].commune, Constants.lang)} [${Constants.getTitle(ctrl.listeFilterClietns[index].wilaya, Constants.lang)}] ",
                    ),
                    itemFooter(
                      Icon(Icons.phone, size: 15),
                      ctrl.listeFilterClietns[index].phone,
                    ),
                    itemFooter(
                      Icon(Icons.circle, size: 15),
                      ctrl.listeFilterClietns[index].status,
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
  Widget itemFooter(Icon icon, String text) {
    return Row(
      children: [
        icon,
        SizedBox(width: 3),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
