import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/Trainer/trainer_homepage.dart';
import 'package:dev/auth.dart';
import 'package:dev/admin/admin_homepage.dart';
import 'package:dev/layout/auth_page.dart';
import 'package:dev/layout/home.dart';
import 'package:dev/layout/homepage.dart';
import 'package:dev/layout/my_auth.dart';
import 'package:dev/layout/pt_page.dart';
import 'package:dev/layout/register.dart';
import 'package:dev/layout/register_pt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  String? errorMessage;
  bool hidePass = true;
  String? admin = "admin";
  String? user = "user";
  String? trainer = "trainer";

  final _email = TextEditingController();
  final _pass = TextEditingController();
  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> signInWithEmailAndPassWord(String email, String pw) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pw);
      String? userType = await getTypeByEmailUser(email);
      String? trainerType = await getTypeByEmailTrainer(email);
      if (userType == admin) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AdminHomePage()));
        clearTextField();
      }
      if (userType == user) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage()));
        clearTextField();
      }
      if (trainerType == trainer) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TrainerHomePage()));
        clearTextField();
      }
      Fluttertoast.showToast(
        msg: 'Đăng nhập thành công',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        Fluttertoast.showToast(
          msg: 'Sai mật khẩu hoặc tài khoản',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          textColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 80, 182, 133),
          fontSize: 20,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Đăng nhập thất bại',
        );
      }
    }
  }

  Future<String?> getTypeByEmailUser(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0]['type'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Lỗi khi truy vấn Firestore: $e');
      return null;
    }
  }

  Future<String?> getTypeByEmailTrainer(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('trainers')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0]['type'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Lỗi khi truy vấn Firestore: $e');
      return null;
    }
  }
  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg:
            'Vui lòng kiểm tra mail để đổi mật khẩu\nNếu chưa nhận được, vui lòng kiểm tra lại mail đã nhập',
      );
    } on FirebaseAuthException catch (e) {
      if (email == null) {
        Fluttertoast.showToast(
          msg: 'Vui lòng nhập email để tiến hành gửi mail đổi mật khẩu',
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Vui lòng kiểm tra lại email',
        );
      }
    }
  }

 

  void clearTextField() {
    _email.clear();
    _pass.clear();
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
                padding: const EdgeInsets.only(top: 135, left: 120, right: 50),
                child: Container(
                  child: Text(
                    'Đăng nhập hệ thống',
                    style: TextStyle(color: Colors.black, fontSize: 33,),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 270, right: 35, left: 35),
                  child: Column(
                    children: [
                      TextField(
                        controller: _email,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_rounded,
                              color: Colors.black,
                            ),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Nhập tài khoản',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: _pass,
                        obscureText: hidePass,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            suffixIcon: IconButton(
                              icon: hidePass
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: Colors.black,
                                    )
                                  : Icon(Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  hidePass = !hidePass;
                                });
                              },
                            ),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Nhập mật khẩu',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              resetPassword(_email.text.trim());
                            },
                            child: Text(
                              'Quên mật khẩu',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xff4c505b),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xff4c505b),
                            child: IconButton(
                              color: Colors.white,
                              onPressed: () {
                                signInWithEmailAndPassWord(
                                    _email.text.trim(), _pass.text.trim());
                                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => AuthPage()));
                              },
                              icon: Icon(Icons.arrow_forward),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Register()));
                            },
                            child: const Text(
                              'Đăng ký',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xff4c505b),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RegisterPT()));
                            },
                            child: Text(
                              'Đăng ký PT',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xff4c505b),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
