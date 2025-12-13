import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rawaa_app/controller/admin/contr_form.dart';
import 'package:rawaa_app/model/model_formation.dart';
import 'package:rawaa_app/my_widgets/space_hor.dart';
import 'package:rawaa_app/styles/constants.dart';

Future<dynamic> confirmAchat(BuildContext context,MFormation course) {
    return showModalBottomSheet(
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
                                                      "confirme_achat".tr,
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
                                                      (Constants.currency(
                                                        course.price,
                                                      )),
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
                                                                    "choisir_photo"
                                                                        .tr,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SpaceH(w: 15),
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
                                                                    "prendre_photo"
                                                                        .tr,
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
                                                                "please_select_teke_photo"
                                                                    .tr,
                                                              ),
                                                            ),
                                                          );
                                                          return;
                                                        }

                                                        ctrl.storeAchat(
                                                          course.id,
                                                        );
                                                        
                                                      },
                                                      icon: Icon(
                                                        Icons.check_circle,
                                                      ),
                                                      label: Text(
                                                        "valider".tr,
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
  }
