import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/layout/home.dart';
import 'package:dev/layout/homepage.dart';
import 'package:dev/layout/login.dart';
import 'package:dev/layout/my_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
            final email = FirebaseAuth.instance.currentUser!;
            return MyAuth(email: email.email);
          }
          //user is not logged in
          else {
            return Login();
          }
        },
      ),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
    
//   }
// }