import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Trainer/trainer_homepage.dart';

class Training extends StatefulWidget {
  const Training({super.key});

  @override
  State<Training> createState() => TrainingState();
}

List<String> equipments = [
  'Tạ đơn',
  'Dây',
  'Thảm trải',
  'Dây nhảy',
];
List<String> muscleGroup = [
  'Bắp chân',
  'Lưng',
  'Tay sau',
  'Tay trước',
];
List<String> level = [
  'Dễ',
  'Trung bình',
  'Nâng cao',
];

class TrainingState extends State<Training> {
  String dropdownEquipment = equipments.first;
  String dropdownMuscleGroup = muscleGroup.first;
  String dropdownLevel = level.first;

  final _name = TextEditingController();
  final _set = TextEditingController();
  final _rep = TextEditingController();
  // final _level = TextEditingController();
  // final _muscleGroup = TextEditingController();
  // final _equipment = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _set.dispose();
    _rep.dispose();
    // _level.dispose();
    // _muscleGroup.dispose();
    // _equipment.dispose();
    super.dispose();
  }

  Future addExersise(String name, String set, String rep, String level,
      String muscleGroup, String equipment) async {
    final docEx = FirebaseFirestore.instance.collection('exersise').doc();
    final data = {
      'set': set,
      'rep': rep,
      'level': level,
      'name': name,
      'muscleGroup': muscleGroup,
      'equipment': equipment,
      'id': docEx.id,
    };
    await docEx.set(data);
  }

  void showToastSuccess() {
    Fluttertoast.showToast(
      msg: 'Tạo bài tập thành công',
    );
  }

  void showToastValidation() {
    Fluttertoast.showToast(
      msg: 'Vui lòng nhập đầy đủ thông tin',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tạo bài tập"),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.grey[100],
        body: Container(
            height: 700,
            child: Column(children: [
              Row(children: [
                OpenContainer(
                  transitionDuration: Duration(milliseconds: 500),
                  transitionType: ContainerTransitionType.fadeThrough,
                  closedBuilder: (context, action) => Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      // borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 32.0,
                    ),
                  ),
                  openBuilder: (context, action) => Container(
                    // child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Text(
                            'Tạo bài tập',
                            style: TextStyle(color: Colors.black, fontSize: 23),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextField(
                            controller: _name,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                labelText: 'Tên bài tập',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextField(
                            controller: _set,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                labelText: 'Số set',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextField(
                            controller: _rep,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                labelText: 'Số rep',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField<String>(
                            value: dropdownLevel,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            onChanged: (String? l) {
                              setState(() {
                                dropdownLevel = l!;
                              });
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              labelText: 'Cấp độ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: level
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField<String>(
                            value: dropdownMuscleGroup,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            onChanged: (String? muscle) {
                              setState(() {
                                dropdownMuscleGroup = muscle!;
                              });
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              labelText: 'Nhóm cơ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: muscleGroup
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField<String>(
                            value: dropdownEquipment,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            onChanged: (String? equip) {
                              setState(() {
                                dropdownEquipment = equip!;
                              });
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              labelText: 'Dụng cụ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: equipments
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_name.text.trim() == "" ||
                                  _set.text.trim() == "" ||
                                  _rep.text.trim() == "") {
                                showToastValidation();
                              } else {
                                addExersise(
                                    _name.text.trim(),
                                    _set.text.trim(),
                                    _rep.text.trim(),
                                    dropdownLevel,
                                    dropdownMuscleGroup,
                                    dropdownEquipment);
                                Navigator.pop(context);
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) => TrainerHomePage()));
                                showToastSuccess();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black54,
                              onPrimary: Colors.white,
                              padding: EdgeInsets.only(
                                  right: 90, left: 90, top: 15, bottom: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Lưu'),
                          ),
                        ],
                      ),
                    ),
                    // ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 130),
                  child: Text(
                    "Bài tập",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ]),
              ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      height: 550,
                      child: buildExerciseList(),
                    ),
                  ])
            ])));
  }
}

Future<List<QueryDocumentSnapshot>> getExersise() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('exersise').get();
    return querySnapshot.docs;
  } catch (e) {
    print('Lỗi khi truy vấn Firestore: $e');
    return [];
  }
}

Widget buildExerciseList() {
  return FutureBuilder<List<QueryDocumentSnapshot>>(
    future: getExersise(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Lỗi: ${snapshot.error}');
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(
          child: Text(
            'Hiện tại chưa có bài tập',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
        );
      } else {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var exersise = snapshot.data![index];
            var name = exersise['name'] as String;
            var set = exersise['set'] as String;
            var rep = exersise['rep'] as String;
            var level = exersise['level'] as String;
            var muscle = exersise['muscleGroup'] as String;
            var equipment = exersise['equipment'] as String;

            return buildExerciseListItem(
                name, set, rep, level, muscle, equipment);
          },
        );
      }
    },
  );
}

Widget buildExerciseListItem(String name, String set, String rep, String level,
    String muscle, String equipment) {
  return ListTile(
    title: Container(
      height: 130,
      width: 150,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text("Tên: "),
                Text(name),
              ]),
              Row(children: [
                Text("Set: "),
                Text(set),
              ]),
              Row(children: [
                Text("Rep: "),
                Text(rep),
              ]),
              Row(children: [
                Text("Level: "),
                Text(level),
              ]),
              Row(children: [
                Text("Nhóm cơ: "),
                Text(muscle),
              ]),
              Row(children: [
                Text("Dụng cụ: "),
                Text(equipment),
              ]),
            ],
          ),
        ],
      ),
    ),
  );
}
