import 'package:flutter/material.dart';

class Continue extends StatefulWidget {
  const Continue({super.key});

  @override
  ContinueState createState() => ContinueState();
}

class ContinueState extends State<Continue> {
  String _value = 'Chưa có kinh nghiệm';
  var _items = ['Chưa có kinh nghiệm', '3 tháng', '6 tháng', 'Trên 1 năm'];

  String _zIndex = 'Ít vận động';
  var _zindexs = [
    'Ít vận động',
    'Vận động nhẹ',
    'Vận động vừa',
    'Vận động nhiều',
    'Vận động nặng'
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Container(
      child: Scaffold(
          body: Padding(
        padding: EdgeInsets.only(top: 200, left: 23),
        child: Stack(
          children: [
            Text(
              'Bạn đã có kinh nghiệm tập luyện chưa ?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(top: 60, left: 50, right: 50),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton(
                    items: _items.map((String item) {
                      return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        this._value = value!;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    value: _value,
                    icon: Icon(Icons.arrow_drop_down_rounded),
                    iconSize: 40,
                    style: TextStyle(fontSize: 20, color: Colors.black)),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 120, right: 50, left: 50),
                child: Text(
                  'Cường độ hoạt động của bạn',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 210, left: 70, right: 50),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton(
                    items: _zindexs.map((String index) {
                      return DropdownMenuItem(
                          value: index,
                          child: Text(
                            index,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        this._zIndex = value!;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    value: _zIndex,
                    icon: Icon(Icons.arrow_drop_down_rounded),
                    iconSize: 40,
                    alignment: Alignment.center,
                    style: TextStyle(fontSize: 20, color: Colors.black)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 320, left: 50, right: 65),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, 'continue');
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      Color(0xff44A3AE),
                      Color(0xff33FBC9),
                    ]),
                  ),
                  width: size.width * 0.7,
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
