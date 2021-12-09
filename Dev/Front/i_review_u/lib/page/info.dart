// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'review.dart';



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
        title: Text("상세 정보"),
        backgroundColor: Colors.pink,
      ),
      body: Center(
          child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 160,
                width: 160,
                child: Image.asset(
                    'assets/images/' + value.buildingName.toString() + '.jpg'))
          ],
        ),
        Container(
          margin: EdgeInsets.all(5),
          width: 140,
          height: 50,
          color: Colors.white70,
          child: Text(
            value.buildingName.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          width: 60,
          height: 50,
          color: Colors.white70,
          child: Text(
            '기본 정보',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(15),
          width: 400,
          height: 70,
          color: Colors.green,
          child: Text(
            value.buildingLoc.toString() + '\n' + value.buildingCall.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          width: 60,
          height: 50,
          color: Colors.white70,
          child: Text(
            '종합 리뷰',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(25),
          width: 400,
          height: 120,
          color: Colors.green,

          // child: Text('책상이 넓고 노트북 좌석이 있지만,\n음료가 맛이 없다.', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),),
        ),
        Container(
          margin: EdgeInsets.all(10),
          width: 50,
          height: 50,
          color: Colors.white70,
          child: RaisedButton(
              onPressed: () {Get.to(Review(), arguments: value.slug.toString());},
              child: Text(
                '리뷰',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        )
      ])),
    );
  }
}
