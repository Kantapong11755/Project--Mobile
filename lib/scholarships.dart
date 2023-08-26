import 'dart:async';
import 'dart:ffi';
import 'package:scholarship/config.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scholarship/userpage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


late Map mapResponse;
List? listdata;
List? alltext;
List? stype;
class ScholarShips extends StatefulWidget {
  final token;
  const ScholarShips({
    @required this.token,
    Key? key,
    }) : super(key: key);
  @override
  State<ScholarShips> createState() => _ScholarShipsState();
}

class _ScholarShipsState extends State<ScholarShips> {
  late String email;
  // List<Map<String,dynamic>> ourname = [];
  
  Future getscholarships() async{
    final path = baseUrl + "scholarships";
    final resp = await http.get(Uri.parse(path));

    if(resp.statusCode == 200){
      setState(() {
        // responseData  = resp.body;
        mapResponse = json.decode(resp.body);
        listdata = mapResponse['scholarship'];
        alltext = mapResponse['sname'];
        print(alltext);
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
    getscholarships();
    super.initState();
    Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    email = jwtDecodedToken['uemail'];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scholarship list',style: TextStyle(color: Colors.black)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
          color: Colors.green,
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => profile(token: widget.token)), (Route<dynamic> route) => false);
          },
          ),
        actions: [
          IconButton(
            color: Colors.black,
            onPressed: () {
              showSearch(
                context: context,
                delegate: dataSearch(ourname: alltext)
                );
            },
            icon: Icon(Icons.search),
            ),
            // filter
            IconButton(
              onPressed: () {
                openFilter(context);
              },
              icon: Icon(Icons.menu),
              color: Colors.black,
              )
        ],
      ),
       body: Container(
              width: 400,
              height: 690,
               child: ListView.builder(
                itemBuilder: (context, index){
                  return Container(
                    child: Column(
                      children: [
                        SizedBox(height: 15,),
                        itemTun(listdata![index]['sname'].toString(),
                        listdata![index]['sclass'].toString(),
                        listdata![index]['sfaculty'].toString(),
                        listdata![index]['sbranch'].toString(),
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

class dataSearch extends SearchDelegate<String> {
  final token;
  final ourname;
  dataSearch({@required this.token, this.ourname});
  String name = "Scholarship";
  
  

  final recentourname = [
    // "Prachinburi",
    // "Nakonsawan",
    // "Saraburi",
  ];
  
  @override
  List<Widget> buildActions(BuildContext context){
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
      IconButton(
        onPressed: (){},
        icon: Icon(Icons.menu))
    ];
  }

  @override 
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, "");
      },
      icon: Icon(Icons.arrow_back),
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for(var s in ourname) {
      if (s.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(s);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          leading: Icon(Icons.search_outlined),
          title: Text(result),
          onTap: () {},
        );
      },
      );
  }

  @override
  Widget buildSuggestions(BuildContext context){
    List<String> matchQuery = [];
    for(var s in ourname){
      if (s.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(s);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Container(
          child: ListTile(
            leading: Icon(Icons.search),
            onTap: () {},
            title: Text(result),
            trailing: Text(name,
            style: TextStyle(fontSize: 12),
            ),
          ),
        );
      },
      );
  }
}

String dropdowntest = "One";
//filter
void openFilter(BuildContext context) => showModalBottomSheet(
  context: context,
  builder: (BuildContext context){
    return SizedBox(height: 500,
    child: Column(
      children: [
        // ส่วนค้นหา list view
        SizedBox(
          height: 400,
          child: Column(
            children: [
              SizedBox(height: 10),
              Text('ตัวคัดกรองการค้นหา',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),

              SizedBox(height: 5,),
              Text('ค้นจากประเภททุน'),

              SizedBox(height: 2,),
            ],
          ),
        ),

        // ปุ่มค้นหา  
        SizedBox(
          child: Container(
            width: 300,
            height: 40,
            color: Colors.grey,
          ),
        )
        
      ],
    ),);
  });


