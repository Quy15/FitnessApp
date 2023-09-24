import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  _HomeTab createState() => _HomeTab();
}

class _HomeTab extends State<HomeTab> {
  final user = FirebaseAuth.instance.currentUser;

  String id = " ";
  String name = " ";
  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        id = doc.reference.id;
        setState(() {
          this.name = '${doc['name']}';
        });
      });
    });
  }

  @override
  void initState(){
    getUserByEmail(user?.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Container(
          height: 150,
          width: size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5.0,
                  spreadRadius: 1.1,
                ),
              ],
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Text('Chào ' + name, style: TextStyle(fontSize: 20),)
            ],
          ),
        ),
      ),
    );
  }
}
