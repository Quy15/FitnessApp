import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                height: 1100,
                child: Column(
                  children: [
                    Container(
                      height: 310,
                      width: size,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[100],
                        borderRadius: BorderRadius.all(
                          Radius.circular(70),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Text('LỊCH TẬP LUYỆN CỦA BẠN ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 35)),
                                    SizedBox(height: 10,),
                                    Text(userName,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 35)),
                                  ],
                                ),
                              ),
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
                                          MaterialStateProperty.all(Colors.lightBlue[100]), // Đặt màu nền cho nút
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
                                                color: Colors.black, fontWeight: FontWeight.normal),
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
                                          color: Colors.black, fontSize: 30)),
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
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.lightBlue[100]), // Đặt màu nền cho nút
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
                      height: 750,
                      width: size,
                      decoration: BoxDecoration(
                        // color: Colors.lightBlueAccent[200],
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(70.0),
                        ),
                      ),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("users").doc(widget.uid)
                                  .collection("exersise_calendar").where("pt_id", isEqualTo: user?.uid).snapshots(),
                        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
                          if (snapshot.connectionState == ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator(),);
                          }else if (!snapshot.hasData || snapshot.data == null){
                            return Center(child: Text('Chưa có lịch tập cho người dùng này', style: TextStyle(fontSize: 20),),);
                          }else if (snapshot.data!.docs.isNotEmpty){
                            return ListView(
                              children: snapshot.data!.docs.map((document) => _buildCal(document)).toList(),
                            );
                          }else{
                            return Text("");
                          }
                        },
                      ),
                    ),
                  ],
                ))));
  }

  Widget _buildCal(DocumentSnapshot documentSnapshot){
     Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    Timestamp time = data['date'];
    DateTime d = time.toDate();
    String format = DateFormat('yyyy-MM-dd').format(d);
    return Container(
      height: 150,
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(children: [
            Text(
              "Ngày tập: ",
              style: TextStyle(fontSize: 25),
            ),
            Text(format, style: TextStyle(fontSize: 25)),
          ]),
          Row(children: [
            Text(
              "Tên: ",
              style: TextStyle(fontSize: 25),
            ),
            Text(data['name'], style: TextStyle(fontSize: 25)),
          ]),
          Row(children: [
            Text(
              "Số set: ",
              style: TextStyle(fontSize: 25),
            ),
            Text(data['set'], style: TextStyle(fontSize: 25)),
          ]),
          Row(children: [
            Text(
              "Số rep: ",
              style: TextStyle(fontSize: 25),
            ),
            Text(data['rep'], style: TextStyle(fontSize: 25)),
          ]),
        ],
      ),
    );
  }
}

void showToastSuccess() {
  Fluttertoast.showToast(
    msg: 'Tạo bài tập thành công',
  );
}
