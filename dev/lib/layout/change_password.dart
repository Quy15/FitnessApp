import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _oldPass = TextEditingController();
  final _newPass = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  void changePassword(email,oldpassword,newpassword) async {
      var cred = EmailAuthProvider.credential(email: email, password: oldpassword);
      await user!.reauthenticateWithCredential(cred).then((value) {
        user!.updatePassword(newpassword);
        // updatepassword();
        FirebaseAuth.instance.signOut();
      }).catchError((error){
        print(error.toString());
      });
  }

  String id = " ";
  String password = " ";
  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        id = doc.reference.id;
        print(id);       
      });
    });
  }

  // Future updatepassword() async {
  //   await FirebaseFirestore.instance.collection("users").doc(id).update({
  //     'password': _newPass.text.trim()
  //   });
  // }

  @override
  void initState() {
    getUserByEmail(user?.email);
    super.initState();
  }

  @override
  void dispose(){
    _oldPass.dispose();
    _newPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đổi mật khẩu'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: SafeArea(
          child: Column(
            children: [
              Text('Nhập mật khẩu cũ', 
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.left,),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _oldPass,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    hintText: 'Mật khẩu cũ',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 20,),
              Text('Nhập mật khẩu mới', 
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.left,),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _newPass,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    hintText: 'Mật khẩu cũ',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  changePassword(
                      user!.email, _oldPass.text.trim(), _newPass.text.trim()
                  );
                  print('Pass change');
                },
                child: Text('Đổi mật khẩu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}