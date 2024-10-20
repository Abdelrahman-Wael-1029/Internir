import 'package:flutter/material.dart';
import 'package:internir/screens/authentication/create_account.dart';
import 'package:internir/screens/authentication/login_screen.dart';
import 'package:internir/screens/category/one_category.dart';
import 'package:internir/screens/category/categories.dart';
import '../screens/layout/home_layout.dart';
import '../screens/splash/splash_screen.dart';
import 'package:internir/screens/authentication/admin/company_sign_up.dart';
import 'package:internir/screens/layout/home_layout.dart';
import 'package:internir/screens/splash/splash_screen.dart';
import 'package:internir/screens/onboarding/onboarding_screen.dart';
import '../models/job_model.dart';
import '../screens/apply/apply_screen.dart';
import '../screens/apply/apply_to_job.dart';

class AppRoute {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeLayout.routeName:
        return MaterialPageRoute(builder: (_) => const HomeLayout());
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case OneCategory.routeName:
        final categoryName = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => OneCategory(
                  categoryName: categoryName,
                ));
      case Categories.routeName:
        return MaterialPageRoute(builder: (_) => const Categories());
      case OnBoardingScreen.routeName:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case CompanySignUp.routeName:
        return MaterialPageRoute(builder: (_) => const CompanySignUp());
      case ApplyScreen.routeName:
        final job = settings.arguments as JobModel;
        return MaterialPageRoute(builder: (_) => ApplyScreen(job: job));
      case CreateAccountScreen.routeName:
        return MaterialPageRoute(builder: (_) => const CreateAccountScreen());
      case ApplyToJob.routeName:
        final job = settings.arguments as JobModel;
        return MaterialPageRoute(builder: (_) => ApplyToJob(job: job));
      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return MaterialPageRoute(builder: (_) => errorRoute());
    }
  }

  static Widget errorRoute() {
    return const Scaffold(
      body: Center(
        child: Text('Error: Route not found'),
      ),
    );
  }
}
