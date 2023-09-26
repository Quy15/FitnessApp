import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/admin/admin_homepage.dart';
import 'package:dev/layout/home.dart';
import 'package:dev/layout/homepage.dart';
import 'package:dev/layout/login.dart';
import 'package:flutter/material.dart';

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

    return FutureBuilder<DocumentSnapshot>(
      future: userref.doc(id).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done){
          if(isAnswered == true && userType != 'admin'){
            return HomePage();
          }else if(isAnswered == true && userType == 'admin'){
            return AdminHomePage();
          }else{
            return Home();
          }
        }else{
          return Login();
        }
      })
    );
  }
}