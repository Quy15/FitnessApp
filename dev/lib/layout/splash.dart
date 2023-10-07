import 'package:dev/layout/auth_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState(){
    super.initState();

    Future.delayed(Duration(seconds: 5)).then((value){
      Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => AuthPage()));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12.withOpacity(0.5),
      body: Center(
        child: SizedBox(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SpinKitCircle(
                color: Colors.green,
                size: 50.0,
              ),
              SizedBox(height: 10,),
              Text("Đang xử lý đăng nhập", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500
              , color: Colors.green),)
            ],
          ),
        ),
      ),
    );
  }
}