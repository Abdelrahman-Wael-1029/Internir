import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internir/utils/app_assets.dart';
import '../dashboard/dashboard_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../../services/fire_database.dart';
import '../../providers/jobs_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/size_config.dart';
import '../layout/home_layout.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      futureCall();
    });
  }

  Future<void> futureCall() async {
    var jobProvider = context.read<JobsProvider>();
    User? user = FirebaseAuth.instance.currentUser;

    await Future.delayed(const Duration(seconds: 3));
    if (user != null) {
      bool admin = await FireDatabase.isExist('company', user.uid);
      if (admin) {
        Navigator.pushNamedAndRemoveUntil(
            context, DashboardScreen.routeName, (route) => false);
      } else {
        await jobProvider.fetchJobs();

        Navigator.pushNamedAndRemoveUntil(
            context, HomeLayout.routeName, (route) => false);
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, OnBoardingScreen.routeName, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Internir.jpg',
              width: 350 * SizeConfig.horizontalBlock,
              height: 350 * SizeConfig.verticalBlock,
            ),
            SizedBox(height: 20 * SizeConfig.verticalBlock),
            Text(
              'Discover Your Future Opportunity',
              style: TextStyle(
                fontSize: 20 * SizeConfig.textRatio,
                fontWeight: FontWeight.bold,
                color: AppColor.mainBlue,
              ),
            ),
            SizedBox(height: 20 * SizeConfig.verticalBlock),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
