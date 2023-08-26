import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scholarship/editprofile.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:scholarship/pinedpage.dart';
import 'package:scholarship/scholarships.dart';
import 'package:scholarship/config.dart';

class profile extends StatefulWidget {
  final token;
  const profile({
    @required this.token,
    Key? key,
    }) : super(key: key);
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  // send parameter
  //  vars
  late String email;
  var userData;
  var data;
  var spac = "  ";
  

  void initState(){
    super.initState();

    Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['uemail'];
  }

  // api
  Future getUserdata(email) async {
    final pathurl = baseUrl+"dataUser";
    final resp = await http.post(Uri.parse(pathurl),
      headers: {'Content_Type':'application/json; charset=UTF-8'},
      body: {
        "uemail": email
      }
    );
    if(resp.statusCode == 200){
      userData = await jsonDecode(resp.body);
      data = userData['userData'];
    }else{
      print('.....');
     }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
            children: [
              SizedBox(height: 20),
                Text('Profile'),
                SizedBox(height: 20),
                FutureBuilder(
                  future: getUserdata(email),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Text('Loading ...');
                    }else{
                      return Column(
                        children: [
                          itemProfile('อีเมลล์', data[0]['uemail'].toString(), CupertinoIcons.mail),
                          SizedBox(height: 15,),
                          itemProfile('ชื่อ', data[0]['ufname'].toString() +spac+ data[0]['ulname'].toString(), CupertinoIcons.person),
                          SizedBox(height: 15,),
                          itemProfile('การศึกษา', data[0]['uclass'].toString() + '   ' + data[0]['ufaculty'].toString() + '  สาขา ' +data[0]['ubranch'].toString(), CupertinoIcons.book),
                          SizedBox(height: 15,),
                          itemProfile('ผลการศึกษา', data[0]['ugpa'].toString(), CupertinoIcons.paperplane),
                          SizedBox(height: 15,),
                          itemProfile('ผลการสอบ','TOEIC '+ data[0]['utoeic'].toString() + '   IELTS '+data[0]['uielts'].toString() + '   TOEFL '+data[0]['utoefl'].toString(), CupertinoIcons.pencil),
                          SizedBox(height: 15,),
                          itemProfile('เบอร์มือถือ',data[0]['phonenumber'].toString(), CupertinoIcons.phone),
                          SizedBox(height: 25,),

                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.blueAccent,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfile(token: widget.token, userData: data,)));
                            },
                            child: Text('แก้ไขข้อมูล'),
                          ),
                          
                          SizedBox(height: 5,),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.blueAccent,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScholarShips(token: widget.token)));
                            },
                            child: Text('รายการทุน'),
                          ),
                          SizedBox(height: 5,),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.blueAccent,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PinPage(token: widget.token)));
                            },
                            child: Text('รายกาปักหมุด'),
                          )
                        ],
                      );
                    }
                  })
            ],
          )
      ),
    );
  }

  itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0,5),
                  color: Colors.deepOrange.withOpacity(.2),
                  spreadRadius: 5,
                  blurRadius: 10
                )
              ]
            ),
            child: ListTile(
              title: Text(title),
              subtitle:  Text(subtitle),
              leading:  Icon(iconData),
              tileColor: Colors.white,
            ),
          );
  }
}

