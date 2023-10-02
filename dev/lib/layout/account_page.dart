import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/layout/change_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final user = FirebaseAuth.instance.currentUser!;
  String id = " ";
  String name = " ";
  // DateTime dOB = " ";
  String email = " ";
  Future getTrainerByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("trainers")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        id = doc.reference.id;
        setState(() {
          this.name = '${doc['name']}';
          this.email = '${doc['email']}';
        });
      });
    });
  }

  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        id = doc.reference.id;
        setState(() {
          this.name = '${doc['name']}';
        });
      });
    });
  }

  @override
  void initState() {
    getTrainerByEmail(user?.email);
    getUserByEmail(user?.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
        title: 'Thông tin tài khoản',
        leading: Container(
            padding: EdgeInsets.all(6),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.green),
            child: const Icon(
              Icons.person,
              color: Colors.white,
            )),
        child: SettingsScreen(
          title: 'Cài đặt thông tin',
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
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
                    left: 210,
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '$name',
              style: TextStyle(color: Colors.grey[600], fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            buildChangePassword(),
            // buildUserInfo()
            Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        initialValue: name,
                        // controller: name,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Tên',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // TextFormField(
                    //     decoration: InputDecoration(
                    //         fillColor: Colors.grey.shade100,
                    //         filled: true,
                    //         labelText: 'Số điện thoại',
                    //         border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(10)))
                    // ),
                    // SizedBox(
                    //   height: 30,
                    // ),
                    // TextFormField(
                    //     initialValue: name,
                    //     // controller: name,
                    //     decoration: InputDecoration(
                    //         fillColor: Colors.grey.shade100,
                    //         filled: true,
                    //         labelText: 'Ngày sinh',
                    //         border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(10)))
                    // ),
                    // SizedBox(
                    //   height: 30,
                    // ),
                    TextFormField(
                        initialValue: email,
                        // controller: name,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý khi người dùng nhấn nút Đăng ký
                      },
                      child: Text('Lưu cập nhật'),
                    ),
                  ],
                )),
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

  // Widget buildUserInfo() => SimpleSettingsTile(
  //       title: 'Thông tin người dùng',
  //       subtitle: '',
  //       leading: Container(
  //           padding: EdgeInsets.all(6),
  //           decoration:
  //               BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
  //           child: Icon(
  //             Icons.info,
  //             color: Colors.white,
  //           )),
  //       onTap: () {
  //         Navigator.of(context)
  //             .push(MaterialPageRoute(builder: (context) => ChangePassword()));
  //       },
  //     );
}
