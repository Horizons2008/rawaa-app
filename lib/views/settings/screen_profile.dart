import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:rawaa_app/controller/settings_controller.dart';
import 'package:rawaa_app/my_widgets/outlined_edit.dart';
import 'package:rawaa_app/styles/constants.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit_profile'.tr),
        actions: [
          controller.isUpdating.value
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: controller.saveProfile,
                ),
        ],
      ),
      body: GetBuilder<SettingsController>(
        init: SettingsController(),
        builder: (ctrl) {
          return controller.statusLoadProfile == ListeStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : GetBuilder<SettingsController>(
                  builder: (ctrl) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Profile Photo Section
                          _buildProfilePhotoSection(),
                          const SizedBox(height: 32),
                          OutlinedEdit(
                            hint: "nom".tr,
                            controller: ctrl.nameController,
                          ),

                          const SizedBox(height: 32),
                          OutlinedEdit(
                            hint: "phone_number".tr,
                            controller: ctrl.phoneController,
                          ),
                          const SizedBox(height: 32),
                          OutlinedEdit(
                            hint: "current_location".tr,
                            controller: ctrl.locationController,
                          ),
                          const SizedBox(height: 50),

                          // Name Field
                          /*   _buildNameField(),
                    const SizedBox(height: 16),

                    // Email Field
                    _buildEmailField(),
                    const SizedBox(height: 16),

                    // Address Field
                    _buildAddressField(),
                    const SizedBox(height: 16),

                    // Location Section
                    _buildLocationSection(),
                    const SizedBox(height: 32),*/

                          // Action Buttons
                          _buildActionButtons(),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  Widget _buildProfilePhotoSection() {
    return GetBuilder<SettingsController>(
      builder: (ctrl) {
        return Column(
          children: [
            Stack(
              children: [
                ctrl.profileImagePath.isNotEmpty
                    ? CircleAvatar(
                        radius: 75,
                        backgroundImage: FileImage(File(ctrl.profileImagePath)),
                      )
                    : ClipOval(
                        child: Image.network(
                          "${Constants.photoUrl}/users/${Constants.currentUser!.id}.jpg",
                          width: 150,
                          height: 150,

                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.blue,
                            );
                          },
                        ),
                      ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: _showImagePickerDialog,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'photo_profile'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      },
    );
  }

  /*
  Widget _buildNameField() {
    return TextField(
      controller: TextEditingController(text: controller.name.value),
      onChanged: controller.updateName,
      decoration: const InputDecoration(
        labelText: 'Full Name',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: TextEditingController(text: controller.email.value),
      onChanged: controller.updateEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email Address',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildAddressField() {
    return TextField(
      controller: TextEditingController(text: controller.address.value),
      onChanged: controller.updateAddress,
      maxLines: 2,
      decoration: const InputDecoration(
        labelText: 'Address',
        prefixIcon: Icon(Icons.home),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Card(
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(controller.location.value),
              trailing: IconButton(
                icon: const Icon(Icons.gps_fixed),
                onPressed: controller.getCurrentLocation,
              ),
              onTap: _showLocationDialog,
            ),
          ),
        ),
      ],
    );
  }
*/
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: controller.clearProfile,
            child: Text('effacer'.tr),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.isUpdating.value
                  ? Colors.grey
                  : Constants.primaryColor,
            ),
            onPressed: controller.isUpdating.value
                ? null
                : controller.saveProfile,
            child: Text(
              'Valider'.tr,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePickerDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Choose Option'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                controller.pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                controller.captureImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  /*void _showLocationDialog() {
    final locationController = TextEditingController(
      text: controller.location.value,
    );

    Get.dialog(
      AlertDialog(
        title: const Text('Enter Location'),
        content: TextField(
          controller: locationController,
          decoration: const InputDecoration(
            hintText: 'Enter your location',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (locationController.text.isNotEmpty) {
                controller.updateLocation(locationController.text);
                Get.back();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
*/
}
