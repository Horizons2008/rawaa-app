import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rawaa_app/controller/controller_product.dart';
import 'package:rawaa_app/model/model_product.dart';
import 'package:rawaa_app/my_widgets/custom_button.dart';
import 'package:rawaa_app/my_widgets/outlined_edit.dart';
import 'package:rawaa_app/my_widgets/space_hor.dart';
import 'package:rawaa_app/my_widgets/space_ver.dart';
import 'package:rawaa_app/styles/constants.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key, this.selectedPRoduct});
  final MProduct? selectedPRoduct;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerProducts>(
      builder: (ctrl) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: GetBuilder<ControllerProducts>(
            builder: (ctrl) => Form(
              key: ctrl.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        Text(
                          selectedPRoduct == null
                              ? 'add_new_product'.tr
                              : 'edit_product'.tr,

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            ctrl.clearForm();
                            Get.back();
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    SpaceV(h: 20),
                    // Dropdown to select category
                    Text(
                      'choisir_categorie'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SpaceV(h: 8),
                    DropdownButtonFormField(
                      value: ctrl.selectedCat,
                      items: ctrl.listCat
                          .map<DropdownMenuItem>(
                            (cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(
                                Constants.getTitle(cat.title, Constants.lang),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        ctrl.selectedCat = value;
                        ctrl.update();
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'please_select_category'.tr;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                    SpaceV(h: 50),

                    // Image Selection

                    // Arabic Input
                    OutlinedEdit(
                      hint: 'enter_arabic_title'.tr,
                      label: 'arabic_title'.tr,
                      iconDroite: Icon(Icons.language),
                      controller: ctrl.arabicController,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'arabic_title_required'.tr;
                        }
                        return null;
                      },
                    ),
                    SpaceV(h: 16),

                    // French Input
                    OutlinedEdit(
                      hint: 'enter_french_title'.tr,
                      label: 'french_title'.tr,
                      iconDroite: Icon(Icons.language),
                      controller: ctrl.frenchController,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'french_title_required'.tr;
                        }
                        return null;
                      },
                    ),
                    SpaceV(h: 16),

                    // English Input
                    OutlinedEdit(
                      hint: 'enter_english_title'.tr,
                      label: 'english_title'.tr,
                      iconDroite: Icon(Icons.language),
                      controller: ctrl.englishController,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'english_title_required'.tr;
                        }
                        return null;
                      },
                    ),
                    SpaceV(h: 30),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ctrl.clearForm();
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              fixedSize: Size(100, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'cancel'.tr,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        SpaceH(w: 16),
                        Expanded(
                          child: CustomButton(
                            titre: ctrl.addStatus == ListeStatus.loading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      ),
                                      SpaceH(w: 8),
                                      Text('savring'.tr),
                                    ],
                                  )
                                : Text(
                                    'save'.tr,
                                    style: TextStyle(color: Colors.white),
                                  ),
                            onclick: ctrl.addStatus == ListeStatus.loading
                                ? null
                                : () => ctrl.addProduct(selectedPRoduct?.id),
                          ),
                        ),
                      ],
                    ),
                    SpaceV(h: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
