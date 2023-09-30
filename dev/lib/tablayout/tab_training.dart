import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tạo lịch tập"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[300],
      body: IconButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Tạo bài tập',
                      style: TextStyle(color: Colors.black, fontSize: 23),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      // controller: _name,
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
                      // controller: _name,
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
                      // controller: _name,
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
                      items: level.map<DropdownMenuItem<String>>((String value) {
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
                      items: muscleGroup.map<DropdownMenuItem<String>>((String value) {
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
                      items: equipments.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Lưu'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.black,
          size: 32.0,
        ),
      ),
    );
  }
}
