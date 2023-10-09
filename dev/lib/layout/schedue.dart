import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/tablayout/get_pt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';




class Schedue extends StatefulWidget {
  const Schedue({super.key});

  _SchedueState createState() => _SchedueState();
}

class _SchedueState extends State<Schedue> {
  final user = FirebaseAuth.instance.currentUser;

  final ref = FirebaseFirestore.instance.collection("users");

  List<String> exIDS = [];
  Future getEx() async {
    await ref
        .doc(user?.uid)
        .collection("exersise_calendar")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        exIDS.add(doc.reference.id);
        print(exIDS);
      });
    });
  }


  @override
  void initState() {
    getEx();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lịch tập'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(user?.uid)
                .collection("exersise_calendar")
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData && snapshot.data == null) {
                return Text(
                    "Hiện tại bạn chưa có lịch tập! Liên hệ PT để nhận lịch");
              } else if (snapshot.data!.docs.isNotEmpty) {
                return ListView(
                  children: snapshot.data!.docs
                      .map((document) => _buildExItems(document))
                      .toList(),
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  Widget _buildExItems(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    Timestamp time = data['date'];
    DateTime d = time.toDate();
    String format = DateFormat('yyyy-MM-dd').format(d);
    return Container(
      height: 150,
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(children: [
            Text(
              "Ngày tập: ",
              style: TextStyle(fontSize: 25),
            ),
            Text(format, style: TextStyle(fontSize: 25)),
          ]),
          Row(children: [
            Text(
              "Tên: ",
              style: TextStyle(fontSize: 25),
            ),
            Text(data['name'], style: TextStyle(fontSize: 25)),
          ]),
          Row(children: [
            Text(
              "Số set: ",
              style: TextStyle(fontSize: 25),
            ),
            Text(data['set'], style: TextStyle(fontSize: 25)),
          ]),
          Row(children: [
            Text(
              "Số rep: ",
              style: TextStyle(fontSize: 25),
            ),
            Text(data['rep'], style: TextStyle(fontSize: 25)),
          ]),
        ],
      ),
    );
  }
}
