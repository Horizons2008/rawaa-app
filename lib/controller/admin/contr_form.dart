import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rawaa_app/model/model_formation.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:dio/dio.dart';

class FileUploadModel {
  File file;
  String name;
  double progress;
  bool isUploading;
  bool isCompleted;
  String? serverPath;

  FileUploadModel({
    required this.file,
    required this.name,
    this.progress = 0.0,
    this.isUploading = false,
    this.isCompleted = false,
    this.serverPath,
  });
}

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
  File? documentFile;

  String recusPath = "";

  // Upload variables
  List<FileUploadModel> uploadedFiles = [];
  double uploadProgress = 0.0;
  bool isUploading = false;
  String? uploadedFileName;

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
    List<String> playlist = formation.playlist;
    for (var element in playlist) {
      uploadedFiles.add(FileUploadModel(file: File(element), name: element));
    }

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
      print('ppppppppppppppppppppppppppppppppppppp $onValue');
      loadFormationStatus = ListeStatus.success;
      formations = onValue['data']
          .map<MFormation>((e) => MFormation.fromMap(e))
          .toList();
          

      update();
    });
  }

  void addFormation() async {
    String playList = "";

    if (uploadedFiles.isNotEmpty) {
      playList = uploadedFiles.map((file) => file.serverPath).join(",");
    }
    print('playListxxxxxxxxxxxxxxxxxxxxxxxxxx  $playList');

    if (storeFormationKey.currentState!.validate()) {
      addStatus = ListeStatus.loading;
      update();
      String playList = "";
      if (uploadedFiles.isNotEmpty) {
        playList = uploadedFiles.map((file) => file.serverPath).join(",");
      }

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
        "playlist": playList,
      });

      Constants.reposit
          .repStoreFormation(
            data,
            imagePath.isNotEmpty ? File(imagePath) : null,
            document: documentFile,
            onSendProgress: (sent, total) {
              if (documentFile != null) {
                uploadProgress = sent / total;
                isUploading = true;
                update();
              }
            },
          )
          .then((value) {
            if (value['status'] == 'success') {
              Get.back();
              addStatus = ListeStatus.success;
              isUploading = false;
              Constants.showSnackBar(
                "confirmation",
                "Formation ajoutée avec 12",
              );
              resetForm();
              fetchFormation();

              update();
            }

            if (documentFile != null) {
              Get.back();
              // Close BottomSheet if it was open
            }
          });
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
    await Constants.reposit.repStoreAchat(data, File(recusPath)).then((value) {
      if (value['status'] == 'success') {
        Get.back();
        fetchFormation();
        Constants.showSnackBar("confirmation", "Achat effectué avec succès");
        update();
      }
    });
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

  Future<void> pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;

      FileUploadModel fileModel = FileUploadModel(
        file: file,
        name: fileName,
        isUploading: true,
      );

      uploadedFiles.add(fileModel);
      update();

      // Start Upload
      await Constants.reposit
          .repUploadFile(file, (sent, total) {
            fileModel.progress = sent / total;
            update();
          })
          .then((value) {
            print("111111111111111111111111111111111 $value");
            fileModel.isUploading = false;
            fileModel.isCompleted = true;
            fileModel.serverPath =
                value['path']; // Adjust based on API response
            update();
          })
          .catchError((e) {
            print("2222222222 $e");

            fileModel.isUploading = false;
            // Handle error
            update();
          });
    }
  }

  void deleteFile(int index) {
    Constants.reposit
        .repRemoveFile({"fileName": uploadedFiles[index].serverPath})
        .then((value) {
          print("value $value");
          uploadedFiles.removeAt(index);
          update();
        });
  }

  void openUploadBottomSheet() {
    Get.bottomSheet(
      GetBuilder<FormationController>(
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Manage Files',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: controller.pickAndUploadFile,
                  icon: const Icon(Icons.add),
                  label: const Text('Add File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.uploadedFiles.length,
                    itemBuilder: (context, index) {
                      final file = controller.uploadedFiles[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(file.name),
                          subtitle: file.isUploading
                              ? LinearProgressIndicator(value: file.progress)
                              : file.isCompleted
                              ? const Text(
                                  'Upload Complete',
                                  style: TextStyle(color: Colors.green),
                                )
                              : const Text('Pending'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.deleteFile(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }
}
