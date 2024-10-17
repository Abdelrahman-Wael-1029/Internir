import 'package:flutter/material.dart';
import 'package:internir/providers/index_provider.dart';
import 'package:internir/providers/jobs_provider.dart';
import 'package:internir/screens/splash/splash_screen.dart';
import 'package:internir/utils/routes.dart';
import 'package:internir/utils/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'utils/app_theme.dart';
import 'package:internir/screens/authentication/login_screen.dart';
import 'package:internir/screens/authentication/create_account.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JobsProvider()),
        ChangeNotifierProvider(create: (_) => IndexProvider()),
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
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        CreateAccountScreen.routeName: (context) => const CreateAccountScreen(),

      },
    );
  }
}