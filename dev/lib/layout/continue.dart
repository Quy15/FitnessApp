import 'package:flutter/material.dart';

class Continue extends StatefulWidget {
  const Continue({super.key});

  @override
  ContinueState createState() => ContinueState();
}

class ContinueState extends State<Continue> {
  String _value = 'Chưa có kinh nghiệm';
  var _items = ['Chưa có kinh nghiệm', '3 tháng', '6 tháng', 'Trên 1 năm'];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: Padding(
        padding: EdgeInsets.only(top: 250, left: 23),
        child: Stack(
          children: [
            Text(
              'Bạn đã có kinh nghiệm tập luyện chưa ?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(top: 80, left: 50, right: 50),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(   
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: DropdownButton(
                    items: _items.map((String item) {
                      return DropdownMenuItem(value: item, child: Text(item, style: TextStyle(fontWeight: FontWeight.bold),));
                    }).toList(), onChanged: (String? newValue) {
                  _value = newValue!;
                },
                borderRadius: BorderRadius.circular(10), 
                value: _value, 
                icon: Icon(Icons.arrow_drop_down_rounded),
                iconSize: 40,
                style: TextStyle(fontSize: 20, color: Colors.black)),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
