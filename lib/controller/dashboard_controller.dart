import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/settings/screen_settings.dart';

class CtrlDashboard extends GetxController {
  bool collapsed = false;
  double drawerWidth = 80;
  int currentPage = 0;
  int indexHover = -1;
  int selectedBottomNavIndex = 0; // Pages tab is selected by default
  ListeStatus status = ListeStatus.none;
  int catCount = 0;
  int prodCount = 0;
  int clientCount = 0;
  int fourCount = 0;

  // Dashboard data
  var activeProjects = 23.obs;
  var overdueProjects = 12.obs;
  var pendingProjects = 35.obs;
  var meetingsCount = 0.obs;

  // Project data
  var projects = <ProjectModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDashboardData();
  }

  void collapse() {
    collapsed = !collapsed;
    collapsed == true ? drawerWidth = 300 : drawerWidth = 80;
    update();
  }

  void _loadDashboardData() async {
    // Initialize with sample data
    status = ListeStatus.loading;
    update();
    try {
      await Constants.reposit.repGetDashboard().then((value) {
        if (value['status'] == 'success') {
          status = ListeStatus.success;
          catCount = value['cat_count'];
          prodCount = value['product_count'];
          clientCount = value['clientCount'];
          fourCount = value['fourCount'];
        }
      });
    } catch (e) {}
    update();

    projects.value = [
      ProjectModel(
        title: "Website Launch",
        status: "Developing",
        progress: 2,
        total: 6,
        color: Colors.blue,
        icon: Icons.settings,
      ),
      ProjectModel(
        title: "Application Update",
        status: "Complete",
        progress: 10,
        total: 10,
        color: Colors.green,
        icon: Icons.power,
      ),
      ProjectModel(
        title: "Server Data Transfer",
        status: "Canceled",
        progress: 3,
        total: 5,
        color: Colors.red,
        icon: Icons.menu,
      ),
    ];
  }

  void updateBottomNavIndex(int index) {
    selectedBottomNavIndex = index;

    update();
    switch (index) {
      case 4:
        Get.to(() => ScreenSettings());

        break;
      default:
    }
  }

  void refreshDashboard() {
    // Refresh dashboard data
    _loadDashboardData();
    update();
  }
}

// Project model class
class ProjectModel {
  final String title;
  final String status;
  final int progress;
  final int total;
  final Color color;
  final IconData icon;

  ProjectModel({
    required this.title,
    required this.status,
    required this.progress,
    required this.total,
    required this.color,
    required this.icon,
  });
}
