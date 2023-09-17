import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  Text(
                    'Chào mừng bạn đến với HealthApp',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Để bắt đầu hãy cho chúng tôi biết một chút thông tin của bạn',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 320, left: 50, right: 50),
              child: Column(
                children: [
                  TextField(
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                        border: myInputBorder(),
                        enabledBorder: myInputBorder(),
                        focusedBorder: myInputBorder(),
                        labelText: 'Cân nặng',
                        labelStyle: TextStyle(color: Colors.deepPurple),
                        hintText: 'kg',
                        hintStyle: TextStyle(color: Colors.deepPurple),
                        alignLabelWithHint: true),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextField(
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                        border: myInputBorder(),
                        enabledBorder: myInputBorder(),
                        focusedBorder: myInputBorder(),
                        labelText: 'Chiều cao',
                        labelStyle: TextStyle(color: Colors.deepPurple),
                        hintText: 'cm',
                        hintStyle: TextStyle(color: Colors.deepPurple),
                        alignLabelWithHint: true),
                  ),
                  SizedBox(height: 60),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'continue');
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Color(0xff44A3AE),
                          Color(0xff33FBC9),
                        ]),
                      ),
                      width: size.width,
                      child: Text(
                        'Tiếp tục',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

OutlineInputBorder myInputBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.deepPurple, width: 3));
}
