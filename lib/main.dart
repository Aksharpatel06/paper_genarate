import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'controller/auth_provider.dart';
import 'controller/home_provider.dart';
import 'firebase_options.dart';
import 'utils/app_pref.dart';
import 'utils/color.dart';
import 'view/screen/profile_page.dart';
import 'view/screen/sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await AppPref.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()..loadJsonData()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Login',
      theme: ThemeData(scaffoldBackgroundColor: CustomColors.whiteColor),
      home: auth.getCurrentUser() != null ? const ProfilePage() : const GoogleAuthPage(),
    );
  }
}
