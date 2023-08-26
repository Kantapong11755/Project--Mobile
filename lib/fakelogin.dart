import 'dart:convert';
import 'package:scholarship/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scholarship/userpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;
  
  @override
  void initState(){
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void login() async {
    final pathurl = baseUrl+"login";
    if(email.text.isNotEmpty && password.text.isNotEmpty){
      var resp = await http.post(Uri.parse(pathurl),
        headers: {'Content_Type':'application/json; charset=UTF-8'},
        body: {
          "email": email.text,
          "password" : password.text
        }
      );
      var jsonres = jsonDecode(resp.body);
      if(jsonres['loginStatus'] == true){
        var myToken = jsonres['token'];
        prefs.setString('token', myToken);
        Navigator.push(context, MaterialPageRoute(builder: (context) => profile(token: myToken)));
      }else{
        print('some thing is wrong');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 60,),
            Text('Email'),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: email,
              decoration: const InputDecoration(
                hintText: "email",
              ),
            ),

            SizedBox(height: 10,),
            Text('passwords'),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: password,
              decoration: const InputDecoration(
                hintText: "password",
              ),
            ),

            SizedBox(height: 40,),
            TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.blueAccent,
                ),
                onPressed: () {
                  login();
                },
                child: Text('Login'),
              )
          ],
        ),
        ),
        
    );
  }
}