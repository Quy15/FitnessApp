import 'package:dev/layout/change_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
        title: 'Thông tin tài khoản',
        leading: Container(
            padding: EdgeInsets.all(6),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.green),
            child: Icon(
              Icons.person,
              color: Colors.white,
            )),
        child: SettingsScreen(
          title: 'Cài đặt thông tin',
          children: [
            SizedBox(
              height: 20,
            ),
            Icon(
              Icons.person,
              size: 72,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Họ tên',
              style: TextStyle(color: Colors.grey[600], fontSize: 20),
              textAlign: TextAlign.center,
            ),
            buildChangePassword(),
            buildUserInfo()
          ],
        ));
  }

  Widget buildChangePassword() => SimpleSettingsTile(
        title: 'Đổi mật khẩu',
        subtitle: '',
        leading: Container(
            padding: EdgeInsets.all(6),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
            child: Icon(
              Icons.key,
              color: Colors.white,
            )),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ChangePassword()));
        },
      );

  Widget buildUserInfo() => SimpleSettingsTile(
        title: 'Thông tin người dùng',
        subtitle: '',
        leading: Container(
            padding: EdgeInsets.all(6),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
            child: Icon(
              Icons.info,
              color: Colors.white,
            )),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ChangePassword()));
        },
      );
}
