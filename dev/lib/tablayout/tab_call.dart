import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class Call extends StatefulWidget {
  const Call({super.key});

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {

  final user = FirebaseAuth.instance.currentUser;

  String callID = "1";
  String id = " ";
  String name = " ";
  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          id = doc.reference.id;
          this.name = '${doc['email']}';
          print(id);
          print(name);
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            child: Text('Alooooooooooo'),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CallView(callID: callID, username: name)));
            },
          ),
        ),
      ),
    );
  }
}

class CallView extends StatelessWidget {
  const CallView({super.key, required this.callID ,required this.username});

  final String username;
  final String callID;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 1124791011,
      appSign: "fdc9fe33cb1ee790ecaf4beffb456971e29b998776a06f70a2f147f38b998a53",
      userID: username,
      userName: username,
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
    );
  }
}