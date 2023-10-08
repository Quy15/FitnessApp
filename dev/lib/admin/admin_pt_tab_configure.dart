import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminPTTabConfigure extends StatefulWidget {
  const AdminPTTabConfigure({super.key});

  @override
  AdminPTTabConfigureState createState() => AdminPTTabConfigureState();
}

class AdminPTTabConfigureState extends State<AdminPTTabConfigure> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý tài khoản PT"),
        backgroundColor: Colors.lightBlueAccent[200],
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
