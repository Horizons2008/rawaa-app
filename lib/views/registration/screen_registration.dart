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
      appBar: AppBar(
        title: CustomText(
          text: "registration".tr,
          size: 25,
          weight: FontWeight.bold,
          coul: Colors.black,
        ),
      ),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpaceV(h: 10),

                      // Account Type Selection
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildChoiceChip(
                              label: 'client'.tr,
                              value: 0,
                              controller: controller,
                            ),
                            SizedBox(width: 10),
                            _buildChoiceChip(
                              label: 'vendeur'.tr,
                              value: 1,
                              controller: controller,
                            ),
                            SizedBox(width: 10),
                            _buildChoiceChip(
                              label: 'livreur'.tr,
                              value: 2,
                              controller: controller,
                            ),
                          ],
                        ),
                      ),
                      SpaceV(h: 15),

                      OutlinedEdit(
                        hint: "num_mobile".tr,
                        label: "num_mobile".tr,
                        iconDroite: Icon(Icons.phone),
                        controller: controller.phoneController,
                        dataType: TextInputType.phone,
                        validation: (p0) {
                          if (p0!.isEmpty) {
                            return "N° mobile est obligatoire";
                          } else if (p0.length < 10) {
                            return "N° mobile non valide";
                          } else if (!RegExp(r'^[0-9+\-\s]+$').hasMatch(p0)) {
                            return "Format de numéro invalide";
                          }
                          return null;
                        },
                        onChange: (value) {
                          // Trigger async phone validation when user stops typing
                          if (value.isNotEmpty && value.length >= 10) {
                            Future.delayed(Duration(milliseconds: 500), () {
                              if (controller.phoneController.text == value) {
                                controller.validatePhoneAsync(value);
                              }
                            });
                          }
                        },
                      ),
                      SpaceV(h: 5),

                      // Phone validation status indicator
                      GetBuilder<RegistrationController>(
                        builder: (controller) {
                          if (controller.statusPhone == ListeStatus.loading) {
                            return Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "verification_phone".tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            );
                          } else if (controller.statusPhone ==
                              ListeStatus.success) {
                            return Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "num_mobile_disponible".tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            );
                          } else if (controller.statusPhone ==
                              ListeStatus.error) {
                            return Row(
                              children: [
                                Icon(Icons.error, color: Colors.red, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  "num_mobile_existe".tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),

                      SpaceV(h: 15),
                      OutlinedEdit(
                        hint: "username".tr,

                        iconDroite: Icon(Icons.person),
                        controller: controller.usernameController,
                        dataType: TextInputType.text,
                        validation: (p0) {
                          if (p0!.isEmpty) {
                            return "champ_obligatoire".tr;
                          }
                          if (p0.length < 3) {
                            return "Le nom d'utilisateur doit contenir au moins 3 caractères";
                          }
                          if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(p0)) {
                            return "Le nom d'utilisateur ne peut contenir que des lettres, chiffres et underscores";
                          }
                          return null;
                        },
                        onChange: (value) {
                          // Trigger async username validation when user stops typing
                          if (value.isNotEmpty && value.length >= 3) {
                            Future.delayed(Duration(milliseconds: 500), () {
                              if (controller.usernameController.text == value) {
                                controller.validateUsernameAsync(value);
                              }
                            });
                          }
                        },
                      ),
                      SpaceV(h: 5),

                      // Username validation status indicator
                      GetBuilder<RegistrationController>(
                        builder: (controller) {
                          if (controller.statusUsername ==
                              ListeStatus.loading) {
                            return Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "verification_username".tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            );
                          } else if (controller.statusUsername ==
                              ListeStatus.success) {
                            return Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "username_disponible".tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            );
                          } else if (controller.statusUsername ==
                              ListeStatus.error) {
                            return Row(
                              children: [
                                Icon(Icons.error, color: Colors.red, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  "username_existe".tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),
                      SpaceV(h: 15),
                      OutlinedEdit(
                        hint: "password".tr,

                        iconDroite: Icon(Icons.lock),
                        controller: controller.passwordController,
                        dataType: TextInputType.text,
                        validation: (p0) {
                          if (p0!.isEmpty) {
                            return "champ_obligatoire".tr;
                            ;
                          } else if (p0.length < 6) {
                            return "Le mot de passe  doit contenir au moins 6 caractères";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SpaceV(h: 15),

                      DropdownButtonFormField<MWilaya>(
                        value: controller.selectedWilaya,
                        decoration: InputDecoration(
                          labelText: "wilaya".tr,
                          border: OutlineInputBorder(),

                          prefixIcon: Icon(Icons.location_city),
                        ),
                        hint: Text("select_wilaya".tr),

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
                          labelText: "commune".tr,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        hint: Text("select_commune".tr),
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
                        text: "position_gps".tr,
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
                                    Icon(
                                      Icons.location_on,
                                      color: Constants.primaryColor,
                                    ),
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
                              controller.openLocationPicker();
                            },
                            icon: Icon(Icons.refresh, color: Colors.blue),
                            tooltip: 'Sélectionner sur la carte',
                          ),
                        ],
                      ),
                      SpaceV(h: 45),

                      // Refresh Location Button

                      // Complete Registration Button
                      CustomButton(
                        titre: controller.statusStore == ListeStatus.loading
                            ? CircularProgressIndicator()
                            : CustomText(
                                text: "valider".tr,
                                size: 18,
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

  Widget _buildChoiceChip({
    required String label,
    required int value,
    required RegistrationController controller,
  }) {
    bool isSelected = controller.typeCompte == value;
    return ChoiceChip(
      checkmarkColor: Colors.white,
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        controller.typeCompte = value;
        controller.update();
      },
      selectedColor: Constants.primaryColor,
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Constants.primaryColor : Colors.grey[300]!,
        ),
      ),
      elevation: isSelected ? 2 : 0,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
