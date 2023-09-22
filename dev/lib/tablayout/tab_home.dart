import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  _HomeTab createState() => _HomeTab();
}

class _HomeTab extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Container(
          padding: const EdgeInsets.all(15),
          height: 200,
          width: size.width * 0.35,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 5.0,
                  spreadRadius: 1.1,
                ),
              ],
              borderRadius: BorderRadius.circular(10)),
          child: Image(image: AssetImage('assets/nopainnogain.jpg')),
        ),
      ),
    );
  }
}
