import 'package:flutter/material.dart';

class Schedue extends StatelessWidget {
  const Schedue({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lịch tập'),
          centerTitle: true,
        ),
      ),
    );
  }
}