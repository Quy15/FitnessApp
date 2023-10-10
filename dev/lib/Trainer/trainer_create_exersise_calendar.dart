import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TrainerCreateExersiseCalendarPage extends StatefulWidget {
  final String uid;
  const TrainerCreateExersiseCalendarPage({Key? key, required this.uid})
      : super(key: key);
  @override
  _TrainerCreateExersiseCalendarPageState createState() =>
      _TrainerCreateExersiseCalendarPageState();
}

List<String> exerciseNames = [];

class _TrainerCreateExersiseCalendarPageState
    extends State<TrainerCreateExersiseCalendarPage> {
  final user = FirebaseAuth.instance.currentUser;

  final _dateOfBirth = TextEditingController();
  String userName = "";
  String selectedExerciseName = "";
  Future getUserByUid(String? uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: uid)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          // id = doc.reference.id;
          this.userName = '${doc['name']}';
        });
      });
    });
  }

  

  void addExersiseToUser(DateTime dob, String nameExsersise) async {
    String user_uid = '${widget.uid}'; // Đây là uid của người dùng
    String? pt_uid = user?.uid; // Đây là uid của người dùng
    String rep = "";
    String set = "";
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');

     await FirebaseFirestore.instance
        .collection("exersise")
        .where("name", isEqualTo: nameExsersise)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        rep = '${doc['rep']}';
        set = '${doc['set']}';
        print(rep);
        print(set);
      });
    });

    userCollection.doc(user_uid).collection('exersise_calendar').add({
      'user_id': user_uid,
      'pt_id': pt_uid,
      'created_date': DateTime.now(),
      'date': dob,
      'name': nameExsersise,
      'set': set,
      'rep': rep
    });
    showToastSuccess();
  }

  void getExersiseOfUser() async {
    String user_uid = '${widget.uid}'; // Đây là uid của người dùng
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    userCollection.doc(user_uid).collection('exersise_calendar').get();
  }

  @override
  void initState() {
    getUserByUid('${widget.uid}');
    getExerciseNamesStream('${widget.uid}').listen((List<String> data) {
      if (data.isNotEmpty) {
        setState(() {
          selectedExerciseName = data.first;
        });
      }
    });
    super.initState();
  }

  Stream<List<String>> getExerciseNamesStream(String? uid) {
    return FirebaseFirestore.instance
        .collection('exersise')
        .where('pt_uid', isEqualTo: user?.uid)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<String> exerciseNames = [];
      querySnapshot.docs.forEach((doc) {
        var name = doc['name'] as String;
        exerciseNames.add(name);
      });
      return exerciseNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Tạo lịch tập cho học viên",
              style: TextStyle(color: Colors.black, fontSize: 25)),
          backgroundColor: Color(0xFF9FE7F5),
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Container(
                height: 800,
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      width: size,
                      decoration: BoxDecoration(
                        color: Color(0xFF9FE7F5),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(70.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Hãy tạo lịch tập luyện cho ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 35)),
                              Text(userName,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 35)),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      DateTime? selectedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(3000),
                                      );
                                      if (selectedDate != null) {
                                        // Cập nhật giá trị ngày sinh vào controller
                                        setState(() {
                                          _dateOfBirth.text =
                                              "${selectedDate.toLocal()}"
                                                  .split(' ')[0];
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(Color(
                                              0xFF9FE7F5)), // Đặt màu nền cho nút
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Ngày tập ',
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.black),
                                          ),
                                          Icon(
                                            Icons.calendar_today,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                      width: 200,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.lightBlueAccent
                                              .shade100, // Màu border
                                          width: 2.0, // Độ rộng của border
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _dateOfBirth.text.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30),
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text('Bài tập ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 33)),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Container(
                                    width: 300,
                                    child: StreamBuilder<List<String>>(
                                      stream: getExerciseNamesStream(
                                          '${widget.uid}'),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text('Lỗi: ${snapshot.error}');
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return Text('Không có dữ liệu');
                                        } else {
                                          exerciseNames = snapshot.data!;

                                          // Xây dựng DropdownButton bằng danh sách tên
                                          return DropdownButton<String>(
                                            value: selectedExerciseName,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedExerciseName =
                                                    newValue!;
                                              });
                                            },
                                            isExpanded: false,
                                            items: exerciseNames
                                                .map<DropdownMenuItem<String>>(
                                                    (String name) {
                                              return DropdownMenuItem<String>(
                                                value: name,
                                                child: Text(
                                                  name,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 28),
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    addExersiseToUser(
                                        DateTime.parse(_dateOfBirth.text),
                                        selectedExerciseName);
                                    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
                                    print(_dateOfBirth.text);
                                    print(selectedExerciseName);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(
                                            0xFF9FE7F5)), // Đặt màu nền cho nút
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Tạo lịch tập',
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 490,
                      width: size,
                      decoration: BoxDecoration(
                        // color: Colors.lightBlueAccent[200],
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(70.0),
                        ),
                      ),
                    ),
                  ],
                ))));
  }
}

void showToastSuccess() {
  Fluttertoast.showToast(
    msg: 'Tạo bài tập thành công',
  );
}
