import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/layout/login.dart';
import 'package:dev/tablayout/tab_chat.dart';
import 'package:dev/tablayout/tab_chatpt.dart';
import 'package:dev/tablayout/tab_home.dart';
import 'package:dev/tablayout/tab_homept.dart';
import 'package:dev/tablayout/tab_setting.dart';
import 'package:dev/tablayout/tab_setting_pt.dart';
import 'package:dev/tablayout/tab_training.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../tablayout/tab_homept.dart';

class TrainerHomePage extends StatefulWidget {
  const TrainerHomePage({super.key});

  _TrainerHomePageState createState() => _TrainerHomePageState();
}

void signOut() async {
  await FirebaseAuth.instance.signOut();
}


class _TrainerHomePageState extends State<TrainerHomePage>{


  final screen = [HomePT(), Training(), ChatPT(), SettingPT()];
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
                  GButton(icon: Icons.home, text: 'Trang chủ',),
                  GButton(icon: Icons.fact_check_sharp, text: 'Bài tập',),
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
