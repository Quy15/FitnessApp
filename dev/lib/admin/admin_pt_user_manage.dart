import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'admin_pt_tab_configure.dart';
import 'admin_user_tab_configure.dart';


class AdminPTUserManagePage extends StatefulWidget {
  const AdminPTUserManagePage({super.key});

  _AdminPTUserManagePageState createState() => _AdminPTUserManagePageState();
}

void signOut() async {
  await FirebaseAuth.instance.signOut();
}


class _AdminPTUserManagePageState extends State<AdminPTUserManagePage>{


  final screen = [AdminPTTabConfigure(), AdminUserTabConfigure()];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screen[index],
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: GNav(
                backgroundColor: Colors.white,
                activeColor: Colors.black,
                color: Colors.grey,
                padding: EdgeInsets.all(16),
                tabBackgroundColor: Colors.grey.shade300,
                onTabChange: (index) {
                  setState(() {
                    this.index = index;
                  });
                },
                gap: 8,
                tabs: [
                  GButton(icon: Icons.home, text: 'Quản lý tài khoản người dùng',),
                  GButton(icon: Icons.fact_check_sharp, text: 'Quản lý tài khoản PT',),
                ]
            ),
          ),
        ),
      ),
    );
  }
}
