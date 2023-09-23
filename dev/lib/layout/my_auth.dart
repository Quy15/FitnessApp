import 'package:cloud_firestore/cloud_firestore.dart';
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
    
    FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        id = doc.reference.id;
        print(id);       
        isAnswered = bool.parse("${doc['isAnswer']}");
        print(isAnswered);
      });
    });

    return FutureBuilder<DocumentSnapshot>(
      future: userref.doc(id).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done){
          if(isAnswered == true){
            return HomePage();
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