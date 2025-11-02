import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rawaa_app/controller/controller_categories.dart';
import 'package:rawaa_app/model/model_categorie.dart';
import 'package:rawaa_app/my_widgets/custom_button.dart';
import 'package:rawaa_app/my_widgets/outlined_edit.dart';
import 'package:rawaa_app/my_widgets/space_hor.dart';
import 'package:rawaa_app/my_widgets/space_ver.dart';
import 'package:rawaa_app/styles/constants.dart';

class AddCategorie extends StatelessWidget {
  const AddCategorie({super.key, required this.selectedCat});
  final MCat? selectedCat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: GetBuilder<ControllerCategories>(
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
                      selectedCat == null
                          ? 'add_new_category'.tr
                          : "update_cat",
                      style: TextStyle(
                        fontSize: 20,
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

                // Image Selection
                Text(
                  'category_image'.tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SpaceV(h: 10),
                GestureDetector(
                  onTap: () => ctrl.pickImageFromGallery(),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ctrl.selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              ctrl.selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : selectedCat != null
                        ? Image.network(
                            '${Constants.photoUrl}categorie/${selectedCat?.id}.jpg',
                            errorBuilder: (context, error, stackTrace) {
                              return Center(child: Icon(Icons.error));
                            },
                            fit: BoxFit.cover,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 50,
                                color: Colors.grey[400],
                              ),
                              SpaceV(h: 10),
                              Text(
                                'Tap to select image',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                SpaceV(h: 20),

                // Arabic Input
                Text(
                  'Nom Arab',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  'Nom Français',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SpaceV(h: 8),
                OutlinedEdit(
                  hint: 'Nom',
                  label: 'French Title',
                  iconDroite: Icon(Icons.language),
                  controller: ctrl.frenchController,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Champ obligatoire';
                    }
                    return null;
                  },
                ),
                SpaceV(h: 16),

                // English Input
                Text(
                  'Nom Anglais',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SpaceV(h: 8),
                OutlinedEdit(
                  hint: 'Nom Anglais',
                  label: 'English Title',
                  iconDroite: Icon(Icons.language),
                  controller: ctrl.englishController,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'champ obligatoire';
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
                          'Annuler',
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  SpaceH(w: 8),
                                  Text('Saving...'),
                                ],
                              )
                            : selectedCat == null
                            ? Text(
                                'Ajouter',
                                style: TextStyle(color: Colors.white),
                              )
                            : Text(
                                'Modifier',
                                style: TextStyle(color: Colors.white),
                              ),
                        onclick: ctrl.addStatus == ListeStatus.loading
                            ? null
                            : () => ctrl.addCategory(selectedCat?.id),
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
  }
}
