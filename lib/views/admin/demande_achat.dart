import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rawaa_app/controller/admin/contr_form.dart';
import 'package:rawaa_app/model/model_formation.dart';
import 'package:rawaa_app/my_widgets/space_hor.dart';
import 'package:rawaa_app/styles/constants.dart';

Future<dynamic> confirmAchat(BuildContext context, MFormation course) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return GetBuilder<FormationController>(
        builder: (ctrl) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets.add(
              const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "confirme_achat".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Icon(Icons.school, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        course.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.deepOrange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        course.instructor!,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.price_check, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      (Constants.currency(course.price)),
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                FutureBuilder<dynamic>(
                  future: Constants.reposit.repGetConfiguration(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 20,
                        child: Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      print('Configuration API Error: ${snapshot.error}');
                      return const SizedBox.shrink();
                    }

                    if (snapshot.hasData && snapshot.data != null) {
                      try {
                        final configData = snapshot.data;
                        print('Configuration Response: $configData');

                        String? ccpNumber;

                        // Try different possible field names from backend
                        if (configData is Map<String, dynamic>) {
                          // Check for error status first
                          if (configData['status'] == 'ERROR' ||
                              configData['status'] == 'error') {
                            print('API returned error: ${configData['error']}');
                            return const SizedBox.shrink();
                          }

                          // Try various field name combinations
                          // Common Laravel response formats:
                          // 1. Direct field: { "ccp_number": "123456" }
                          // 2. Nested in data: { "data": { "ccp_number": "123456" } }
                          // 3. Success wrapper: { "status": "success", "ccp_number": "123456" }
                          // 4. Or just: { "ccp": "123456" }

                          ccpNumber =
                              configData['ccp_number']?.toString() ??
                              configData['ccp']?.toString() ??
                              configData['ccpNumber']?.toString() ??
                              configData['ccp_number'] ??
                              configData['ccp'] ??
                              configData['ccpNumber'];

                          // If data is nested in 'data' field
                          if (ccpNumber == null && configData['data'] != null) {
                            final data = configData['data'];
                            if (data is Map<String, dynamic>) {
                              ccpNumber =
                                  data['ccp_number']?.toString() ??
                                  data['ccp']?.toString() ??
                                  data['ccpNumber']?.toString() ??
                                  data['ccp_number'] ??
                                  data['ccp'] ??
                                  data['ccpNumber'];
                            }
                            // If data is a string (direct CCP number)
                            else if (data is String) {
                              ccpNumber = data;
                            }
                          }

                          // If it's a list, check first item
                          if (ccpNumber == null &&
                              configData['data'] is List &&
                              (configData['data'] as List).isNotEmpty) {
                            final firstItem = (configData['data'] as List)[0];
                            if (firstItem is Map<String, dynamic>) {
                              ccpNumber =
                                  firstItem['ccp_number']?.toString() ??
                                  firstItem['ccp']?.toString() ??
                                  firstItem['ccpNumber']?.toString() ??
                                  firstItem['ccp_number'] ??
                                  firstItem['ccp'] ??
                                  firstItem['ccpNumber'];
                            }
                          }
                        }
                        // If response is directly a string (just the CCP number)
                        else if (configData is String) {
                          ccpNumber = configData;
                        }

                        print('Extracted CCP Number: $ccpNumber');

                        if (ccpNumber != null &&
                            ccpNumber.toString().trim().isNotEmpty) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 18),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.blue[200]!,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.account_balance,
                                      color: Colors.blue[700],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'ccp_payment_info'.tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[900],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const SizedBox(width: 28),
                                    Expanded(
                                      child: Text(
                                        'ccp_send_payment_to'.tr,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.blue[800],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const SizedBox(width: 28),
                                    Expanded(
                                      child: Text(
                                        ccpNumber.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[900],
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          print('CCP number is null or empty');
                        }
                      } catch (e) {
                        print('Error parsing configuration: $e');
                        print('Stack trace: ${StackTrace.current}');
                      }
                    } else {
                      print('No data received from configuration API');
                    }

                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 18),
                Center(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              ctrl.pickImage(ImageSource.gallery);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.photo_library,
                                    color: Colors.indigo,
                                  ),
                                  const SizedBox(width: 8),
                                  Text("choisir_photo".tr),
                                ],
                              ),
                            ),
                          ),
                          SpaceH(w: 15),
                          GestureDetector(
                            onTap: () async {
                              ctrl.pickImage(ImageSource.camera);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: Colors.deepOrange,
                                  ),
                                  const SizedBox(width: 8),
                                  Text("prendre_photo".tr),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (ctrl.recusPath.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ctrl.recusPath.isNotEmpty
                              ? Image.file(
                                  File(ctrl.recusPath),
                                  height: 150,
                                  width: 300,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey,
                                ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (ctrl.recusPath.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("please_select_teke_photo".tr),
                            ),
                          );
                          return;
                        }

                        ctrl.storeAchat(course.id);
                      },
                      icon: Icon(Icons.check_circle),
                      label: Text("valider".tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
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
