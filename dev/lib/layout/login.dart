import 'package:dev/auth.dart';
import 'package:dev/layout/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  String? errorMessage;
  bool hidePass = true;

  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  void dispose(){
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> signInWithEmailAndPassWord() async {
    try{
      await Auth().signInWithEmailAndPassWord(email: _email.text.trim(), password: _pass.text.trim());
    }on FirebaseAuthException catch (e){
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/workout.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 50, top: 135, right: 35),
                child: Text(
                  'Đăng nhập hệ thống',
                  style: TextStyle(color: Colors.black, fontSize: 33),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 270, right: 35, left: 35),
                  child: Column(
                    children: [
                      TextField(
                        controller: _email,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_rounded,
                              color: Colors.black,
                            ),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Nhập tài khoản',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: _pass,
                        obscureText: hidePass,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            suffixIcon: IconButton(
                              icon: hidePass
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: Colors.black,
                                    )
                                  : Icon(Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  hidePass = !hidePass;
                                });
                              },
                            ),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Nhập mật khẩu',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Đăng nhập',
                            style: TextStyle(
                                fontSize: 27, fontWeight: FontWeight.w700),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xff4c505b),
                            child: IconButton(
                              color: Colors.white,
                              onPressed: () {
                                signInWithEmailAndPassWord();
                                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()));
                                  Fluttertoast.showToast(
                                    msg: 'Đăng nhập thành công',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 2,
                                    textColor: Colors.white,
                                    backgroundColor: const Color.fromARGB(255, 80, 182, 133),
                                    fontSize: 20,
                                  );
                              },
                              icon: Icon(Icons.arrow_forward),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'register');
                            },
                            child: Text(
                              'Đăng ký',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Color(0xff4c505b),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Quên mật khẩu',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Color(0xff4c505b),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
