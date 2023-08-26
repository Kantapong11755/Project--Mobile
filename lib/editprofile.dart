import 'package:flutter/material.dart';
import 'package:scholarship/userpage.dart';
import 'package:http/http.dart' as http;
import 'package:scholarship/config.dart';
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class EditProfile extends StatefulWidget {
  var userData;
  final token;
  EditProfile({
    @required this.token,
    Key? key,
    this.userData
    }) : super(key: key);


  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController ufname = new TextEditingController();
  TextEditingController ulname = new TextEditingController();
  TextEditingController uclass = new TextEditingController();
  TextEditingController ufaculty = new TextEditingController();
  TextEditingController ubranch = new TextEditingController();
  TextEditingController ugpa = new TextEditingController();
  TextEditingController utoeic = new TextEditingController();
  TextEditingController uielts = new TextEditingController();
  TextEditingController utoefl = new TextEditingController();
  TextEditingController phonenumber = new TextEditingController();

  updatedata(email) async {
    final path = baseUrl+"updateuserdata";
    
    if(ufname.text.isNotEmpty && ulname.text.isNotEmpty && uclass.text.isNotEmpty && ufaculty.text.isNotEmpty && ubranch.text.isNotEmpty && ugpa.text.isNotEmpty && utoeic.text.isNotEmpty && utoefl.text.isNotEmpty && uielts.text.isNotEmpty && phonenumber.text.isNotEmpty){
      var resp = await http.post(Uri.parse(path),
        headers: {'Content_Type':'application/json; charset=UTF-8'},
        body: {
        "uemail": email,
        "ufname": ufname.text,
        "ulname": ulname.text,
        "uclass": uclass.text,
        "ufaculty": ufaculty.text,
        "ubranch": ubranch.text,
        "ugpa": ugpa.text,
        "utoeic": utoeic.text,
        "utoefl": utoefl.text,
        "uielts": uielts.text,
        "phonenumber": phonenumber.text
      }
      );
      var jsonResponse = jsonDecode(resp.body);
      if(jsonResponse['status'] == 200){
        print('Success !!');
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> profile(token: widget.token,)), (route) => false);
      }else{
        print('wait ...');
      }
    }else{
      print('-----------------------------------');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
          color: Colors.green,
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => profile(token: widget.token)), (Route<dynamic> route) => false);
          },
          ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding:  const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              const Text(
                'แก้ไขข้อมูล',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
              SizedBox(height: 25,),
              
              // ufname
              TextField(
                controller: ufname,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: "ชื่อ",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: widget.userData[0]['ufname'],
                  hintStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )
                ),
              ),


              // ulname
              SizedBox(height: 20,),
              TextField(
                controller: ulname,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: "นามสกุล",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: widget.userData[0]['ulname'],
                  hintStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )
                ),
              ),

              // 
              SizedBox(height: 20,),
              TextField(
                controller: uclass,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: "ระดับการศึกษา",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: widget.userData[0]['uclass'],
                  hintStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )
                ),
              ),

              // 
              SizedBox(height: 20,),
              TextField(
                controller: ufaculty,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: "คณะ",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: widget.userData[0]['ufaculty'],
                  hintStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )
                ),
              ),

              // 
              SizedBox(height: 20,),
              TextField(
                controller: ubranch,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: "สาขา",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: widget.userData[0]['ubranch'],
                  hintStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )
                ),
              ),

              // 
              SizedBox(height: 20,),
              TextField(
                keyboardType: TextInputType.number,
                controller: ugpa,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: "เกรด",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: widget.userData[0]['ugpa'].toString(),
                  hintStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )
                ),
              ),

              // 
              SizedBox(height: 20,),
              TextField(
                keyboardType: TextInputType.number,
                controller: utoeic,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: "TOEIC",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: widget.userData[0]['utoeic'].toString(),
                  hintStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )
                ),
              ),

              // 
              SizedBox(height: 20,),
              TextField(
                keyboardType: TextInputType.number,
                controller: uielts,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: "IELTS",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: widget.userData[0]['uielts'].toString(),
                  hintStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )
                ),
              ),

              // uclass
              SizedBox(height: 20,),
              TextField(
                keyboardType: TextInputType.number,
                controller: utoefl,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: "TOEFL",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: widget.userData[0]['utoefl'].toString(),
                  hintStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )
                ),
              ),

              // uclass
              SizedBox(height: 20,),
              TextField(
                keyboardType: TextInputType.phone,
                controller: phonenumber,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  labelText: "เบอร์มือถือ",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: widget.userData[0]['phonenumber'].toString(),
                  hintStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )
                ),
              ),

              SizedBox(height: 40,),
              TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.blueAccent,
                  ),
                  onPressed: () {
                    updatedata(widget.userData[0]['uemail'].toString());
                  },
                  child: Text('แก้ไขข้อมูล'),
              )
            ],
          ),
        ),
      ),
    );
  }
}