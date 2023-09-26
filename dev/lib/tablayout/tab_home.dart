import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  _HomeTab createState() => _HomeTab();
}

class _HomeTab extends State<HomeTab> {
  final user = FirebaseAuth.instance.currentUser;

  String id = " ";
  String name = " ";
  Future getUserByEmail(String? email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          id = doc.reference.id;
          this.name = '${doc['name']}';
          print(id);
        });
      });
    });
  }

  String purpose = " ";
  Future getPurpose() async {
    await FirebaseFirestore.instance
        .collection("trainning_purpose")
        .where("user_id", isEqualTo: id)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        this.purpose = '${doc['purpose']}';
        print(purpose);
      });
    });
  }

  Future<List<QueryDocumentSnapshot>> getPTByPurpose() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("trainers")
        .where("active", isEqualTo: true)
        .get();
    return snapshot.docs;
  }

  String qualification = " ";

  @override
  void initState() {
    // getUserByEmail(user?.email);
    getPurpose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: FutureBuilder(
        future: getPTByPurpose(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Lỗi firebase: ' + '${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var pt = snapshot.data![index];
                qualification = pt['qualification'];
                if (this.qualification.contains(purpose)){
                  var name = pt['name'] as String;
                  var experience = pt['experience'] as String;
                  var email = pt['email'] as String;
                  var mobile = pt['mobile'] as String;

                  return ListTile(
                    title: Container(
                      height: 120,
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
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
                            Text("Email: "),
                            Text(email),
                          ]),
                          Row(children: [
                            Text("Số điện thoại: "),
                            Text(mobile),
                          ]),
                          Row(children: [
                            Text("Chuyên môn: "),
                            Text(qualification),
                          ]),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
