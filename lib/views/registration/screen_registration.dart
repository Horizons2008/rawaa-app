import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/registration_controller.dart';
import 'package:rawaa_app/model/model_commune.dart';
import 'package:rawaa_app/model/model_wilaya.dart';
import 'package:rawaa_app/my_widgets/custom_text.dart';
import 'package:rawaa_app/my_widgets/outlined_edit.dart';
import 'package:rawaa_app/my_widgets/space_ver.dart';
import 'package:rawaa_app/my_widgets/custom_button.dart';
import 'package:rawaa_app/my_widgets/loading.dart';
import 'package:rawaa_app/styles/constants.dart';

class ScreenRegistration extends StatelessWidget {
  const ScreenRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RegistrationController>(
        init: RegistrationController(),
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: controller.registrationKey,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Inscription",
                        size: 25,
                        weight: FontWeight.bold,
                        coul: Colors.black,
                      ),
                      SpaceV(h: 20),

                      // Name Field
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio<int>(
                            value: 0,
                            groupValue: controller.typeCompte,
                            onChanged: (val) {
                              controller.typeCompte = val!;
                              controller.update();
                            },
                          ),
                          Text('Client'),
                          SizedBox(width: 5),
                          Radio<int>(
                            value: 1,
                            groupValue: controller.typeCompte,
                            onChanged: (val) {
                              controller.typeCompte = val!;
                              controller.update();
                            },
                          ),
                          Text('Fournisseur'),
                          SizedBox(width: 5),
                          Radio<int>(
                            value: 2,
                            groupValue: controller.typeCompte,
                            onChanged: (val) {
                              controller.typeCompte = val!;
                              controller.update();
                            },
                          ),
                          Text('Transporter'),
                        ],
                      ),
                      SpaceV(h: 15),
                      OutlinedEdit(
                        hint: "Entrez votre nom",
                        label: "Nom",
                        validation: (p0) {
                          if (p0!.isEmpty) {
                            return "Le nom est obligatoire";
                          } else if (p0.length < 3) {
                            return "Le nom doit contenir au moins 3 caractères";
                          } else {
                            return null;
                          }
                        },
                        iconDroite: Icon(Icons.person),
                        controller: controller.nameController,
                      ),

                      SpaceV(h: 15),
                      OutlinedEdit(
                        hint: "Numero de téléphone",
                        label: "Numéro de téléphone",
                        iconDroite: Icon(Icons.phone),
                        controller: controller.phoneController,
                        dataType: TextInputType.phone,
                        validation: (p0) {
                          if (p0!.isEmpty) {
                            return "N° mobile est obligatoire";
                          } else if (p0.length < 10) {
                            return "N° mobile non valide";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SpaceV(h: 15),
                      OutlinedEdit(
                        hint: "Adresse",
                        label: "Adresse",
                        iconDroite: Icon(Icons.phone),
                        controller: controller.adresseController,
                        dataType: TextInputType.text,
                        validation: (p0) {
                          if (p0!.isEmpty) {
                            return "L'adresse est obligatoire";
                            ;
                          } else if (p0.length < 6) {
                            return "Le nom doit contenir au moins 6 caractères";
                          } else {
                            return null;
                          }
                        },
                      ),

                      SpaceV(h: 15),
                      OutlinedEdit(
                        hint: "Username",
                        label: "Commune",
                        iconDroite: Icon(Icons.phone),
                        controller: controller.usernameController,
                        dataType: TextInputType.phone,
                        validation: (p0) {
                          if (p0!.isEmpty) {
                            return "L'adresse est obligatoire";
                            ;
                          } else if (p0.length < 4) {
                            return "Le nom doit contenir au moins 6 caractères";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SpaceV(h: 15),
                      OutlinedEdit(
                        hint: "Mot de passe",

                        iconDroite: Icon(Icons.phone),
                        controller: controller.passwordController,
                        dataType: TextInputType.text,
                        validation: (p0) {
                          if (p0!.isEmpty) {
                            return "L'adresse est obligatoire";
                            ;
                          } else if (p0.length < 4) {
                            return "Le nom doit contenir au moins 6 caractères";
                          } else {
                            return null;
                          }
                        },
                      ),
                      DropdownButtonFormField<MWilaya>(
                        value: controller.selectedWilaya,
                        decoration: InputDecoration(
                          labelText: "Wilaya",
                          border: OutlineInputBorder(),

                          prefixIcon: Icon(Icons.location_city),
                        ),
                        hint: Text("Sélectionnez une wilaya"),

                        items: controller.listWilaya
                            .map<DropdownMenuItem<MWilaya>>(
                              (wilaya) => DropdownMenuItem<MWilaya>(
                                value: wilaya,
                                child: Text(wilaya.title),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          controller.selectedWilaya = val!;
                          controller.selectedCommune = null;
                          controller.update();
                          controller.getCommune();
                        },
                      ),
                      SpaceV(h: 15),
                      DropdownButtonFormField<MCommune>(
                        value: controller.selectedCommune,
                        decoration: InputDecoration(
                          labelText: "Commune",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        hint: Text("Sélectionnez une commune"),
                        items: controller.listCommune
                            .map<DropdownMenuItem<MCommune>>(
                              (commune) => DropdownMenuItem<MCommune>(
                                value: commune,
                                child: Text(commune.title),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          controller.selectedCommune = val!;
                          controller.update();
                        },
                      ),

                      SpaceV(h: 15),

                      // Send OTP Button

                      // OTP Field (only show when OTP is sent)

                      // Location Section
                      CustomText(
                        text: "Localisation actuelle",
                        size: 15,
                        weight: FontWeight.bold,
                        coul: Colors.black,
                      ),
                      SpaceV(h: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        controller.currentLocation.value.isEmpty
                                            ? "Obtenir la localisation..."
                                            : controller.currentLocation.value,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.locationPermissionGranted.value
                                  ? controller.getCurrentLocation
                                  : controller.checkLocationPermission;
                            },
                            icon: Icon(Icons.refresh, color: Colors.blue),
                          ),
                        ],
                      ),
                      SpaceV(h: 10),

                      // Refresh Location Button

                      // Complete Registration Button
                      CustomButton(
                        titre: controller.statusStore == ListeStatus.loading
                            ? CircularProgressIndicator()
                            : CustomText(
                                text: "Terminer l'inscription",
                                size: 14,
                                weight: FontWeight.w500,
                                coul: Colors.white,
                              ),
                        onclick: () {
                          controller.store();
                        },
                        //isLoading: controller.isLoading.value,
                      ),

                      // Loading indicator
                      Obx(
                        () => controller.isLoading.value
                            ? Padding(
                                padding: EdgeInsets.all(20),
                                child: WidgetLoading(),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
