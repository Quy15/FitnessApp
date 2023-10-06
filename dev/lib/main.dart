import 'package:dev/admin/admin_homepage.dart';
import 'package:dev/layout/auth_page.dart';
import 'package:dev/layout/home.dart';
import 'package:dev/layout/homepage.dart';
import 'package:dev/layout/login.dart';
import 'package:dev/layout/register.dart';
import 'package:dev/layout/register_pt.dart';
import 'package:dev/layout/splash.dart';
import 'package:dev/push_noti/push_noti.dart';
import 'package:dev/tablayout/tab_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Trainer/trainer_homepage.dart';
import 'admin/admin_manage_user.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  await  PushNoti().initNotification();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealthApp',
      routes: {
        'splash': (context) => Splash(),
        'register': (context) => RegisterPT(),
        'login': (context) => Login(),
        'home': (context) => Home(),   
        'homepage': (context) => HomePage(),
        'admin_homepage': (context) => AdminHomePage(),
        'admin_manage_user': (context) => AdminManageUser(),
        'trainer_homepage': (context) => TrainerHomePage(),
        'tab_chat': (context) => Chat()
      },
      home: AuthPage(),
    );
  }
}
