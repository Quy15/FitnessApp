import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/auth.dart';
import 'package:dev/layout/home.dart';
import 'package:dev/layout/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final _emailText = TextEditingController();
  final _passWord = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose(){
    _emailText.dispose();
    _passWord.dispose();
    _name.dispose();
    _phone.dispose();
    _confirm.dispose();
    super.dispose();
  }

  final DatabaseReference _dbref = FirebaseDatabase.instance.ref('users');
  

  Future signUp () async {
    if (checkPass()){
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailText.text.trim(), password: _passWord.text.trim()
      );

      addUser(_name.text.trim(), _phone.text.trim(), _emailText.text.trim());
    }
  }

  Future addUser(String name, String phone, String email) async{
    await FirebaseFirestore.instance.collection('users').add({
      'name': name,
      'phone': phone,
      'email': email
    });
  }

  bool checkPass(){
    if (_passWord.text.trim() == _confirm.text.trim()){
      return true;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/workout.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 45),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'login');
                  },
                  child: Icon(Icons.arrow_back_ios),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 50, top: 100, right: 35),
                child: Text(
                  'Đăng ký tài khoản',
                  style: TextStyle(color: Colors.black, fontSize: 33),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 170, right: 35, left: 35),
                  child: Column(
                    children: [
                      TextField(
                        controller: _name,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Nhập họ tên',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: _emailText,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Nhập email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextField(
                        obscureText: true,
                        controller: _passWord,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Nhập mật khẩu',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Xác nhận mật khẩu',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),    
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _phone,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Nhập SĐT',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Đăng kí',
                            style: TextStyle(
                                fontSize: 27, fontWeight: FontWeight.w700),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xff4c505b),
                            child: IconButton(
                              color: Colors.white,
                              onPressed: () {         
                                FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: _emailText.text,
                                        password: _passWord.text)
                                    .then((value) {
                                  addUser(_name.text.trim(), _phone.text.trim(), _emailText.text.trim());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                  Fluttertoast.showToast(
                                    msg: 'Tạo tài khoản thành công',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 2,
                                    textColor: Colors.white,
                                    backgroundColor: Colors.greenAccent,
                                    fontSize: 20,
                                  );
                                }).onError((error, stackTrace) {
                                  print("Error ${error.toString()}");
                                });
                              },
                              icon: Icon(Icons.arrow_forward),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
