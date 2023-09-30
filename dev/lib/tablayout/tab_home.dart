import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/layout/select_pt.dart';
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
  String prequently = " ";
  String weight = " ";
  String height = " ";
  double bmi = 0;
  double cn = 0;
  double ccao = 0;
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
          this.cn = double.parse(this.weight);
          this.ccao = double.parse(this.height);
          print(id);
          print(weight);
          print(height);
        });
      });
    });

    await FirebaseFirestore.instance
        .collection("trainning_purpose")
        .where("user_id", isEqualTo: id)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          this.prequently = '${doc['prequently']}';
        });
        print(prequently);
      });
    });
  }

  String bmiCal() {
    bmi = cn / (ccao * ccao);
    BMI = bmi.toStringAsFixed(2);
    return BMI;
  }

  // Future getPurpose() async {
  //   await FirebaseFirestore.instance
  //       .collection("trainning_purpose")
  //       .where("user_id", isEqualTo: id)
  //       .get()
  //       .then((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((DocumentSnapshot doc) {
  //       this.prequently = '${doc['purpose']}';
  //       print(prequently);
  //     });
  //   });
  // }

  List<String> ptIDs = [];

  Future getPT() async {
    await FirebaseFirestore.instance
        .collection("trainers")
        .where("active", isEqualTo: true)
        .where("teachdays", isEqualTo: prequently)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        ptIDs.add(doc.reference.id);
      });
    });
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
    getPT();
    // getPurpose();
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("BMI: " + bmiCal(),
                        style: TextStyle(fontSize: 25)),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("TDEE: ", style: TextStyle(fontSize: 25)),
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
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ChoosePT()));
                      },
                      child: Icon(Icons.list_alt_outlined)
                      ), 
                ),
                SizedBox(height: 5,),
                Text('PT được đề xuất', style: TextStyle(fontSize: 20),),
              ],
            )
          ],
        ),
      )),
    );
  }
}
