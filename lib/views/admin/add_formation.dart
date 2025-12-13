import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rawaa_app/controller/admin/contr_form.dart';
import 'package:rawaa_app/my_widgets/outlined_edit.dart';
import 'package:rawaa_app/my_widgets/space_ver.dart';
import 'package:rawaa_app/styles/constants.dart';

class AddFormationScreen extends StatelessWidget {
  AddFormationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // INSERT_YOUR_CODE
    final ctrl = Get.put(FormationController());
    final isUpdate = ctrl.selectedFormation != null;
    final String title = isUpdate
        ? 'update_formation'.tr
        : 'add_new_formation'.tr;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: GetBuilder<FormationController>(
        init: FormationController(),
        builder: (ctrl) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: ctrl.storeFormationKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Upload Course Image Section
                  _buildImageUploadSection(ctrl),

                  const SizedBox(height: 16),
                  _buildFileUploadButton(ctrl),

                  // Course Title
                  const SizedBox(height: 8),
                  OutlinedEdit(
                    controller: ctrl.titleController,
                    hint: 'titre_formation'.tr,
                    validation: (p0) {
                      if (p0!.isEmpty) {
                        return 'champ_obligatoire'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Description
                  _buildSectionTitle('description'.tr),
                  const SizedBox(height: 8),
                  _buildDescriptionField(),
                  const SizedBox(height: 8),
                  OutlinedEdit(
                    controller: ctrl.priceController,
                    hint: 'prix'.tr,
                    dataType: TextInputType.number,
                    validation: (p0) {
                      if ((p0!.isEmpty) && (ctrl.type == true)) {
                        return 'champ_obligatoire'.tr;
                      } else if ((double.tryParse(p0) == null) &&
                          (ctrl.type == true)) {
                        return 'Veuillez entrer un nombre valide';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),
                  OutlinedEdit(
                    controller: ctrl.formateurController,
                    hint: 'formatteur'.tr,
                    validation: (p0) {
                      if (p0!.isEmpty) {
                        return 'champ_obligatoire'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Formation Mode
                  _buildSectionTitle('type_formation'.tr),
                  const SizedBox(height: 12),
                  _buildModeSelection(),
                  const SizedBox(height: 24),

                  // Date
                  ctrl.isOnline == true
                      ? _buildSectionTitle('date'.tr)
                      : Container(),
                  ctrl.isOnline == true ? _buildDateSelection() : Container(),

                  ctrl.isOnline == true
                      ? const SizedBox(height: 15)
                      : SizedBox(),

                  // Location
                  ctrl.isOnline == true ? _buildTimeSelection() : Container(),

                  ctrl.isOnline == false
                      ? _buildSectionTitle('duree_formation'.tr)
                      : Container(),

                  // INSERT_YOUR_CODE
                  ctrl.isOnline != false
                      ? Container()
                      : Row(
                          children: [
                            // Hours input
                            Expanded(
                              child: OutlinedEdit(
                                hint: 'heure'.tr,
                                controller: ctrl.heureController,
                                dataType: TextInputType.number,
                                validation: (p0) {
                                  if ((ctrl.isOnline == false) &&
                                      (p0!.isEmpty)) {
                                    return 'champ Obligatoire';
                                  } else if ((ctrl.isOnline == false) &&
                                      (int.tryParse(p0!) == null)) {
                                    return 'valeur_non_valide'.tr;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Minutes input
                            Expanded(
                              child: OutlinedEdit(
                                hint: 'minute'.tr,
                                controller: ctrl.minuteController,
                                dataType: TextInputType.number,
                                validation: (p0) {
                                  if ((ctrl.isOnline == false) &&
                                      (p0!.isEmpty)) {
                                    return 'champ_obligatoire'.tr;
                                  } else if ((ctrl.isOnline == false) &&
                                      (int.tryParse(p0!) == null)) {
                                    return 'valeur_non_valide'.tr;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                  SpaceV(h: 15),

                  // Save Button
                  _buildSaveButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildImageUploadSection(FormationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade50,
          ),
          child: controller.imagePath.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(controller.imagePath),
                    fit: BoxFit.cover,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 40,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'upload_image'.tr,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
        ),

        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: _showImageSourceDialog,
            icon: const Icon(Icons.upload, size: 18),
            label: Text('upload'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadButton(FormationController controller) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: controller.openUploadBottomSheet,
        icon: const Icon(Icons.attach_file),
        label: const Text('Manage Files'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    FormationController controller = Get.find();
    return TextFormField(
      controller: controller.descriptionController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'description_objectif_formation'.tr,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildModeSelection() {
    FormationController controller = Get.find();
    return Row(
      children: [
        Expanded(
          child: _buildModeChip(
            'online'.tr,
            Icons.computer,
            controller.isOnline,
            () {
              controller.isOnline = true;
              controller.update();
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildModeChip(
            'offline'.tr,
            Icons.business,
            !controller.isOnline,
            () {
              controller.isOnline = (false);
              controller.update();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModeChip(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.blue.shade50 : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelection() {
    FormationController controller = Get.find();
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                controller.date != null
                    ? '${controller.date!.month}/${controller.date!.day}/${controller.date!.year}'
                    : 'mm/dd/yyyy',
                style: TextStyle(
                  color: controller.date != null ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelection() {
    FormationController controller = Get.find();
    return Row(
      children: [
        Expanded(
          child: _buildTimeField(
            'temps_debut'.tr,
            controller.startTime,
            _selectStartTime,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTimeField(
            'temps_fin'.tr,
            controller.endTime,
            _selectEndTime,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(String label, TimeOfDay? time, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    time != null
                        ? '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}'
                        : '---',
                    style: TextStyle(
                      color: time != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return GetBuilder<FormationController>(
      builder: (ctrl) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: ctrl.addStatus == ListeStatus.loading
                ? null
                : ctrl.addFormation,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: ctrl.addStatus == ListeStatus.loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'save'.tr,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        );
      },
    );
  }

  void _showImageSourceDialog() {
    FormationController controller = Get.find();
    Get.dialog(
      AlertDialog(
        title: const Text('Upload Image'),
        content: const Text('Choose image source'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              // Simulate network image URL
              controller.setImageUrl(
                'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=400&h=200&fit=crop',
              );
            },
            child: const Text('From URL'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Open the device gallery to pick an image (requires image_picker package)
              // This is a simple pick-from-gallery logic

              final ImagePicker _picker = ImagePicker();
              _picker.pickImage(source: ImageSource.gallery).then((pickedFile) {
                if (pickedFile != null) {
                  controller.setImageUrl(pickedFile.path);
                  controller.update();
                }
              });
              // Here you would implement camera/gallery picker
            },
            child: const Text('Gallery'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    FormationController controller = Get.find();
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.date = picked;
      controller.update();
    }
  }

  Future<void> _selectStartTime() async {
    FormationController controller = Get.find();
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.startTime = (picked);
      controller.update();
    }
  }

  Future<void> _selectEndTime() async {
    FormationController controller = Get.find();
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.endTime = (picked);
      controller.update();
    }
  }
}
