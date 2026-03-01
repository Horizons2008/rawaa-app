import 'package:rawaa_app/views/admin/demande_achat.dart';
import 'package:video_player/video_player.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: Constants.currentUser!.role == 'client'
          ? AppBar(title: Text("liste_formation".tr))
          : null,
      floatingActionButton: Constants.currentUser!.role == "admin"
          ? FloatingActionButton(
              onPressed: () {
                FormationController().resetForm();
                Get.to(() => AddFormationScreen());
              },
              child: Icon(Icons.school_rounded),
            )
          : null,
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
                        child: ctrl.formations.isEmpty
                            ? Center(child: Text('Aucune formation trouvée'))
                            : ListView.builder(
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
                    color: Colors.grey.withAlpha(35),
                    child: Image.network(
                      '${Constants.photoUrl}formation/${course.id}.jpeg',
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },

                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/picture_not_found.jpg',
                        );
                      },
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
                          // Show purchase button only for paid formations
                          Constants.currentUser!.role == "client" &&
                                  course.price > 0
                              ? InkWell(
                                  onTap: () {
                                    // INSERT_YOUR_CODE
                                    confirmAchat(context, course);

                                    //ctrl.storeAchat(id);
                                  },
                                  child: course.dejaAcheter != "Acheter"
                                      ? Row(
                                          children: [
                                            Icon(
                                              // Display translated 'deja_acheter' status with color
                                              Icons.circle_rounded,
                                              size: 12,
                                              color: Constants.getStatusColor(
                                                course.dejaAcheter,
                                              ),
                                            ),
                                            Text(
                                              Constants.getStatusLabel(
                                                course.dejaAcheter,
                                              ),
                                              style: TextStyle(
                                                color: Constants.getStatusColor(
                                                  course.dejaAcheter,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: course.dejaAcheter == true
                                                ? Colors.blue
                                                : Colors.green,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: CustomText(
                                            text: "acheter".tr,
                                            size: 14,
                                            weight: FontWeight.w600,
                                            coul: Colors.white,
                                          ),
                                        ),
                                )
                              : SizedBox(),
                          Spacer(),
                          // Playlist button for clients - show in all cases if videos exist
                          if (Constants.currentUser!.role == 'client' &&
                              course.playlist.isNotEmpty)
                            TextButton.icon(
                              onPressed: () {
                                _showVideoList(context, course);
                              },
                              icon: const Icon(Icons.playlist_play),
                              label: Text(''),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.purple,
                              ),
                            ),
                          if (Constants.currentUser!.role == 'client' &&
                              course.playlist.isNotEmpty)
                            const SizedBox(width: 8),
                          Spacer(),
                          Constants.currentUser!.role == "admin"
                              ? _buildAdminActionButtons(context, course, ctrl)
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

  Widget _buildAdminActionButtons(
    BuildContext context,
    MFormation course,
    FormationController ctrl,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // View Videos button
        if (course.playlist.isNotEmpty)
          TextButton.icon(
            onPressed: () {
              _showVideoList(context, course);
            },
            icon: const Icon(Icons.playlist_play),
            label: Text(''),
            style: TextButton.styleFrom(foregroundColor: Colors.purple),
          ),
        if (course.playlist.isNotEmpty) const SizedBox(width: 8),
        // Update button
        _buildActionButton('update'.tr, Colors.blue, () {
          ctrl.editFormation(course);
          Get.to(() => AddFormationScreen());
        }),
        const SizedBox(width: 8),
        // Delete button
        _buildActionButton('delete'.tr, Colors.red, () {
          showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text('confirm_deletion'.tr),
                content: Text('confirm_delete_formation'.tr),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text('annuler'.tr),
                  ),
                  TextButton(
                    onPressed: () async {
                      ctrl.deleteFormation(course);
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text(
                      'supprimer'.tr,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      ),
    );
  }

  void _showPurchaseProcessingDialog(BuildContext context, MFormation course) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Icon(Icons.hourglass_empty, color: Colors.orange),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'purchase_processing_title'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'purchase_processing_message'.tr,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'purchase_waiting_info'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('ok'.tr, style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showPurchaseRequiredDialog(BuildContext context, MFormation course) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Icon(Icons.lock_outline, color: Colors.orange),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'formation_paid_title'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('formation_paid_message'.tr, style: TextStyle(fontSize: 14)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${'formation_price'.tr}: ${Constants.currency(course.price)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'annuler'.tr,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                confirmAchat(context, course);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text('acheter'.tr, style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showVideoList(BuildContext context, MFormation course) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return FutureBuilder<dynamic>(
          future: Constants.reposit.repGetFormationPlaylist(course.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        shape: BoxShape.circle,
                      ),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'loading'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'error'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        snapshot.error.toString(),
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }

            List<String> playlist = [];
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data['status'] == 'success') {
                // Handle different possible response formats
                if (snapshot.data['playlist'] != null) {
                  if (snapshot.data['playlist'] is List) {
                    playlist = List<String>.from(
                      snapshot.data['playlist'].map((item) {
                        if (item is String) return item;
                        if (item is Map && item['path'] != null) {
                          return item['path'].toString();
                        }
                        if (item is Map && item['file_path'] != null) {
                          return item['file_path'].toString();
                        }
                        return item.toString();
                      }),
                    );
                  } else if (snapshot.data['playlist'] is String) {
                    // If it's a comma-separated string
                    playlist = snapshot.data['playlist']
                        .split(',')
                        .where((item) => item.trim().isNotEmpty)
                        .toList();
                  }
                } else if (snapshot.data['data'] != null) {
                  if (snapshot.data['data'] is List) {
                    playlist = List<String>.from(
                      snapshot.data['data'].map((item) {
                        if (item is String) return item;
                        if (item is Map && item['path'] != null) {
                          return item['path'].toString();
                        }
                        if (item is Map && item['file_path'] != null) {
                          return item['file_path'].toString();
                        }
                        return item.toString();
                      }),
                    );
                  }
                }
              }
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Modern drag handle
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),

                  // Modern header with gradient
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[50]!, Colors.purple[50]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.playlist_play_rounded,
                            color: Colors.blue[700],
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'playlist'.tr,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${playlist.length} ${playlist.length == 1 ? 'item' : 'items'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close_rounded),
                          color: Colors.grey[600],
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.all(8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Video list
                  Expanded(
                    child: playlist.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.video_library_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'No videos available',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Videos will appear here once added',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            itemCount: playlist.length,
                            itemBuilder: (context, index) {
                              final fileUrl = playlist[index];
                              // Extract filename from URL for display
                              final fileName = fileUrl.split('/').last;

                              // Check if formation is paid and not purchased/confirmed
                              bool canPlayVideo = true;
                              bool isFreeFormation = course.price == 0;

                              if (Constants.currentUser!.role == 'client') {
                                // If formation is free (price = 0), always allow playback
                                if (isFreeFormation) {
                                  canPlayVideo = true;
                                } else {
                                  // For paid formations, check purchase status
                                  bool isNotPurchased =
                                      course.dejaAcheter == "Acheter";
                                  bool isWaiting =
                                      course.dejaAcheter.toLowerCase() ==
                                          "waitting" ||
                                      course.dejaAcheter.toLowerCase() ==
                                          "waiting";
                                  // Can play if purchased and confirmed (not waiting)
                                  canPlayVideo = !(isNotPurchased || isWaiting);
                                }
                              }

                              return Container(
                                margin: EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: canPlayVideo
                                        ? Colors.blue[100]!
                                        : Colors.grey[200]!,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      if (canPlayVideo) {
                                        print(
                                          'fileUrl: ${Constants.photoUrl}/$fileUrl',
                                        );
                                        Get.to(
                                          () => VideoPlayerScreen(
                                            videoUrl:
                                                "${Constants.photoUrl}/$fileUrl",
                                          ),
                                        );
                                      } else {
                                        // Check if status is waiting or not purchased
                                        bool isWaiting =
                                            course.dejaAcheter.toLowerCase() ==
                                                "waitting" ||
                                            course.dejaAcheter.toLowerCase() ==
                                                "waiting";
                                        if (isWaiting) {
                                          _showPurchaseProcessingDialog(
                                            context,
                                            course,
                                          );
                                        } else {
                                          _showPurchaseRequiredDialog(
                                            context,
                                            course,
                                          );
                                        }
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          // Video thumbnail image
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              width: 80,
                                              height: 60,
                                              color: Colors.grey[200],
                                              child: Image.network(
                                                '${Constants.photoUrl}formation/${course.id}_${index + 1}.jpg',
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey[300],
                                                    child: Icon(
                                                      Icons.video_library,
                                                      size: 30,
                                                      color: Colors.grey[600],
                                                    ),
                                                  );
                                                },
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Container(
                                                    color: Colors.grey[200],
                                                    child: Center(
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        value: loadingProgress.expectedTotalBytes != null
                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                loadingProgress.expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          // Video number badge
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: canPlayVideo
                                                  ? Colors.blue[50]
                                                  : Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: canPlayVideo
                                                      ? Colors.blue[700]
                                                      : Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),

                                          // Video info
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  fileName,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[900],
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                if (!isFreeFormation &&
                                                    !canPlayVideo) ...[
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        course.dejaAcheter
                                                                        .toLowerCase() ==
                                                                    "waitting" ||
                                                                course.dejaAcheter
                                                                        .toLowerCase() ==
                                                                    "waiting"
                                                            ? Icons
                                                                  .hourglass_empty
                                                            : Icons.lock,
                                                        size: 14,
                                                        color:
                                                            course.dejaAcheter
                                                                        .toLowerCase() ==
                                                                    "waitting" ||
                                                                course.dejaAcheter
                                                                        .toLowerCase() ==
                                                                    "waiting"
                                                            ? Colors.blue
                                                            : Colors.orange,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Expanded(
                                                        child: Text(
                                                          course.dejaAcheter
                                                                          .toLowerCase() ==
                                                                      "waitting" ||
                                                                  course.dejaAcheter
                                                                          .toLowerCase() ==
                                                                      "waiting"
                                                              ? 'purchase_processing_message'
                                                                    .tr
                                                              : 'video_locked_message'
                                                                    .tr,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                course.dejaAcheter
                                                                            .toLowerCase() ==
                                                                        "waitting" ||
                                                                    course.dejaAcheter
                                                                            .toLowerCase() ==
                                                                        "waiting"
                                                                ? Colors
                                                                      .blue[700]
                                                                : Colors
                                                                      .orange[700],
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          // Play/Lock icon
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: canPlayVideo
                                                  ? Colors.blue[50]
                                                  : Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              isFreeFormation
                                                  ? Icons.play_arrow_rounded
                                                  : (canPlayVideo
                                                        ? Icons
                                                              .play_arrow_rounded
                                                        : Icons.lock_outline),
                                              color: canPlayVideo
                                                  ? Colors.blue[700]
                                                  : Colors.grey[600],
                                              size: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
        );
      },
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize()
          .then((_) {
            setState(() {});
            _controller.play();
          })
          .catchError((error) {
            setState(() {
              print("Video Error: $error");
              _isError = true;
            });
            print("Video Error: $error");
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Video Player"),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Center(
        child: _isError
            ? Text("Error loading video", style: TextStyle(color: Colors.white))
            : _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause_circle_outline
                                : Icons.play_circle_outline,
                            size: 64,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                          playedColor: Colors.red,
                          bufferedColor: Colors.white24,
                          backgroundColor: Colors.white12,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
