import 'package:flutter/material.dart';
import 'package:internir/screens/applications/applications.dart';
import 'package:internir/components/pdf_viewer.dart';
import '../screens/authentication/admin/company_sign_up.dart';
import '../screens/authentication/create_account.dart';
import '../screens/authentication/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/layout/home_layout.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../models/job_model.dart';
import '../screens/apply/apply_screen.dart';
import '../screens/apply/apply_to_job.dart';
import '../screens/category/one_category.dart';
import '../screens/category/categories.dart';

class AppRoute {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeLayout.routeName:
        return MaterialPageRoute(builder: (_) => const HomeLayout());
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case OnBoardingScreen.routeName:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case CompanySignUp.routeName:
        return MaterialPageRoute(builder: (_) => const CompanySignUp());
      case ApplyScreen.routeName:
        final job = settings.arguments as JobModel;
        return MaterialPageRoute(builder: (_) => ApplyScreen(job: job));
      case ApplyToJob.routeName:
        final job = settings.arguments as JobModel;
        return MaterialPageRoute(builder: (_) => ApplyToJob(job: job));
      case DashboardScreen.routeName:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case CreateAccountScreen.routeName:
        return MaterialPageRoute(builder: (_) => const CreateAccountScreen());
      case OneCategory.routeName:
        final categoryName = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => OneCategory(
                  categoryName: categoryName,
                ));
      case Categories.routeName:
        return MaterialPageRoute(builder: (_) => const Categories());
      case Applications.routeName:
        return MaterialPageRoute(builder: (_) => const Applications());
      case PdfViewer.routeName:
        final pdfUrl = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => PdfViewer(pdfUrl: pdfUrl));

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
