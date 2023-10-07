import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/admin/admin_manage_user.dart';
import 'package:dev/admin/admin_pt_user_manage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../layout/login.dart';


class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});
  @override
  _AdminHomePageState createState() => _AdminHomePageState();

}

void signOut() async {
  await FirebaseAuth.instance.signOut();
}


class _AdminHomePageState extends State<AdminHomePage>{
  Future<List<QueryDocumentSnapshot>> getCreatedateUsers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();
      return querySnapshot.docs;

    } catch (e) {
      print('Lỗi khi truy vấn Firestore: $e');
      return [];
    }
  }
  Map<String, int> myDictionaryMonth = {
    '01': 0,
    '02': 0,
    '03': 0,
    '04': 0,
    '05': 0,
    '06': 0,
    '07': 0,
    '08': 0,
    '09': 0,
    '10': 0,
    '11': 0,
    '12': 0,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trang quản trị"),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
              onPressed: () {
                signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
                child: Icon(
              Icons.settings,
              size: 48,
            )),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("DUYỆT ỨNG VIÊN PT"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'admin_manage_user');
              },
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle),
              title: Text("QUẢN LÝ NGƯỜI DÙNG"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'admin_pt_user_manage');
              },
            )
          ],
        ),
      ),
      body:FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getCreatedateUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Hiển thị tiêu đề chờ nếu dữ liệu đang được tải.
          } else if (snapshot.hasError) {
            return Text('Lỗi: ${snapshot.error}');
          } else {
            Map<String, int> userCountByMonth = {};

            // Xử lý dữ liệu để tính toán số lượng người dùng theo tháng
            snapshot.data!.forEach((doc) {
              String createdDate = (doc['created_date']).toDate().toString();
              String month = createdDate.split("-")[1];

              if (myDictionaryMonth.containsKey(month)) {
                myDictionaryMonth[month] = myDictionaryMonth[month]! + 1;
              }
           });

            return  Center(
                child: Container(
                    height: 700,
                    child: SfCartesianChart(
                        title: ChartTitle(text: 'Thống kê người dùng'),
                        // Initialize category axis
                        primaryXAxis: CategoryAxis(),
                        series: <ChartSeries>[
                          // Initialize line series
                          LineSeries<ChartData, String>(
                              dataSource: [
                                // Bind data source
                                ChartData('Jan', myDictionaryMonth['01']),
                                ChartData('Feb', myDictionaryMonth['02']),
                                ChartData('Mar', myDictionaryMonth['03']),
                                ChartData('Apr', myDictionaryMonth['04']),
                                ChartData('May', myDictionaryMonth['05']),
                                ChartData('Jun', myDictionaryMonth['06']),
                                ChartData('July', myDictionaryMonth['07']),
                                ChartData('Aug', myDictionaryMonth['08']),
                                ChartData('Sep', myDictionaryMonth['09']),
                                ChartData('Oct', myDictionaryMonth['10']),
                                ChartData('Nov', myDictionaryMonth['11']),
                                ChartData('Dec', myDictionaryMonth['12']),
                              ],
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              dataLabelSettings:DataLabelSettings(isVisible : true)
                          )
                        ]
                    )
                )
            );
        }
        },
      )

    );
  }
}
class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int? y;
}
