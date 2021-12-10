// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'review.dart';
import 'review2.dart';


class Post {
  final String buildingName;
  final String buildingLoc;
  final String buildingCall;
  final String slug;

  Post({this.buildingName, this.buildingLoc, this.buildingCall, this.slug});
}

class Info extends StatefulWidget {
  Info({Key key}) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    var value = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "상세 정보",
          style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.pink,
      ),
      backgroundColor: Colors.pink[50],
      body: Center(
        
        child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                child: Image.asset(
                    'assets/images/' + value.buildingName.toString() + '.jpg',
                    height: 160,
                    width: 200,
                    ),
                )
          ],
        ),
        Container(
          margin: EdgeInsets.all(5),
          width: 400,
          height: 50,
          color: Colors.pink[100],
          alignment: Alignment.center,
          child:Text(
            value.buildingName.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color:Colors.pink),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white, width:1),
            color: Colors.white,
          ),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(15),
          width: 400,
          height: 100,
          alignment: Alignment.center,
          child: Text("                기본정보\n\n"+
            "위치: "+value.buildingLoc.toString() + '\n전화번호: ' + value.buildingCall.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          width: 100,
          height: 50,
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                ), 
              onPressed: () {Get.to(Review(), arguments: value.slug.toString());},
              color: Colors.pink[100],
              child: Text(
                '리뷰',
                style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
              )),
        ),
        Container(
          margin: EdgeInsets.all(10),
          width: 100,
          height: 50,
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                ),
              onPressed: () {Get.to(ReviewAnalysis(), arguments: value.slug.toString());},
              color: Colors.pink[200],
              child: Text(
                '리뷰 분석',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )),
        )
      ])),
    );
  }
}
