import 'package:fedha/constants/constants.dart';

import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:fedha/features/dashboard/widgets/drawer.dart';
import 'package:fedha/features/dashboard/widgets/main_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:go_router/go_router.dart';

bool isDrawerOpened = true;

class BaseScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const BaseScreen({Key? key, required this.navigationShell}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Same deep forest green as net-worth / planning heroes (not old #03a63c).
    return ZoomDrawer(
      controller: zoomDrawerController,
      borderRadius: 24.0,
      showShadow: true,
      angle: 0.0,
      disableDragGesture: false,
      androidCloseOnBackTap: true,
      drawerShadowsBackgroundColor: const Color(0xFFCFEAD9),
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      menuBackgroundColor: HomeDesign.mintSoft,
      menuScreen: const MenuScreen(),
      mainScreen: MainScreen(
        navigationShell: widget.navigationShell,
      ),
    );
  }
}
