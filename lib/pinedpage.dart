import 'package:scholarship/config.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scholarship/userpage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


late Map mapResponse;
List? listdata;

class PinPage extends StatefulWidget {
  final token;
  const PinPage({
    @required this.token,
    Key? key,
    }) : super(key: key);
  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  late String email;

  Future getpinpage() async{
    Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['uemail'];
    const path = baseUrl + "pinpage";
    final resp = await http.post(Uri.parse(path),
      headers:{'Content_Type':'application/json; charset=UTF-8'},
      body: {
        "email" : email
      },
    );

    if(resp.statusCode == 200){
      setState(() {
        // responseData  = resp.body;
        mapResponse = json.decode(resp.body);
        listdata = mapResponse['scholarship'];
      });
    }
  }
  
  static pinTun(id, email) async{
    var pinResp;
    final pinpath = baseUrl + "pin";
    print(id);
    pinResp = await http.post(Uri.parse(pinpath),
      headers: {'Content_Type':'application/json; charset=UTF-8'},
      body: {
        "id" : id,
        "email" : email
      }
    );
  }

  @override
  void initState(){
    getpinpage();
    super.initState();

    Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    email = jwtDecodedToken['uemail'];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('Scholarship pinned',style: TextStyle(color: Colors.black)),
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
       body: ListView.builder(
        itemBuilder: (context, index){
          return Container(
            child: Column(
              children: [
                SizedBox(height: 15,),
                itemTun(listdata![index]['sname'].toString(),
                listdata![index]['sclass'] .toString(),
                listdata![index]['sfaculty'][0]+" และอื่นๆ".toString(),
                listdata![index]['sbranch'][0] +" และอื่นๆ".toString(),
                listdata![index]['country'].toString(),
                listdata![index]['pinnedcount'].toString(),
                listdata![index]['_id'].toString(),
                ),
              ],
            ),
          );
        },
        itemCount: listdata == null? 0: listdata!.length,
        ),
     );
   }

    // itemTun(String sname, String sclass, String sfaculty, String sbranch, String country, String university){
    itemTun(String sname, String sclass, String sfaculty, String sbranch, String country, String pinnedcount, String id){
    return Container(
      width: 350,
      height: 190,
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
            child: Card(
              borderOnForeground: false,
              margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // sname
                  Text(sname,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2,),
                  Text("ระดับ : "+sclass,
                  style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 2,),
                  Text("คณะ : "+sfaculty+"  สาขาวิชา : "+sbranch,
                  style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 2,),
                  Text("ประเทศ : " +country,
                  style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 2,),
                  Text("ปักหมุแล้ว : " +pinnedcount,
                  style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 2,),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.blueAccent,
                    ),
                    onPressed: () {
                      pinTun(id, email);
                    },
                    child: Text('ปักหมุด'),
                  )
                ],
              ),
            ),
          );
  }
}
