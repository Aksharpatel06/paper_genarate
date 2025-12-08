import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/auth_provider.dart';
import 'controller/home_provider.dart';
import 'firebase_options.dart';
import 'utils/app_pref.dart';
import 'utils/color.dart';
import 'view/screen/profile_page.dart';
import 'view/screen/sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPref.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()..loadJosnData()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
