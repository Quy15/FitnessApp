import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/layout/schedue.dart';
import 'package:dev/layout/select_pt.dart';
import 'package:dev/push_noti/push_noti.dart';
import 'package:dev/tablayout/get_pt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  _HomeTab createState() => _HomeTab();
}

class _HomeTab extends State<HomeTab> {
  final user = FirebaseAuth.instance.currentUser;

  String id = " ";
  String uname = " ";
  String weight = " ";
  String height = " ";
  String tuoi = " ";
  String zIndex = " ";
  double bmi = 0;
  double cn = 0;
  double ccao = 0;
  double bmr = 0;
  double age = 0;
  String BMR = " ";
  String BMI = " ";
  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          id = '${doc['id']}';
          this.uname = '${doc['name']}';
          this.weight = '${doc['weight(kg)']}';
          this.height = '${doc['height(cm)']}';
          this.tuoi = '${doc['age']}';
          this.zIndex = '${doc['z-index']}';
          this.cn = double.parse(this.weight);
          this.ccao = double.parse(this.height);
          this.age = double.parse(this.tuoi);
          print(id);
          print(weight);
          print(height);
          print(tuoi);
          print(zIndex);
        });
      });
    });
  }

  String bmiCal() {
    bmi = cn / (ccao * ccao);
    BMI = bmi.toStringAsFixed(2);
    return BMI;
  }

  String bmrCal() {
    bmr = 10 * cn + 6.25 * (ccao * 100) - 5 * age + 5;
    BMR = bmr.toStringAsFixed(0);
    return BMR;
  }

  double tdee = 0;
  String TDEE = " ";
  String tdeeCal() {
    if (zIndex == "Ít vận động") {
      tdee = bmr * 1.2;
    }
    if (zIndex == 'Vận động nhẹ') {
      tdee = bmr * 1.375;
    }
    if (zIndex == 'Vận động vừa') {
      tdee = bmr * 1.55;
    }
    if (zIndex == 'Vận động nhiều') {
      tdee = bmr * 1.725;
    }
    if (zIndex == 'Vận động nặng') {
      tdee = bmr* 1.9;
    }
    TDEE = tdee.toStringAsFixed(0);
    return TDEE;
  }

  Future<List<QueryDocumentSnapshot>> getPTByPurpose() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("trainers")
        .where("active", isEqualTo: true)
        .get();
    return snapshot.docs;
  }

  String teachdays = " ";

  @override
  void initState() {
    getUserByEmail(user?.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Xin chào " + uname,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  CircleAvatar(
                    child: Icon(
                      Icons.person,
                      size: 40,
                    ),
                    radius: 30,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Chỉ số cơ thể',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 500,
              height: 280,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 183, 164, 238)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "Cân nặng: ",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Text(
                            weight + " kg",
                            style: TextStyle(fontSize: 25),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Chiều cao: ",
                            style: TextStyle(fontSize: 25),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              height + " m",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("BMI: " + bmiCal(),
                            style: TextStyle(fontSize: 25)),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("BMR: " + bmrCal(),
                            style: TextStyle(fontSize: 25)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("TDEE: " + tdeeCal(), style: TextStyle(fontSize: 25)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Tiện ích dành cho bạn',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 5.0,
                              spreadRadius: 1.1,
                            ),
                          ]),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChoosePT()));
                          },
                          child: Icon(Icons.list_alt_outlined)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'PT được đề xuất',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 5.0,
                              spreadRadius: 1.1,
                            ),
                          ]),
                      child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Schedue()));
                          },
                          child: Icon(Icons.calendar_today)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Lịch tập',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
