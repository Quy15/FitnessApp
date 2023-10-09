import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminGetUser extends StatefulWidget {
  final String uID;
  const AdminGetUser({super.key, required this.uID});

  _AdminGetUserState createState() => _AdminGetUserState();
}

class _AdminGetUserState extends State<AdminGetUser> {
  @override
  Widget build(BuildContext context) {
    CollectionReference reference =
        FirebaseFirestore.instance.collection("users");

    return FutureBuilder<DocumentSnapshot>(
        future: reference.doc(widget.uID).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(
                'Đang tải danh sách .... ');
          } else {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(
                    "Tên: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(data['name'], style: TextStyle(fontSize: 20)),
                ]),
                Row(children: [
                  Text("Email: ", style: TextStyle(fontSize: 20)),
                  Text(data['email'], style: TextStyle(fontSize: 20)),
                ]),
                Row(children: [
                  Text("Số điện thoại: ", style: TextStyle(fontSize: 20)),
                  Text(data['phone'], style: TextStyle(fontSize: 20)),
                ]),
              ],
            );
          }
        });
  }
}