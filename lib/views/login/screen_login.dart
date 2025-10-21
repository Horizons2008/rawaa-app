import 'package:rawaa_app/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/login_controller.dart';
import 'package:rawaa_app/my_widgets/custom_button.dart';
import 'package:rawaa_app/my_widgets/custom_text.dart';
import 'package:rawaa_app/my_widgets/outlined_edit.dart';
import 'package:rawaa_app/my_widgets/space_ver.dart';
import 'package:rawaa_app/styles/my_color.dart';
import 'package:rawaa_app/views/registration/screen_registration.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.grey, // Softer background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 1,
              color: Colors.white,

              // constraints: BoxConstraints(maxWidth: 600),
              padding: EdgeInsets.all(20),
              child: GetBuilder<CtrlLogin>(
                init: CtrlLogin(),
                builder: (ctrl) {
                  return Form(
                    key: ctrl.loginKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo/Image Section
                        SpaceV(h: 40),
                        Image.asset(
                          'assets/images/splash.jpg', // Replace with your image path
                          height: 120,
                          width: 120,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(height: 30),

                        // Welcome Text
                        Text(
                          "Bienvenue!",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Veuillez connecter pour continuer",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 30),

                        // Username Field
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Nom Utilisateur",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        OutlinedEdit(
                          controller: ctrl.contUsername,
                          errorText: ctrl.errorLogin,
                          validation: (v) {
                            if ((v == null) || (v.isEmpty)) {
                              return "Champs Obligatoire";
                            }
                            return ctrl.errorLogin;
                          },
                        ),
                        SizedBox(height: 20),

                        // Password Field
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Mot de passe",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        OutlinedEdit(
                          controller: ctrl.contpassword,
                          showPass: ctrl.showPassword,
                          iconDroite: InkWell(
                            onTap: () {
                              ctrl.switchPassword();
                            },
                            child: Icon(
                              ctrl.showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                          validation: (v) {
                            if ((v == null) || (v.isEmpty)) {
                              return "Champs Obligatoire";
                            }
                            return null;
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Add forgot password functionality
                            },
                            child: Text(
                              "Mot de passe oublié?",
                              style: TextStyle(
                                color: MyColor.primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        SpaceV(h: 30),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: CustomButton(
                            titre: ctrl.status != ListeStatus.loading
                                ? Text(
                                    "Se connecter",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  )
                                : CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                            onclick: () {
                              ctrl.checkLogin();
                            },
                          ),
                        ),

                        // Forgot Password? (Optional)
                        Spacer(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "Jai pas un compte ? ",
                              size: 16,
                              weight: FontWeight.normal,
                              coul: Colors.black,
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(ScreenRegistration());
                              },
                              child: CustomText(
                                text: "s'Inscrire",
                                size: 14,
                                weight: FontWeight.w600,
                                coul: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
