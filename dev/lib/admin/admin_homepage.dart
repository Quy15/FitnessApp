import 'package:dev/admin/admin_manage_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../layout/login.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trang quản trị"),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
              onPressed: () {
                signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
                child: Icon(
              Icons.settings,
              size: 48,
            )),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("DUYỆT ỨNG VIÊN PT"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'admin_manage_user');
              },
            )
          ],
        ),
      ),
    );
  }
}
