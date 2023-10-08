import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

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
    final Email send_email = Email(
      body: 'Cảm ơn bạn đã đến với HealthFit,\n\n'
          'Dưới đây là tài khoản và mật khẩu của bạn để đăng nhập vào ứng dụng.'
          ' Nếu bạn cần hướng dẫn hoặc có câu hỏi thì đừng ngần ngại liên hệ để'
          ' được hỗ trợ.\n\n'
          'Thông tin tài khoản:\n'
          'Tài khoản: ' + mail+'\n'
          'Mật khẩu: HealthFitPt@123\n\n'
          'Chúc bạn một ngày tốt lành,\n'
          'HealthFit Team' ,
      subject: 'Chào mừng bạn đến với HealthFit',
      recipients: [mail],
      attachmentPaths: [],
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(send_email);

      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: mail, password: pass);
      final doc = FirebaseFirestore.instance.collection('trainers').doc(uid);
      doc.update({
        'active': true,
        'id': credential.user!.uid,
      });

      // Navigator.of(context).pop();
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => AdminManageUser()));
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
        backgroundColor: Colors.lightBlueAccent[200],
      ),
      backgroundColor: Colors.grey[300],
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getInactiveTrainers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Lỗi: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Hiện tại chưa có PT đăng ký.',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                    fontStyle: FontStyle.italic,
                ),
              ),
            );
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
                    height: 130,
                    width: 150,
                    // margin: EdgeInsets.all(5.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              Text("Ngày sinh: "),
                              Text("${dob.day}/${dob.month}/${dob.year}"),
                            ]),
                            Row(children: [
                              Text("Số điện thoại: "),
                              Text(mobile),
                            ]),
                            Row(children: [
                              Text("Email: "),
                            ]),
                            Row(children: [
                              Text(email),
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
                                approvePT(email, "HealthFitPt@123", uid);
                              },
                            ),
                            // SizedBox(
                            //   width: 25,
                            // ),
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
