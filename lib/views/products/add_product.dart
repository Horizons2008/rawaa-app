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
                              : 'modifier produit',

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () => Get.back(),
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
                          return 'Please select a category';
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
                    SpaceV(h: 16),

                    // Image Selection

                    // Arabic Input
                    Text(
                      'Arabic Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SpaceV(h: 8),
                    OutlinedEdit(
                      hint: 'Enter Arabic title',
                      label: 'Arabic Title',
                      iconDroite: Icon(Icons.language),
                      controller: ctrl.arabicController,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Arabic title is required';
                        }
                        return null;
                      },
                    ),
                    SpaceV(h: 16),

                    // French Input
                    Text(
                      'French Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SpaceV(h: 8),
                    OutlinedEdit(
                      hint: 'Enter French title',
                      label: 'French Title',
                      iconDroite: Icon(Icons.language),
                      controller: ctrl.frenchController,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'French title is required';
                        }
                        return null;
                      },
                    ),
                    SpaceV(h: 16),

                    // English Input
                    Text(
                      'English Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SpaceV(h: 8),
                    OutlinedEdit(
                      hint: 'Enter English title',
                      label: 'English Title',
                      iconDroite: Icon(Icons.language),
                      controller: ctrl.englishController,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'English title is required';
                        }
                        return null;
                      },
                    ),
                    SpaceV(h: 30),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            titre: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                            onclick: () {
                              ctrl.clearForm();
                              Get.back();
                            },
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
                                      Text('Saving...'),
                                    ],
                                  )
                                : Text(
                                    'Save Product',
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
