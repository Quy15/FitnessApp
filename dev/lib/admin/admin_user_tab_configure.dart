import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminUserTabConfigure extends StatefulWidget {
  const AdminUserTabConfigure({super.key});

  @override
  AdminUserTabConfigureState createState() => AdminUserTabConfigureState();
}

class AdminUserTabConfigureState extends State<AdminUserTabConfigure> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý tài khoản người dùng"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
