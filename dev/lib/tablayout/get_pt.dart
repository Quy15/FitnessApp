import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetPT extends StatelessWidget {
  final String ptID;
  const GetPT({super.key, required this.ptID});

  @override
  Widget build(BuildContext context) {

    CollectionReference reference = FirebaseFirestore.instance.collection("trainers");

    return FutureBuilder<DocumentSnapshot>(
      future: reference.doc(ptID).get(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text("Tên: "),
                            Text(data['name']),
                          ]),
                          Row(children: [
                            Text("Kinh nghiệm: "),
                            Text(data['experience']),
                          ]),
                          Row(children: [
                            Text("Email: "),
                            Text(data['email']),
                          ]),
                          Row(children: [
                            Text("Số điện thoại: "),
                            Text(data['mobile']),
                          ]),
                        ],
                      );
        }else{
          return Container();
        }
      });
  }
}