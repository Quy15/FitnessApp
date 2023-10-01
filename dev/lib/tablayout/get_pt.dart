import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetPT extends StatelessWidget {
  final String ptID;
  const GetPT({super.key, required this.ptID});

  @override
  Widget build(BuildContext context) {
    CollectionReference reference =
        FirebaseFirestore.instance.collection("trainers");

    return FutureBuilder<DocumentSnapshot>(
        future: reference.doc(ptID).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
                  Text("Kinh nghiệm: ", style: TextStyle(fontSize: 20)),
                  Text(data['experience'], style: TextStyle(fontSize: 20)),
                ]),
                Row(children: [
                  Text("Email: ", style: TextStyle(fontSize: 20)),
                  Text(data['email'], style: TextStyle(fontSize: 20)),
                ]),
                Row(children: [
                  Text("Số điện thoại: ", style: TextStyle(fontSize: 20)),
                  Text(data['mobile'], style: TextStyle(fontSize: 20)),
                ]),
              ],
            );
          } else {
            return Text(
                'Đang tải danh sách .... Sau 5 giây nếu không có danh sách bạn hãy thoát ra vào lại nhé !');
          }
        });
  }
}
