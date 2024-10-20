import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internir/providers/jobs_provider.dart';
import 'package:internir/screens/authentication/login_screen.dart';
import 'package:internir/utils/app_color.dart';
import 'package:internir/utils/size_config.dart';
import 'package:internir/screens/layout/home_layout.dart';
import 'package:internir/utils/app_assets.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await futureCall();
    });
  }

  Future<void> futureCall() async {
    var jobProvider = context.read<JobsProvider>();
    User? user = FirebaseAuth.instance.currentUser;
    

    await Future.delayed(const Duration(seconds: 3));
    if (user != null) {
      await jobProvider.fetchJobs();
      print("found user");
      Navigator.pushNamedAndRemoveUntil(
          context, HomeLayout.routeName, (route) => false);
    } else {
      print("no user");
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
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
              AppAssets.logo,
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
