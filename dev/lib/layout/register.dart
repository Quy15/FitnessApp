import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/auth.dart';
import 'package:dev/layout/home.dart';
import 'package:dev/layout/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
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

  String? ma;
  bool hidePass = true;
  bool createUserSuccess = true;
  @override
  void dispose() {
    _emailText.dispose();
    _passWord.dispose();
    _name.dispose();
    _phone.dispose();
    _confirm.dispose();
    super.dispose();
  }


  final DatabaseReference _dbref = FirebaseDatabase.instance.ref('users');

  Future signUp(String mail, String pass, String name, String phone) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: mail, password: pass);
      addUser(name,phone, mail, pass);
      return createUserSuccess;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToastAlreadyExistEmail();
        createUserSuccess = false;
        return createUserSuccess;
      }
    } catch (e) {
      showToastUnexpectedError();
      print(e);
      createUserSuccess = false;
      return createUserSuccess;
    }

  }

  Future addUser(String name, String phone, String email, String pass) async {
    await FirebaseFirestore.instance.collection('users').doc().set({
      'id': FirebaseFirestore.instance.collection('users').doc().id,
      'name': name,
      'phone': phone,
      'email': email,
      'password': pass,
      'isAnswer': false,
      'type': "user",
    });
  }

  bool checkPass(String pw, String confirm) {
    if (pw == confirm) {
      return true;
    } else {
      return false;
    }
  }

  void showToastSuccess() {
    Fluttertoast.showToast(
      msg:
          'Thông tin của bạn đã được ghi nhận, vui lòng đợi thông tin gửi về mail',
    );
  }

  void showToastValidation() {
    Fluttertoast.showToast(
      msg: 'Vui lòng nhập đầy đủ thông tin',
    );
  }

  void showToastValidationEmail() {
    Fluttertoast.showToast(
      msg: 'Email không hợp lệ',
    );
  }

  void showToastValidationPhone() {
    Fluttertoast.showToast(
      msg: 'Số điện thoại không hợp lệ',
    );
  }

  void showToastValidationConfirmPassword() {
    Fluttertoast.showToast(
      msg: 'Xác nhận mật khẩu không chính xác',
    );
  }
  void showToastUnexpectedError() {
    Fluttertoast.showToast(
      msg: 'Đã có lỗi bất thường xảy ra, vui lòng thử lại sau ',
    );
  }
  void showToastAlreadyExistEmail() {
    Fluttertoast.showToast(
      msg: 'Đã có tài khoản đăng ký email này, quý khách vui lòng đổi email khác',
    );
  }

  bool isPhoneNoValid(String? phoneNo) {
    if (phoneNo == null) return false;
    final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    return regExp.hasMatch(phoneNo);
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
              // Padding(
              //   padding: const EdgeInsets.only(top: 45),
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => Login()));
              //     },
              //     child: Icon(Icons.arrow_back_ios),
              //   ),
              // ),
              Container(
                padding: EdgeInsets.only(left: 50, top: 70, right: 35),
                child: Text(
                  'Đăng ký tài khoản',
                  style: TextStyle(color: Colors.black, fontSize: 33),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 130, right: 35, left: 35),
                  child: Column(
                    children: [
                      TextField(
                        controller: _name,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Họ tên',
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
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextField(
                        obscureText: hidePass,
                        controller: _passWord,
                        decoration: InputDecoration(
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
                            labelText: 'Mật khẩu',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      new FlutterPwValidator(
                          controller: _passWord,
                          minLength: 6,
                          uppercaseCharCount: 1,
                          specialCharCount: 1,
                          width: 400,
                          height: 100,
                          onSuccess: () {
                          },
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        obscureText: hidePass,
                        controller: _confirm,
                        decoration: InputDecoration(
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
                            labelText: 'Xác nhận mật khẩu',
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
                            labelText: 'Số điện thoại',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 30,
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
                                if (_name.text.trim() == null ||
                                    _phone.text.trim() == null ||
                                    _emailText.text.trim() == null ||
                                    _passWord.text.trim() == null ||
                                    _confirm.text.trim() == null) {
                                  showToastValidation();
                                } else if (!EmailValidator.validate(
                                    _emailText.text.trim())) {
                                  showToastValidationEmail();
                                } else if (!isPhoneNoValid(
                                    _phone.text.trim())) {
                                  showToastValidationPhone();
                                } else if (!checkPass(_passWord.text.trim(), _confirm.text.trim())) {
                                  showToastValidationConfirmPassword();
                                } else {
                                  signUp(_emailText.text.trim(),_passWord.text.trim(),_name.text.trim(),_phone.text.trim());
                                  if (createUserSuccess){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Home()));
                                    Fluttertoast.showToast(
                                      msg: 'Tạo tài khoản thành công',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 2,
                                      textColor: Colors.white,
                                      backgroundColor: Colors.greenAccent,
                                      fontSize: 20,
                                    );
                                  }
                                }
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Bạn đã có tài khoản",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Login()));
                              },
                              child: Text(
                                "Đăng nhập ngay",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ))
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
