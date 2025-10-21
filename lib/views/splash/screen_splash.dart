import 'package:rawaa_app/my_widgets/custom_text.dart';
import 'package:rawaa_app/my_widgets/space_ver.dart';
import 'package:rawaa_app/styles/constants.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/splash_controller.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ContSplash>(
        init: ContSplash(),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.asset('assets/images/splash.jpg'),
                        ),
                        SpaceV(h: 20),
                        CustomText(
                          text: "rawaa_app",
                          size: 22,
                          weight: FontWeight.w800,
                          coul: Colors.black,
                        ),
                        // SpaceV(h: 10),
                        CustomText(
                          text: "System Gestion Magasin",
                          size: 14,
                          weight: FontWeight.w400,
                          coul: Colors.grey,
                        ),
                        SpaceV(h: 200),
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Constants.primaryColor,
                            backgroundColor: Constants.primaryColor.withValues(
                              alpha: 0.3,
                            ),
                            strokeWidth: 3,
                          ),
                        ),
                        SpaceV(h: 10),
                        CustomText(
                          text: "Chargement ...",
                          size: 14,
                          weight: FontWeight.w400,
                          coul: Colors.grey,
                        ),
                        SpaceV(h: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
