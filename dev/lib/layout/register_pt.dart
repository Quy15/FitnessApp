import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/layout/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPT extends StatefulWidget {
  const RegisterPT({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<RegisterPT> {
  final _emailText = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _active = TextEditingController();
  final _dateOfBirth = TextEditingController();
  final _experience = TextEditingController();
  final _qualification = TextEditingController();
  final _teachdays = TextEditingController();
  final _id = TextEditingController();

  @override
  void dispose() {
    _emailText.dispose();
    _name.dispose();
    _phone.dispose();
    _active.dispose();
    _dateOfBirth.dispose();
    _experience.dispose();
    _qualification.dispose();
    _teachdays.dispose();
    _id.dispose();
    super.dispose();
  }

  

  Future addUser(String name, String phone, String email, String experience,
      String qualification, DateTime dOB, String teachdays) async {
    final docPt = FirebaseFirestore.instance.collection('trainers').doc();
    final data = {
      'active': false,
      'date_of_birth': dOB,
      'experience': experience,
      'qualification': qualification,
      'name': name,
      'mobile': phone,
      'email': email,
      'id': docPt.id,
      'teachdays': teachdays,
      'type': "trainer",
    };
    await docPt.set(data);
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
              Container(
                padding: EdgeInsets.only(left: 110, top: 100, right: 35),
                child: Text(
                  'Đăng ký để trở thành Personal Trainer',
                  style: TextStyle(color: Colors.black, fontSize: 40),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 170, right: 35, left: 35),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
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
                        height: 50,
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
                        height: 50,
                      ),
                      TextField(
                        controller: _experience,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Kinh nghiệm làm việc',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextField(
                        controller: _qualification,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Chuyên môn',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: _dateOfBirth,
                        readOnly: true,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: 'Ngày sinh',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                // Cập nhật giá trị ngày sinh vào controller
                                _dateOfBirth.text =
                                    "${selectedDate.toLocal()}".split(' ')[0];
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
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
                        height: 50,
                      ),
                      TextField(
                        controller: _teachdays,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Số buổi có thể dạy',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_name.text.trim() == "" ||
                                _phone.text.trim() == "" ||
                                _emailText.text.trim() == "" ||
                                _experience.text.trim() == "" ||
                                _dateOfBirth.text == null) {
                              showToastValidation();
                            } else if (!EmailValidator.validate(
                                _emailText.text.trim())) {
                              showToastValidationEmail();
                            } else if (!isPhoneNoValid(_phone.text.trim())) {
                              showToastValidationPhone();
                            } else {
                              addUser(
                                  _name.text.trim(),
                                  _phone.text.trim(),
                                  _emailText.text.trim(),
                                  _experience.text.trim(),
                                  _qualification.text.trim(),
                                  DateTime.parse(_dateOfBirth.text),
                                  _teachdays.text.trim());
                              Navigator.pop(context);
                              showToastSuccess();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            padding: EdgeInsets.only(
                                right: 90, left: 90, top: 15, bottom: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text('Gửi đơn',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),),
                        ),
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
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Login()));
                              },
                              child: Text(
                                "Đăng nhập ngay",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ))
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
