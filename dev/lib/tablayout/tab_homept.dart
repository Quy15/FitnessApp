import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePT extends StatefulWidget {
  const HomePT({super.key});

  @override
  State<HomePT> createState() => _HomePTState();
}


class _HomePTState extends State<HomePT> {

  final user = FirebaseAuth.instance.currentUser;
  
  String ptname = " ";
  Future getPTByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("trainers")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          // id = doc.reference.id;
          this.ptname = '${doc['name']}';
          print(ptname);
        });
      });
    });
  }

  @override
  void initState(){
    getPTByEmail(user?.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: size.width,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(255, 255, 255, 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 5.0,
                  spreadRadius: 1.1,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              children: [
                Text("Xin chào " + ptname, style: TextStyle(color: Colors.black, fontSize: 30),),
                CircleAvatar(
                  child: Icon(Icons.person),
                  radius: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
