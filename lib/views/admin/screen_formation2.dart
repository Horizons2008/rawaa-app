import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/views/admin/screen_achat.dart';
import 'package:rawaa_app/views/admin/screen_formation.dart';

class ScreenFormation2 extends StatefulWidget {
  const ScreenFormation2({Key? key}) : super(key: key);

  @override
  _ScreenFormation2State createState() => _ScreenFormation2State();
}

class _ScreenFormation2State extends State<ScreenFormation2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> tabs = [
    Tab(text: 'formation'.tr),
    Tab(text: 'gestion_achats'.tr),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('gestion_formation'.tr),
        
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.black87,
          indicatorColor: Colors.red,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Onglet "Formation"
          ScreenFormation(),
          // Onglet "Gestion des demandes d\'achat"
          PurchaseRequestsScreen(),
        ],
      ),
    );
  }
}
