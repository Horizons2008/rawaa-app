import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rawaa_app/controller/admin/contr_form.dart';
import 'package:rawaa_app/model/model_formation.dart';

import 'package:rawaa_app/my_widgets/custom_text.dart';
import 'package:rawaa_app/my_widgets/loading.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/admin/add_formation.dart';

class ScreenFormation extends StatelessWidget {
  const ScreenFormation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddFormationScreen());
        },
      ),
      body: GetBuilder<FormationController>(
        init: FormationController(),
        builder: (ctrl) {
          return ctrl.loadFormationStatus == ListeStatus.loading
              ? WidgetLoading()
              : Padding(
                  padding: EdgeInsetsGeometry.all(8),
                  child: Column(
                    children: [
                      // Filter chips section

                      // Courses list
                      Expanded(
                        child: ListView.builder(
                          itemCount: ctrl.formations.length,
                          itemBuilder: (context, index) {
                            MFormation course = ctrl.formations[index];

                            return CourseCard(
                              course: course,

                              // INSERT_YOUR_CODE
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final MFormation course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormationController>(
      builder: (ctrl) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course image with category badge
              Stack(
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          '${Constants.photoUrl}formation/${course.id}.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        course.isOnline == true ? 'online'.tr : 'offline'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row with price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //  const SizedBox(height: 4),
                              Text(
                                'by ${course.instructor}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green[100]!),
                          ),
                          child: Text(
                            Constants.currency(course.price),

                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Description
                    Text(
                      course.description,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Date/Time or Duration section
                    if (course.date != null && course.startTime != null) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date row
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                // INSERT_YOUR_CODE
                                course.date != null
                                    ? "${course.date!.day.toString().padLeft(2, '0')}/${course.date!.month.toString().padLeft(2, '0')}/${course.date!.year}"
                                    : "",

                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          // Time row
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${course.startTime!.hour.toString().padLeft(2, '0')}:${course.startTime!.minute.toString().padLeft(2, '0')} - "
                                "${course.endTime != null ? course.endTime!.hour.toString().padLeft(2, '0') + ':' + course.endTime!.minute.toString().padLeft(2, '0') : ''}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ] else if (course.duration != null) ...[
                      Row(
                        children: [
                          Icon(Icons.watch, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Text(
                            "${course.duration!.inHours.toString().padLeft(2, '0')}:${(course.duration!.inMinutes.remainder(60)).toString().padLeft(2, '0')}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 8),
                    Divider(thickness: 0.5),

                    // Action buttons aligned to bottom right
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Constants.currentUser!.role == "client"
                              ? InkWell(
                                  onTap: () {
                                    // INSERT_YOUR_CODE
                                    showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
                                      ),
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return GetBuilder<FormationController>(
                                          builder: (ctrl) {
                                            return Padding(
                                              padding: MediaQuery.of(context)
                                                  .viewInsets
                                                  .add(
                                                    const EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      bottom: 20,
                                                      top: 24,
                                                    ),
                                                  ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      height: 4,
                                                      width: 40,
                                                      margin:
                                                          const EdgeInsets.only(
                                                            bottom: 12,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[400],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Confirmer l'achat",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 18),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.school,
                                                        color:
                                                            Colors.blueAccent,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          course.title,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.person,
                                                        color:
                                                            Colors.deepOrange,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          course.instructor!,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.price_check,
                                                        color: Colors.green,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        ("$course.price DA"),
                                                        style: TextStyle(
                                                          color: Colors.teal,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 18),
                                                  Center(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                ctrl.pickImage(
                                                                  ImageSource
                                                                      .gallery,
                                                                );
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          12,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                  color: Colors
                                                                      .grey[100],
                                                                  border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .photo_library,
                                                                      color: Colors
                                                                          .indigo,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Text(
                                                                      "Choisir une image",
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                ctrl.pickImage(
                                                                  ImageSource
                                                                      .camera,
                                                                );
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          12,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                  color: Colors
                                                                      .grey[100],
                                                                  border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .camera_alt,
                                                                      color: Colors
                                                                          .deepOrange,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Text(
                                                                      "Prendre photo",
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        if (ctrl
                                                            .recusPath
                                                            .isNotEmpty) ...[
                                                          const SizedBox(
                                                            height: 14,
                                                          ),
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                            child:
                                                                ctrl
                                                                    .recusPath
                                                                    .isNotEmpty
                                                                ? Image.file(
                                                                    File(
                                                                      ctrl.recusPath,
                                                                    ),
                                                                    height: 150,
                                                                    width: 300,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : Container(
                                                                    width: 50,
                                                                    height: 50,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      ElevatedButton.icon(
                                                        onPressed: () async {
                                                          if (ctrl
                                                              .recusPath
                                                              .isEmpty) {
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  "Merci de choisir ou prendre une image avant de confirmer",
                                                                ),
                                                              ),
                                                            );
                                                            return;
                                                          }

                                                          ctrl.storeAchat(
                                                            course.id,
                                                          );
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                        },
                                                        icon: Icon(
                                                          Icons.check_circle,
                                                        ),
                                                        label: Text(
                                                          "Confirmer l'achat",
                                                        ),
                                                        style:
                                                            ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.green,
                                                              foregroundColor:
                                                                  Colors.white,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );

                                    //ctrl.storeAchat(id);
                                  },
                                  child: course.dejaAcheter != "Acheter"
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons.circle_rounded,
                                              size: 12,
                                              color: Colors.orange,
                                            ),
                                            Text(
                                              course.dejaAcheter,
                                              style: TextStyle(
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: course.dejaAcheter == true
                                                ? Colors.grey
                                                : Colors.green,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: CustomText(
                                            text: course.dejaAcheter,
                                            size: 14,
                                            weight: FontWeight.w600,
                                            coul: Colors.white,
                                          ),
                                        ),
                                )
                              : SizedBox(),
                          Spacer(),
                          Constants.currentUser!.role == "admin"
                              ? _buildActionButton('update'.tr, Colors.blue, () {
                                  // ctrl.editFormation(formation);
                                  ctrl.editFormation(course);
                                  Get.to(() => AddFormationScreen());
                                })
                              : SizedBox(),
                          const SizedBox(width: 8),
                          Constants.currentUser!.role == "admin"
                              ? _buildActionButton('delete'.tr, Colors.red, () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,

                                        title: Text('confirm_deletion'.tr),
                                        content: Text(
                                          'confirm_delete_formation'.tr,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('annuler'.tr),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              ctrl.deleteFormation(course);
                                              // Example: ctrl.deleteFormation(id);
                                            },
                                            child: Text(
                                              'supprimer'.tr,
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                })
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
