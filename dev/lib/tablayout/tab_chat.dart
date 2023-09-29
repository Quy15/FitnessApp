import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/layout/chat_page.dart';
import 'package:dev/tablayout/tab_call.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

Future<List<QueryDocumentSnapshot>> getPTByPurpose() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection("trainers")
      .where("active", isEqualTo: true)
      .get();
  return snapshot.docs;
}

Future<List<QueryDocumentSnapshot>> getUser() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection("users")
      .get();
  return snapshot.docs;
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Lỗi hệ thống');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    //hiển thị toàn bộ user ngoại trừ người hiện tại
    if (FirebaseAuth.instance.currentUser!.email != data['email']) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Stack(alignment: Alignment.bottomRight, children: [
          CircleAvatar(
            radius: 30,
            child: Icon(Icons.person),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 5,
            ),
          ),
        ]),
        title: Text(
          data['name'],
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatPage(
                    receiveUserName: data['name'],
                    receiveUID: data['id'],
                  )));
        },
      );
    }else{
      return Container();
    }
  }
}
