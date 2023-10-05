import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/layout/select_pt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PTDetail extends StatefulWidget {
  const PTDetail({super.key, required this.ptId});
  final String ptId;

  _PTDetailState createState() => _PTDetailState();
}

class _PTDetailState extends State<PTDetail> {
  static const value = <String>['Gói ngày', 'Gói tuần', 'Gói tháng', 'Gói năm'];
  String selectedValue = value.first;
  List<String> packages = [];
  final selectedColor = Colors.green;
  final unselectedColor = Colors.grey;
  final user = FirebaseAuth.instance.currentUser;

  Widget radioWidget() => Column(
        children: value.map((value) {
          return RadioListTile<String>(
            value: value,
            groupValue: selectedValue,
            title: Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            onChanged: (value) => setState(() => selectedValue = value!),
          );
        }).toList(),
      );

  String id = " ";
  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        id = doc.reference.id;
      });
    });
  }

  String ptid = " ";
  final ref = FirebaseFirestore.instance.collection("trainers");
  getPT() async{
    DocumentSnapshot snapshot = await ref.doc(widget.ptId).get();
    ptid = snapshot['id'];
    print(snapshot['id']);
  }

  String pid = " ";
  // String pname = " ";
  // Future getPackage() async {
  //   await FirebaseFirestore.instance
  //       .collection("packages")
  //       .get()
  //       .then((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((DocumentSnapshot doc) {
  //       pid = doc.reference.id;
  //       this.pname = '${doc['name']}';
  //       packages.add(pid);
  //       print(pid);
  //     });
  //   });
  // }

  void setPackage(String select){
    if(select.contains("Gói ngày")){
      this.pid = 'K4Bexi49noYdkVeC8LYh';
    }else if (select.contains("Gói tuần")){
      this.pid = 'YrlUmjr09llwXJa6WC9A';
    }else if (select.contains("Gói tháng")){
      this.pid = 'd9lk43SUWnQ71qYc6sXK';
    }else if (select.contains("Gói năm")){
      this.pid = 'hWoTvATC7u1vGzolZZnt';
    }
  }


  Future savePT() async {
    List<String> callId = [id, ptid];
    callId.sort();
    String cid = callId.join("_");
    String cname = callId.join("_");    
    setPackage(selectedValue);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({'id_pt': ptid, 'id_package': pid, 'call_id': cid, 'call_name': cname});
  }

  Future saveUser() async {
    List<String> callId = [id, ptid];
    callId.sort();
    String cid = callId.join("_");
    String cname = callId.join("_");    
    setPackage(selectedValue);
    await FirebaseFirestore.instance
        .collection("trainers")
        .doc(widget.ptId)
        .update({'call_id': cid, 'call_name': cname});
  }


  


  @override
  void initState() {
    getUserByEmail(user?.email);
    getPT();
    // getPackage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference reference =
        FirebaseFirestore.instance.collection("trainers");

    return FutureBuilder<DocumentSnapshot>(
        future: reference.doc(widget.ptId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Thông tin PT'),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 60, left: 220),
                        child: CircleAvatar(
                          child: Icon(
                            Icons.person,
                            size: 50,
                          ),
                          radius: 50,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Thông tin cá nhân",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          width: 500,
                          height: 300,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: const Color.fromARGB(255, 63, 61, 61),
                                  width: 0.5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'Họ tên: ' + snapshot.data!['name'],
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'Email liên hệ: ' + snapshot.data!['email'],
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Chuyên môn: " +
                                      snapshot.data!['qualification'],
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Số ngày dạy trong tuần: " +
                                      snapshot.data!['teachdays'],
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Số tiền dạy 1 buổi: " +
                                      snapshot.data!['teachdays'],
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Chọn gói tập luyện",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: radioWidget(),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: SizedBox(
                                width: 200,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color.fromARGB(
                                          255, 128, 241, 132),
                                      side: BorderSide(
                                          width: 3,
                                          color: const Color.fromARGB(
                                              255, 128, 241, 132)),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onPressed: () {
                                    
                                    savePT();
                                    saveUser();
                                    Fluttertoast.showToast(
                                      msg: 'Đăng ký thành công',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 2,
                                      textColor: Colors.white,
                                      backgroundColor: const Color.fromARGB(
                                          255, 80, 182, 133),
                                      fontSize: 20,
                                    );
                                  },
                                  child: Text(
                                    'Đăng ký',
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.black),
                                  ),
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: SizedBox(
                                width: 200,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Color.fromARGB(255, 221, 90, 85),
                                      side: BorderSide(
                                          width: 3,
                                          color: const Color.fromARGB(
                                              255, 221, 90, 85)),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChoosePT()));
                                  },
                                  child: Text(
                                    'Hủy',
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.black),
                                  ),
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold();
          }
        });
  }
}
