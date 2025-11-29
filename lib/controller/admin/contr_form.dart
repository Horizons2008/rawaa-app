import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rawaa_app/model/model_formation.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:dio/dio.dart';

class FormationController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController formateurController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController heureController = TextEditingController();
  TextEditingController minuteController = TextEditingController();

  bool isOnline = false;
  // INSERT_YOUR_CODE
  final GlobalKey<FormState> storeFormationKey = GlobalKey<FormState>();
  bool type = true;
  List<MFormation> formations = [];
  MFormation? selectedFormation;

  // Observable for loading state
  ListeStatus addStatus = ListeStatus.none;
  ListeStatus loadFormationStatus = ListeStatus.none;

  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  Duration? duration;
  String imagePath = "";
  String recusPath = "";

  @override
  void onInit() {
    super.onInit();

    // TODO: implement
    fetchFormation();
  }

  deleteFormation(MFormation course) async {
    await Constants.reposit.repDeleteFormation(course.id).then((value) {
      if (value['status'] == 'success') {
        Get.back();
        formations.removeWhere((formation) => formation.id == course.id);

        Constants.showSnackBar(
          'confirmation'.tr,
          'Formation Supprimée avec succès'.tr,
        );
        update();
      }
    });
  }

  editFormation(MFormation formation) async {
    selectedFormation = formation;
    titleController.text = formation.title;
    formateurController.text = formation.instructor!;
    descriptionController.text = formation.description;
    priceController.text = formation.price.toString();
    formation.isOnline == true
        ? {
            date = formation.date,
            startTime = formation.startTime,
            endTime = formation.endTime,
            duration = formation.duration,
            isOnline = true,
          }
        : {
            isOnline = false,
            heureController.text = formation.duration!.inHours.toString(),
            minuteController.text = formation.duration!.inMinutes
                .remainder(60)
                .toString(),
          };

    // Download image from URL and save to file
    await downloadImageFromUrl(formation.id);

    update();
  }

  Future<void> downloadImageFromUrl(int formationId) async {
    try {
      final imageUrl = '${Constants.photoUrl}formation/$formationId.jpg';
      final dio = Dio();

      // Get system temp directory
      final tempDir = Directory.systemTemp;
      final filePath = '${tempDir.path}/formation_$formationId.jpg';

      // Download the image
      await dio.download(imageUrl, filePath);

      // Check if file exists and set imagePath
      final file = File(filePath);
      if (await file.exists()) {
        imagePath = filePath;
        update();
      } else {
        imagePath = '';
        update();
      }
    } catch (e) {
      print('Error downloading image: $e');
      // If download fails, set imagePath to empty
      imagePath = '';
      update();
    }
  }

  void setImageUrl(String url) {
    imagePath = url;
  }

  Future<void> pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
    );
    if (picked != null) {
      recusPath = picked.path;
      update();
    }
  }

  Future<void> fetchFormation() async {
    loadFormationStatus = ListeStatus.loading;
    update();
    await Constants.reposit.repGetAllFormation().then((onValue) {
      loadFormationStatus = ListeStatus.success;
      formations = onValue['data']
          .map<MFormation>((e) => MFormation.fromMap(e))
          .toList();
      update();
    });
  }

  void addFormation() async {
    if (storeFormationKey.currentState!.validate()) {
      addStatus = ListeStatus.loading;
      update();

      final data = ({
        "id": selectedFormation?.id,
        "title": titleController.text,
        "description": descriptionController.text,
        "price": priceController.text,
        "is_online": isOnline == true ? 1 : 0,
        "date": date,
        "time_start": isOnline == true
            ? "${startTime!.hour}:${startTime!.minute}"
            : null,
        "time_end": isOnline == true
            ? "${endTime!.hour}:${endTime!.minute}"
            : null,
        "duration": "${heureController.text}:${minuteController.text}",

        "prof_name": formateurController.text,
        "type": "gratuit",
      });

      await Constants.reposit
          .repStoreFormation(
            data,
            imagePath.isNotEmpty ? File(imagePath) : null,
          )
          .then((value) {
            print("sssssssssssssssssssssssssssssssss $value");
            addStatus = ListeStatus.success;
            update();
          });
      Get.back();
      fetchFormation();
      Constants.showSnackBar("confirmation", "Formation ajoutée avec succès");
      resetForm();
    } else {
      addStatus = ListeStatus.error;
      update();
    }

    // formations.add(newFormation);
    // resetForm();
    // Get.back();
  }

  void storeAchat(int id) async {
    MFormation formation = formations.firstWhere((element) => element.id == id);

    Map<String, dynamic> data = {
      "formation_id": formation.id,
      "pric": formation.price,
    };
    await Constants.reposit
        .repStoreAchat(data, File(recusPath))
        .then((value) {});
  }

  void resetForm() {
    titleController.text = '';
    descriptionController.text = '';
    priceController.text = '';
    formateurController.text = '';
    heureController.text = '';
    minuteController.text = '';
    isOnline = true;
    date = null;
    startTime = null;
    endTime = null;
    imagePath = '';
    selectedFormation = null;
  }

  void updateFormation(MFormation updatedFormation) {
    final index = formations.indexWhere((f) => f.id == updatedFormation.id);
    if (index != -1) {
      formations[index] = updatedFormation;
    }
  }
}
