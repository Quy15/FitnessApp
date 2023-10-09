import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/admin/adget_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminUserTabConfigure extends StatefulWidget {
  const AdminUserTabConfigure({super.key});

  @override
  AdminUserTabConfigureState createState() => AdminUserTabConfigureState();
}

class AdminUserTabConfigureState extends State<AdminUserTabConfigure> {

  
  List<String> uIDs = [];
  Future getUser() async{
     await FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        uIDs.add(doc.reference.id);
      });
    });
  }

  Future deleteUser(String uid) async {
     try {
      await FirebaseFirestore.instance.collection("users").doc(uid).delete();
      Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AdminUserTabConfigure()));
      Fluttertoast.showToast(
        msg: 'Xóa thành công',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        textColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 80, 182, 133),
        fontSize: 20,
      );
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(
        msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau',
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý tài khoản người dùng"),
        backgroundColor: Colors.lightBlueAccent[200],
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: uIDs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Container(
                  height: 120,
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AdminGetUser(uID: uIDs[index]),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Xác nhận xóa',
                                      style: TextStyle(fontSize: 25),
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Text(
                                        'Bạn chắc chắn muốn xóa người dùng này ?',
                                        style: TextStyle(fontSize: 25)),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30),
                                              child: SizedBox(
                                                width: 150,
                                                height: 50,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      primary:
                                                          const Color.fromARGB(
                                                              255, 128, 241, 132),
                                                      side: BorderSide(
                                                          width: 3,
                                                          color:
                                                              const Color.fromARGB(
                                                                  255,
                                                                  128,
                                                                  241,
                                                                  132)),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                  onPressed: () {
                                                    deleteUser(uIDs[index]);
                                                  },
                                                  child: Text(
                                                    'Chắc chắn',
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              )),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 30),
                                              child: SizedBox(
                                                width: 150,
                                                height: 50,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      primary: Color.fromARGB(
                                                          255, 221, 90, 85),
                                                      side: BorderSide(
                                                          width: 3,
                                                          color:
                                                              const Color.fromARGB(
                                                                  255,
                                                                  221,
                                                                  90,
                                                                  85)),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AdminUserTabConfigure()));
                                                  },
                                                  child: Text(
                                                    'Trở về',
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      )
                                    ],
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            size: 40,
                            color: Colors.red,
                          ))
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
