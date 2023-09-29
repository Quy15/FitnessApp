import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminManageUser extends StatefulWidget {
  const AdminManageUser({super.key});

  @override
  AdminManageUserState createState() => AdminManageUserState();
}

class AdminManageUserState extends State<AdminManageUser> {
  Future<List<QueryDocumentSnapshot>> getInactiveTrainers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('trainers')
          .where('active', isEqualTo: false)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print('Lỗi khi truy vấn Firestore: $e');
      return [];
    }
  }

  Future<UserCredential> approvePT(String mail, String pass, String uid) async {
    try {
      UserCredential credential =  await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: mail, password: pass);
      final doc = FirebaseFirestore.instance
          .collection('trainers').doc(uid);
      doc.update({
        'active': true,
        'id': credential.user!.uid,
      });
      Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AdminManageUser()));
      Fluttertoast.showToast(
        msg: 'Tài khoản PT đã được tạo',
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau',
        );
      }
      throw Exception(e.code);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau',
      );
      throw Exception(e);
    }
  }

  showAlertDialogDelete(BuildContext context, String uid) {
    Widget cancelButton = TextButton(
      child: Text("Hủy"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Tiếp tục"),
      onPressed: () {
        try {
          final doc =
              FirebaseFirestore.instance.collection('trainers').doc(uid);
          doc.delete();
          Navigator.of(context).pop();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AdminManageUser()));
        } on FirebaseAuthException catch (e) {
          Fluttertoast.showToast(
            msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau',
          );
        }
        ;
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Thông báo"),
      content: Text("Bạn chắc chắn muốn xóa?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Duyệt danh sách PT đăng ký"),
        backgroundColor: Colors.deepPurpleAccent,     
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getInactiveTrainers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Lỗi: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('Hiện tại chưa có PT đăng ký.');
          } else {
            // Hiển thị danh sách trainers đăng ký
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var trainer = snapshot.data![index];
                var name = trainer['name'] as String;
                var experience = trainer['experience'] as String;
                var email = trainer['email'] as String;
                var mobile = trainer['mobile'] as String;
                var uid = trainer['id'] as String;
                Timestamp timestamp = trainer['date_of_birth'];
                DateTime dob = timestamp.toDate();

                return ListTile(
                  title: Container(
                    height: 120,
                    width: 100,
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Để đặt hai biểu tượng hai bên
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Canh chỉnh văn bản theo chiều dọc
                          children: [
                            Row(children: [
                              Text("Tên: "),
                              Text(name),
                            ]),
                            Row(children: [
                              Text("Kinh nghiệm: "),
                              Text(experience),
                            ]),
                            Row(children: [
                              Text("Email: "),
                              Text(email),
                            ]),
                            Row(children: [
                              Text("Số điện thoại: "),
                              Text(mobile),
                            ]),
                            Row(children: [
                              Text("Ngày sinh: "),
                              Text("${dob.day}/${dob.month}/${dob.year}"),
                            ]),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                approvePT(email, "User@123", uid);
                              },
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            IconButton(
                              onPressed: () {
                                showAlertDialogDelete(context, uid);
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
