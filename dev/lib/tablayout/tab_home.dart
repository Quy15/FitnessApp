import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/layout/pt_detail.dart';
import 'package:dev/tablayout/get_pt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  _HomeTab createState() => _HomeTab();
}

class _HomeTab extends State<HomeTab> {
  final user = FirebaseAuth.instance.currentUser;

  String id = " ";
  String uname = " ";
  String prequently = " ";
  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          id = '${doc['id']}';
          this.uname = '${doc['name']}';
          print(id);
        });
      });
    });

    await FirebaseFirestore.instance
        .collection("trainning_purpose")
        .where("user_id", isEqualTo: id)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          this.prequently = '${doc['prequently']}';
        });
        print(prequently);
      });
    });
  }

  // Future getPurpose() async {
  //   await FirebaseFirestore.instance
  //       .collection("trainning_purpose")
  //       .where("user_id", isEqualTo: id)
  //       .get()
  //       .then((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((DocumentSnapshot doc) {
  //       this.prequently = '${doc['purpose']}';
  //       print(prequently);
  //     });
  //   });
  // }

  List<String> ptIDs = [];

  Future getPT() async {
    await FirebaseFirestore.instance
          .collection("trainers")
          .where("active", isEqualTo: true)
          .where("teachdays", isEqualTo: prequently)
          .get()
          .then((QuerySnapshot snapshot){
            snapshot.docs.forEach((DocumentSnapshot doc) { 
              ptIDs.add(doc.reference.id);
            });
          });
  }

  Future<List<QueryDocumentSnapshot>> getPTByPurpose() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("trainers")
        .where("active", isEqualTo: true)
        .get();
    return snapshot.docs;
  }

  String teachdays = " ";

  @override
  void initState() {
    getUserByEmail(user?.email);
    getPT();
    // getPurpose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: FutureBuilder(
        future: getPT(),
        builder: (context, snapshot) {
            return ListView.builder(
              itemCount: ptIDs.length,
              itemBuilder: (context, index) {
                  return ListTile(
                    title: Container(
                      height: 120,
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: GetPT(ptID: ptIDs[index]),
                    ),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PTDetail()));
                    },
                  );
              },
            );
        },
      ),
    );
  }
}
