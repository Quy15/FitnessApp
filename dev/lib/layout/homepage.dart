import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/layout/login.dart';
import 'package:dev/tablayout/tab_chat.dart';
import 'package:dev/tablayout/tab_home.dart';
import 'package:dev/tablayout/tab_setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  _HomePageState createState() => _HomePageState();
}

void signOut() async {
  await FirebaseAuth.instance.signOut();
}


class _HomePageState extends State<HomePage>{
  
  final screen = [HomeTab(), Chat(), Setting()];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screen[index],
         bottomNavigationBar: Container(
          color: Colors.black,
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
             child: GNav(
              backgroundColor: Colors.black,
              activeColor: Colors.white,
              color: Colors.white,
              padding: EdgeInsets.all(16),
              tabBackgroundColor: Colors.grey.shade800,
              onTabChange: (index) {
                setState(() {
                  this.index = index;
                });
              },
              gap: 8,
              tabs: [
                GButton(icon: Icons.home, text: 'Trang chủ',),
                GButton(icon: Icons.chat_bubble, text: 'Chat',),
                GButton(icon: Icons.settings, text: 'Cài đặt',),
              ]
              ),
           ),
         ),
        ),
    );
  }
}
