import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/dashboard_controller.dart';
import 'package:rawaa_app/my_widgets/custom_text.dart';
import 'package:rawaa_app/my_widgets/error_restful.dart';
import 'package:rawaa_app/my_widgets/loading.dart';
import 'package:rawaa_app/my_widgets/space_ver.dart';
import 'package:rawaa_app/my_widgets/space_hor.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/admin/screen_client/screen_clients.dart';
import 'package:rawaa_app/views/admin/screen_vendeur/screen_vendeur.dart';
import 'package:rawaa_app/views/categories/screen_categories.dart';
import 'package:rawaa_app/views/products/screen_products.dart';
import 'package:rawaa_app/views/settings/screen_settings.dart';

class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CtrlDashboard());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: GetBuilder<CtrlDashboard>(
          init: CtrlDashboard(),
          builder: (ctrl) {
            return ctrl.status == ListeStatus.loading
                ? WidgetLoading()
                : ctrl.status == ListeStatus.error
                ? WidgetError()
                : ctrl.status == ListeStatus.success
                ? SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Section
                          _buildHeader(),
                          SpaceV(h: 30),

                          // Summary Cards Section
                          _buildSummaryCards(),
                          SpaceV(h: 30),

                          // Projects Section
                          _buildProjectsSection(),
                          SpaceV(h: 30),

                          // Recent Activity Section
                          _buildRecentActivity(),
                        ],
                      ),
                    ),
                  )
                : Container();
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: Constants.currentUser!.name,
                size: 28,
                weight: FontWeight.bold,
                coul: Colors.black,
              ),

              CustomText(
                text: Constants.currentUser!.role,
                size: 14,
                weight: FontWeight.w400,
                coul: Colors.grey[600] ?? Colors.grey,
              ),
            ],
          ),
        ),
        ClipOval(
          child: Image.network(
            '${Constants.photoUrl}/users/${Constants.currentUser!.id}.jpg',

            fit: BoxFit.cover,
            width: 50,
            height: 50,

            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.person, size: 30, color: Colors.grey[600]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return GetBuilder<CtrlDashboard>(
      builder: (controller) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: "categories".tr,
                  value: controller.catCount.toString(),
                  change: "clique_voir_detail".tr,

                  color: Colors.green,
                  icon: Icons.work,
                  onClique: () {
                    Get.to(() => ScreenCategorie());
                  },
                ),
              ),
              SpaceH(w: 15),
              Expanded(
                child: _buildSummaryCard(
                  title: "products".tr,
                  value: controller.prodCount.toString(),
                  change: "clique_voir_detail".tr,
                  color: Colors.red,
                  icon: Icons.warning,
                  onClique: () {
                    Get.to(() => ScreenProduct());
                  },
                ),
              ),
            ],
          ),
          SpaceV(h: 15),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: "clients".tr,
                  value: controller.clientCount.toString(),
                  change: "clique_voir_detail".tr,
                  color: Colors.orange,
                  icon: Icons.pending,
                  onClique: () {
                    Get.to(() => ScreenClients());
                  },
                ),
              ),
              SpaceH(w: 15),
              Expanded(
                child: _buildSummaryCard(
                  title: "vendeurs".tr,
                  value: controller.fourCount.toString(),

                  change: "clique_voir_detail".tr,
                  color: Colors.blue,
                  icon: Icons.event,
                  onClique: () {
                    Get.to(() => ScreenVendeurs());
                  },
                ),
              ),
            ],
          ),
          SpaceV(h: 15),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String change,
    required Color color,
    required IconData icon,
    required VoidCallback? onClique,
  }) {
    return InkWell(
      onTap: onClique,

      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: title,
              size: 16,
              weight: FontWeight.w500,
              coul: Colors.white.withOpacity(0.9),
            ),
            SpaceV(h: 5),
            CustomText(
              text: value,
              size: 24,
              weight: FontWeight.bold,
              coul: Colors.white,
            ),
            SpaceV(h: 5),
            CustomText(
              text: change,
              size: 12,
              weight: FontWeight.w400,
              coul: Colors.white.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsSection() {
    return GetBuilder<CtrlDashboard>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                text: "YOUR PROJECTS",
                size: 16,
                weight: FontWeight.w600,
                coul: Colors.grey[700] ?? Colors.grey,
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  // Navigate to all projects page
                },
                child: CustomText(
                  text: "View All",
                  size: 14,
                  weight: FontWeight.w500,
                  coul: Colors.blue,
                ),
              ),
            ],
          ),
          SpaceV(h: 15),
          ...controller.projects
              .map(
                (project) => Column(
                  children: [
                    _buildProjectCard(
                      title: project.title,
                      status: project.status,
                      progress: project.progress,
                      total: project.total,
                      color: project.color,
                      icon: project.icon,
                    ),
                    if (project != controller.projects.last) SpaceV(h: 12),
                  ],
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildProjectCard({
    required String title,
    required String status,
    required int progress,
    required int total,
    required Color color,
    required IconData icon,
  }) {
    double progressValue = progress / total;
    bool isComplete = progress == total;
    bool isCanceled = status == "Canceled";

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SpaceH(w: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  size: 16,
                  weight: FontWeight.bold,
                  coul: Colors.black,
                ),
                SpaceV(h: 4),
                CustomText(
                  text: status,
                  size: 14,
                  weight: FontWeight.w500,
                  coul: isCanceled
                      ? Colors.red
                      : (Colors.grey[600] ?? Colors.grey),
                ),
                SpaceV(h: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progressValue,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isComplete ? Colors.green : color,
                        ),
                        minHeight: 4,
                      ),
                    ),
                    SpaceH(w: 10),
                    CustomText(
                      text: "$progress/$total",
                      size: 12,
                      weight: FontWeight.w500,
                      coul: Colors.grey[600] ?? Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "RECENT ACTIVITY",
          size: 16,
          weight: FontWeight.w600,
          coul: Colors.grey[700] ?? Colors.grey,
        ),
        SpaceV(h: 15),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActivityItem(
                icon: Icons.check_circle,
                title: "Project completed",
                subtitle: "Application Update finished",
                time: "2 hours ago",
                color: Colors.green,
              ),
              SpaceV(h: 15),
              _buildActivityItem(
                icon: Icons.add_circle,
                title: "New project added",
                subtitle: "Website Launch started",
                time: "5 hours ago",
                color: Colors.blue,
              ),
              SpaceV(h: 15),
              _buildActivityItem(
                icon: Icons.warning,
                title: "Project overdue",
                subtitle: "Server Data Transfer delayed",
                time: "1 day ago",
                color: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SpaceH(w: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: title,
                size: 14,
                weight: FontWeight.w600,
                coul: Colors.black,
              ),
              SpaceV(h: 2),
              CustomText(
                text: subtitle,
                size: 12,
                weight: FontWeight.w400,
                coul: Colors.grey[600] ?? Colors.grey,
              ),
            ],
          ),
        ),
        CustomText(
          text: time,
          size: 12,
          weight: FontWeight.w400,
          coul: Colors.grey[500] ?? Colors.grey,
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return GetBuilder<CtrlDashboard>(
      builder: (controller) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.black,
          currentIndex: controller.selectedBottomNavIndex,
          onTap: (index) {
            controller.updateBottomNavIndex(index);
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.tr),

            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'cours'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'messages'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'settings'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
