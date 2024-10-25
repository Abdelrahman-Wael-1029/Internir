import 'package:flutter/material.dart';
import 'providers/Admin/company_auth_provider.dart';
import 'providers/category_provider.dart';
import 'providers/Admin/company_provider.dart';
import 'providers/onboarding_provider.dart';
import 'providers/saved_jobs_provider.dart';
import 'providers/index_provider.dart';
import 'providers/jobs_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'utils/routes.dart';
import 'utils/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAuth.instance.signOut();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JobsProvider()),
        ChangeNotifierProvider(create: (_) => JobSaveProvider()),
        ChangeNotifierProvider(create: (_) => IndexProvider()),
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        ChangeNotifierProvider(create: (_) => CompnayAuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      title: 'Internir',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      onGenerateRoute: AppRoute.onGenerateRoute,
      initialRoute: SplashScreen.routeName,
    );
  }
}
