import 'dart:async';

import 'package:fedha/data/models/auth/login/login_response.dart';
import 'package:fedha/data/repository/authentication.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/localization/app_prefs.dart';
import 'package:fedha/services/local_auth.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // FlutterNativeSplash.remove();
    Future.delayed(const Duration(seconds: 2), () {
      _init();
    });
    super.initState();
  }

  // Init app
  void _init() async {
    var prefs = service<AppPreferences>();

    // Check if user has been onboarded
    final bool boarded = await prefs.isBoarded();

    if (boarded) {
      // Get token
      final LoginResponse? data = await prefs.getAuthData();

      if (data != null) {
        // Verify bio metrics
        bool authenticated = await LocalAuth.authenticate();

        if (authenticated) {
          // Login user
          await AuthenticationRepository.instance.login(data);
        } else {
          showError("Failed to identify user.\nPlease log in or try again!");
          context.goNamed(Routes.login);
        }
      } else {
        // Take to login
        context.goNamed(Routes.register);
      }
    } else {
      print("Not boarded, go to welcome");
      // Onboard
      context.goNamed(Routes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              'assets/Images/Background.png',
            ),
            fit: BoxFit.cover),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * .4),
          child: Image.asset(
            "assets/Images/ic_launcher.png",
            height: 150,
            width: 150,
          ),
        ),
      ),
    );
  }
}
