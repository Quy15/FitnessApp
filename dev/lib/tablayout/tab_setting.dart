import 'package:dev/layout/account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => SettingState();
}

void signOut() {
  FirebaseAuth.instance.signOut();
}

class SettingState extends State<Setting> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          // padding: EdgeInsets.all(24),
          children: [
            Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                  child: Center(
                      child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.black,
                              ),
                              Positioned(
                                bottom: 40,
                                left:40,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                      )),
                ),
                SettingsGroup(
                  titleTextStyle: TextStyle(fontSize: 0),
                  title: "",
                  children: <Widget>[
                    AccountPage(),
                  ],
                ),
              ],
            ),
            SizedBox(
                height: 20,
                child: Container(
                  color: Colors.grey[200], // Đặt màu nền cho Container
                )),
            SettingsGroup(
              titleTextStyle: TextStyle(fontSize: 0),
              title: "",
              children: <Widget>[
                buildBugFeed(),
                buildFeedBack(),
              ],
            ),
            SizedBox(
              height: 20,
              child: Container(
                color: Colors.grey[200], // Đặt màu nền cho Container
              ),
            ),
            SettingsGroup(
              titleTextStyle: TextStyle(fontSize: 0),
              title: "",
              children: <Widget>[
                buildDelete(),
                buildLogout(),
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
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
            child: Icon(
              Icons.logout,
              color: Colors.white,
            )),
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
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.pink),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            )),
        onTap: () {},
      );

  Widget buildBugFeed() => SimpleSettingsTile(
        title: 'Báo lỗi',
        subtitle: '',
        leading: Container(
            padding: EdgeInsets.all(6),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: Icon(
              Icons.bug_report,
              color: Colors.white,
            )),
        onTap: () {},
      );

  Widget buildFeedBack() => SimpleSettingsTile(
        title: 'Gửi đánh giá',
        subtitle: '',
        leading: Container(
            padding: EdgeInsets.all(6),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.purple),
            child: Icon(
              Icons.feedback,
              color: Colors.white,
            )),
        onTap: () {},
      );
}
