import 'package:dev/layout/account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State <Setting> createState() =>  SettingState();
}

void signOut() {
  FirebaseAuth.instance.signOut();
}

class  SettingState extends State <Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            SettingsGroup(
              titleTextStyle: TextStyle(fontSize: 20),
              title: "Cài đặt người dùng",
              children: <Widget>[
                AccountPage(),
                buildLogout(),
                buildDelete(),
              ],
            ),
            const SizedBox(height: 32,),
            SettingsGroup(
              titleTextStyle: TextStyle(fontSize: 20),
              title: "Phản hồi",
              children: <Widget>[
                buildBugFeed(),
                buildFeedBack(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLogout() => SimpleSettingsTile(
    title: 'Đăng xuất',
    subtitle: '',
    leading: Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueAccent
      ),
      child: Icon(Icons.logout, color: Colors.white,)),
    onTap: () {
        signOut();
        Navigator.pushNamed(context, 'login');
    },
  );

  Widget buildDelete() => SimpleSettingsTile(
    title: 'Xóa tài khoản',
    subtitle: '',
    leading: Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.pink
      ),
      child: Icon(Icons.delete, color: Colors.white,)),
    onTap: () {

    },
  );

  Widget buildBugFeed() => SimpleSettingsTile(
    title: 'Báo lỗi',
    subtitle: '',
    leading: Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red
      ),
      child: Icon(Icons.bug_report, color: Colors.white,)),
    onTap: () {
 
    },
  );

  Widget buildFeedBack() => SimpleSettingsTile(
    title: 'Gửi đánh giá',
    subtitle: '',
    leading: Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.purple
      ),
      child: Icon(Icons.feedback, color: Colors.white,)),
    onTap: () {

    },
  );
}