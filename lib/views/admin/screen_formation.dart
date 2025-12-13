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
                        fit: BoxFit.fill,
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
                          if (Constants.currentUser!.role == 'client' &&
                              course.dejaAcheter == 'confirmed')
                            TextButton.icon(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                  ),
                                  builder: (context) {
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Container(
                                              width: 40,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'playlist'.tr,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Expanded(
                                            child: course.playlist.isEmpty
                                                ? Center(
                                                    child: Text(
                                                      'No videos available',
                                                    ),
                                                  )
                                                : ListView.builder(
                                                    itemCount:
                                                        course.playlist.length,
                                                    itemBuilder: (context, index) {
                                                      final fileUrl = course
                                                          .playlist[index];
                                                      // Extract filename from URL for display
                                                      final fileName = fileUrl
                                                          .split('/')
                                                          .last;
                                                      return ListTile(
                                                        leading: const Icon(
                                                          Icons
                                                              .play_circle_fill,
                                                          color: Colors.blue,
                                                        ),
                                                        title: Text(fileName),
                                                        onTap: () {
                                                          Get.to(
                                                            () => VideoPlayerScreen(
                                                              videoUrl:
                                                                  "${Constants.photoUrl}formation/documents/$fileUrl",
                                                            ),
                                                          );
                                                        },
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
                              icon: const Icon(Icons.playlist_play),
                              label: Text('playlist'.tr),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.purple,
                              ),
                            ),
                          Spacer(),
                          Constants.currentUser!.role == "admin"
                              ? _buildActionButton(
                                  'update'.tr,
                                  Colors.blue,
                                  () {
                                    ctrl.editFormation(course);
                                    Get.to(() => AddFormationScreen());
                                  },
                                )
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
