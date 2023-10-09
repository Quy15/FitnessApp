import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/admin/adget_pt.dart';
import 'package:dev/admin/admin_homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminPTTabConfigure extends StatefulWidget {
  const AdminPTTabConfigure({super.key});

  @override
  AdminPTTabConfigureState createState() => AdminPTTabConfigureState();
}

class AdminPTTabConfigureState extends State<AdminPTTabConfigure> {
  List<String> ptIDs = [];
  List<String> ptNames = [];
  Future getPT() async {
    await FirebaseFirestore.instance
        .collection("trainers")
        .where("active", isEqualTo: true)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        ptIDs.add(doc.reference.id);
        print(ptIDs);
      });
    });
  }

  Future getPTID() async {
    await FirebaseFirestore.instance
        .collection("trainers")
        .where("active", isEqualTo: true)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        ptNames.add('${doc['id']}');
        print(ptNames);
      });
    });
  }

  // String? u;
  // Future deleteUPT(String uid) async {
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("id_pt", isEqualTo: uid)
  //       .get()
  //       .then((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((DocumentSnapshot doc) {
  //       u = doc.reference.id;
  //       print(u);
  //     });
  //   });

  //   await FirebaseFirestore.instance.collection("users").doc(u).update({
  //     'id_pt': "",
  //     'call_id': "",
  //     'call_name': ""
  //   });
  // }

  Future deletePT(String uid) async {
    try {
      await FirebaseFirestore.instance.collection("trainers").doc(uid).delete();
      Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AdminPTTabConfigure()));
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
  void initState() {
    getPTID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý tài khoản PT"),
        backgroundColor: Colors.lightBlueAccent[200],
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder(
        future: getPT(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: ptIDs.length,
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
                      AdminGetPT(ptID: ptIDs[index]),
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
                                        'Bạn chắc chắn muốn xóa pt này ?',
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
                                                    deletePT(ptIDs[index]);
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
                                                                AdminPTTabConfigure()));
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
