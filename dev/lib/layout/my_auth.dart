import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Trainer/trainer_homepage.dart';
import 'package:dev/admin/admin_homepage.dart';
import 'package:dev/layout/home.dart';
import 'package:dev/layout/homepage.dart';
import 'package:dev/layout/login.dart';
import 'package:dev/layout/pt_page.dart';
import 'package:flutter/material.dart';

import 'intro_page.dart';

class MyAuth extends StatelessWidget {
  final String? email;
  const MyAuth({required this.email});

  @override
  Widget build(BuildContext context) {
    bool? isAnswered;
    CollectionReference userref = FirebaseFirestore.instance.collection("users");

    String id = " ";
    String userType = " ";
    FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        id = doc.reference.id;       
        isAnswered = bool.parse("${doc['isAnswer']}");
        userType = "${doc['type']}";
      });
    });

    String trainer = " ";
    FirebaseFirestore.instance
        .collection("trainers")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        id = doc.reference.id;       
        trainer = "${doc['type']}";
      });
    });


    return FutureBuilder<DocumentSnapshot>(
      future: userref.doc(id).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done){
          if((isAnswered == true && userType == 'user')){
            return HomePage();
          }else if(userType == 'admin'){
            return AdminHomePage();
          }else if (isAnswered == true || trainer == 'trainer'){
            return TrainerHomePage();
          }else{
            return IntroPage();
          }
        }else if (snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }else{
          return Login();
        }
      })
    );
  }
}