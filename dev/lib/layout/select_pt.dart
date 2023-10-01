import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/tablayout/get_pt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChoosePT extends StatefulWidget {
  const ChoosePT({super.key});

  @override
  State<ChoosePT> createState() => _ChoosePTState();
}

class _ChoosePTState extends State<ChoosePT> {

  final user = FirebaseAuth.instance.currentUser;
   String id = " ";
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

  List<String> ptIDs = [];
  Future getPT() async {
    await FirebaseFirestore.instance
        .collection("trainers")
        .where("active", isEqualTo: true)
        .where("teachdays", isEqualTo: prequently)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        ptIDs.add(doc.reference.id);
      });
    });
  }

  @override
  void initState() {
    getUserByEmail(user?.email);
    getPT();
    // getPurpose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DANH SÁCH PT'),
      ),
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
                  );
              },
            );
        },
      ),
    );
  }
}