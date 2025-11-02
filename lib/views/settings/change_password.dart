import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/password_controller.dart';
import 'package:rawaa_app/controller/settings_controller.dart';
import 'package:rawaa_app/my_widgets/custom_text.dart';
import 'package:rawaa_app/my_widgets/outlined_edit.dart';
import 'package:rawaa_app/my_widgets/space_ver.dart';
import 'package:rawaa_app/styles/constants.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.passwordkey,
            child: Column(
              children: [
                // Old Password Field
                SpaceV(h: 15),
                CustomText(
                  text: "changer_password".tr,
                  size: 18,
                  weight: FontWeight.w600,
                  coul: Colors.black,
                ),
                SpaceV(h: 35),
                OutlinedEdit(
                  controller: controller.oldPasswordController,
                  hint: "old_password".tr,
                  errorText: controller.msgError,
                  validation: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Veuillez entrer votre ancien mot de passe";
                    }
                    return controller.msgError;
                  },
                ),

                const SizedBox(height: 16),

                // New Password Field
                OutlinedEdit(
                  controller: controller.newPasswordController,
                  hint: "new_password".tr,
                  validation: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Veuillez entrer votre nouveau mot de passe";
                    } else if (controller.confirmPasswordController.text !=
                        controller.newPasswordController.text) {
                      return "Les mots de passe ne correspondent pas";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Confirm Password Field
                OutlinedEdit(
                  controller: controller.confirmPasswordController,
                  hint: "confirm_password".tr,
                  validation: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Veuillez confirmer votre nouveau mot de passe";
                    } else if (controller.confirmPasswordController.text !=
                        controller.newPasswordController.text) {
                      return "Les mots de passe ne correspondent pas";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Change Password Button
                ElevatedButton(
                  onPressed:
                      controller.statusChangePassword == ListeStatus.loading
                      ? null
                      : controller.changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.primaryColor,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: controller.statusChangePassword == ListeStatus.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Valider'.tr,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
