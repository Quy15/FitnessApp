import 'package:dev/layout/login.dart';
import 'package:flutter/material.dart';

class Exam extends StatefulWidget {
  const Exam({super.key});

  _ExamState createState() => _ExamState();
}

class _ExamState extends State<Exam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(children: [
          Container(
            padding: EdgeInsets.only(top: 140, left: 50),
            child: Text(
              'MỤC TIÊU TẬP LUYỆN',
              style: TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 250, left: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(255, 58, 219, 206), width: 3),
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 58, 219, 206)
                      ),
                      child: TextButton(
                        child: Text('Tăng cơ giảm mỡ', style: TextStyle(color: Colors.black),),
                        onPressed: () {
                          Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Login()));
                        },
                      ),
                    ),
                    SizedBox(width: 20,),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(255, 58, 219, 206), width: 3),
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 58, 219, 206)
                      ),
                      child: TextButton(
                        child: Text('Tăng cơ giảm mỡ', style: TextStyle(color: Colors.black),),
                        onPressed: () {
                          Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Login()));
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(255, 58, 219, 206), width: 3),
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 58, 219, 206)
                      ),
                      child: TextButton(
                        child: Text('Tăng cơ giảm mỡ', style: TextStyle(color: Colors.black),),
                        onPressed: () {
                          Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Login()));
                        },
                      ),
                    ),
                    SizedBox(width: 20,),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(255, 58, 219, 206), width: 3),
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 58, 219, 206)
                      ),
                      child: TextButton(
                        child: Text('Tăng cơ giảm mỡ', style: TextStyle(color: Colors.black),),
                        onPressed: () {
                          Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Login()));
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60,),
                ElevatedButton( 
                  onPressed: (){}, 
                  child: Text(
                    'Hoàn tất',))
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
