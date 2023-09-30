import 'package:dev/admin/admin_homepage.dart';
import 'package:dev/layout/auth_page.dart';
import 'package:dev/layout/home.dart';
import 'package:dev/layout/homepage.dart';
import 'package:dev/layout/login.dart';
import 'package:dev/layout/register.dart';
import 'package:dev/layout/register_pt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Trainer/trainer_homepage.dart';
import 'admin/admin_manage_user.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
  );


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealthApp',
      routes: {
        'register': (context) => RegisterPT(),
        'login': (context) => Login(),
        'home': (context) => Home(),   
        'homepage': (context) => HomePage(),
        'admin_homepage': (context) => AdminHomePage(),
        'admin_manage_user': (context) => AdminManageUser(),
        'trainer_homepage': (context) => TrainerHomePage(),
      },
      home: AuthPage(),
    );
  }
}
