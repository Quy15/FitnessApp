import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/layout/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser;
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _heathstatus = TextEditingController();
  final _prequentcy = TextEditingController();
  final _age = TextEditingController();
  bool isAnswer = false;

  static const values = <String>[
    'Tăng cơ / Giảm mỡ',
    'Tăng sức mạnh',
    'Tăng cân / Tăng cơ',
    'Thi đấu thể hình'
  ];
  String selectedValue = values.first;
  final selectedColor = Colors.green;
  final unselectedColor = Colors.grey;

  String _value = 'Chưa có kinh nghiệm';
  var _items = ['Chưa có kinh nghiệm', '3 tháng', '6 tháng', 'Trên 1 năm'];

  String _zIndex = 'Ít vận động';
  var _zindexs = [
    'Ít vận động',
    'Vận động nhẹ',
    'Vận động vừa',
    'Vận động nhiều',
    'Vận động nặng'
  ];

  String id = " ";
  String name = " ";
  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        id = doc.reference.id;
        setState(() {
          this.name = '${doc['name']}';
        });
      });
    });
  }

  Future addUserWH() async {
    await FirebaseFirestore.instance.collection("users").doc(id).update({
      'weight(kg)': _weight.text.trim(),
      'height(cm)': _height.text.trim(),
      'age': _age.text.trim(),
      'exp': _value,
      'z-index': _zIndex,
      'health_status': _heathstatus.text.trim(),
      'isAnswer': isAnswer
    });
  }

  Future addPurpose() async {
    await FirebaseFirestore.instance
        .collection("trainning_purpose")
        .doc(id)
        .set({'purpose': selectedValue, 'prequently': _prequentcy.text.trim(),'user_id': id});
  }

  Widget radioWidget() => Column(
        children: values.map((value) {
          return RadioListTile<String>(
            value: value,
            groupValue: selectedValue,
            title: Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            onChanged: (value) => setState(() => this.selectedValue = value!),
          );
        }).toList(),
      );

  @override
  void initState() {
    getUserByEmail(user?.email);
    super.initState();
  }

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
    _heathstatus.dispose();
    _prequentcy.dispose();
    _age.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/workout.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 80),
                  child: Column(
                    children: [
                      Text(
                        'Chào mừng ' + name + ' đến với HealthApp',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Để bắt đầu hãy cho chúng tôi biết một số thông tin của bạn',
                        style: TextStyle(fontSize: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                        child: Container(
                          width: 400,
                          height: 680,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(255, 255, 255, 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 5.0,
                                spreadRadius: 1.1,
                              ),
                            ],
                          ),
                          child: Column(children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'THÔNG TIN CỦA BẠN',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50, right: 50),
                              child: TextField(
                                controller: _weight,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    border: myInputBorder(),
                                    enabledBorder: myInputBorder(),
                                    focusedBorder: myInputBorder(),
                                    labelText: 'Cân nặng (theo kilogram)',
                                    labelStyle:
                                        TextStyle(color: Colors.deepPurple),
                                    hintStyle:
                                        TextStyle(color: Colors.deepPurple),
                                    alignLabelWithHint: true),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50, right: 50),
                              child: TextField(
                                controller: _height,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    border: myInputBorder(),
                                    enabledBorder: myInputBorder(),
                                    focusedBorder: myInputBorder(),
                                    labelText: 'Chiều cao (theo centimet)',
                                    labelStyle:
                                        TextStyle(color: Colors.deepPurple),
                                    hintStyle:
                                        TextStyle(color: Colors.deepPurple),
                                    alignLabelWithHint: true),
                              ),
                            ),
                            SizedBox(height: 40,),
                            Padding(
                              padding: const EdgeInsets.only(left: 50, right: 50),
                              child: TextField(
                                controller: _age,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    border: myInputBorder(),
                                    enabledBorder: myInputBorder(),
                                    focusedBorder: myInputBorder(),
                                    labelText: 'Tuổi',
                                    labelStyle:
                                        TextStyle(color: Colors.deepPurple),
                                    hintStyle:
                                        TextStyle(color: Colors.deepPurple),
                                    alignLabelWithHint: true),
                              ),
                            ),
                            SizedBox(height: 40),
                            Text(
                              'KINH NGHIỆM TẬP LUYỆN',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 20, left: 50, right: 50),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 4),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.black, width: 3),
                                    borderRadius: BorderRadius.circular(10)),
                                child: DropdownButton(
                                    items: _items.map((String item) {
                                      return DropdownMenuItem(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ));
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        this._value = value!;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    value: _value,
                                    icon: Icon(Icons.arrow_drop_down_rounded),
                                    iconSize: 40,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'CƯỜNG ĐỘ HOẠT ĐỘNG',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 3),
                                  borderRadius: BorderRadius.circular(10)),
                              child: DropdownButton(
                                  items: _zindexs.map((String index) {
                                    return DropdownMenuItem(
                                        value: index,
                                        child: Text(
                                          index,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ));
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      this._zIndex = value!;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  value: _zIndex,
                                  icon: Icon(Icons.arrow_drop_down_rounded),
                                  iconSize: 40,
                                  alignment: Alignment.center,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                        child: Container(
                          width: 400,
                          height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(255, 255, 255, 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 5.0,
                                spreadRadius: 1.1,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'MỤC TIÊU TẬP LUYỆN',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              radioWidget()
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                        child: Container(
                          width: 400,
                          height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(255, 255, 255, 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 5.0,
                                spreadRadius: 1.1,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'TÌNH TRẠNG SỨC KHOẺ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: size.width * 0.8,
                                child: TextField(
                                  controller: _heathstatus,
                                  maxLines: 10,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurpleAccent),
                                        borderRadius: BorderRadius.circular(10)),
                                    hintText: 'Tình trạng sức khỏe của bạn ....',
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                        child: Container(
                          width: 400,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(255, 255, 255, 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 5.0,
                                spreadRadius: 1.1,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'SỐ BUỔI CÓ THỂ TẬP TRONG MỘT TUẦN',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: size.width * 0.8,
                                child: TextField(
                                  controller: _prequentcy,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurpleAccent),
                                        borderRadius: BorderRadius.circular(10)),
                                    hintText: 'Tình trạng sức khỏe của bạn ....',
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 10),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              this.isAnswer = true;
                            });
                            addUserWH();
                            addPurpose();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomePage()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color(0xff44A3AE),
                                Color(0xff33FBC9),
                              ]),
                            ),
                            width: size.width * 0.8,
                            child: Text(
                              'HOÀN TẤT',
                              style: TextStyle(fontSize: 25, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

OutlineInputBorder myInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.deepPurple, width: 3),
  );
}
