

import 'package:dev/layout/continue.dart';
import 'package:dev/layout/exam.dart';
import 'package:dev/layout/home.dart';
import 'package:dev/layout/login.dart';
import 'package:dev/layout/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, 
  ]);
   
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'HealthApp',
    initialRoute: 'exam',
      routes: { 'login': (context) => Login(),
                'register': (context) => Register(),
                'home': (context) => Home(),
                'continue': (context) => Continue(),
                'exam': (context) => Exam()
      },
    home: isLoggedIn ? Home() : Login(),
  );
  }

}

