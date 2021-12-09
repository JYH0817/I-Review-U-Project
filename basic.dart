import 'package:flutter/material.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';
 
void main() {
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch : Colors.blue,),
      home: Scaffold(
        body: Center(
          child: MyWidget(),
        ),
      ),
    );
  }
}
 
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        title : Text("hello!"),
        backgroundColor: Colors.orange
      ),
      var uuid = Uuid();
      body : Center(
        child:
        Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox
              (
                height: 160,
                width: 160,
                child: Image.asset('images/strawberry.jpg'))
            ],
            
            
)
          ,Container(
            margin: EdgeInsets.all(5),
            width: 140,
            height: 50,
            color: Colors.white70,
          child: Text('딸기스터디카페 서현점',style: TextStyle(fontWeight: FontWeight.bold),),
          )
          
          ,Container(
            margin: EdgeInsets.all(10),
            width: 60,
            height: 50,
            color: Colors.white70,
          child: Text('기본 정보', style: TextStyle(fontWeight: FontWeight.bold),),
          )
          
          ,Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(15),
            width: 400,
            height: 120,
            color: Colors.green,
            uuid.v1();
          // child: Text('주소지:    경기도 성남시 분당구 분당로 xx번길 19 3층\n운영시간:   매일 00:00~24:00 24시간 연중무휴\n전화번호:   031-705-5x2x\n가격:        1시간권 1,500, 3시간권 3,500', style: TextStyle(fontWeight: FontWeight.bold),),
          )
          
          ,Container(
            margin: EdgeInsets.all(10),
            width: 60,
            height: 50,
            color: Colors.white70,
          child: Text('종합 리뷰', style: TextStyle(fontWeight: FontWeight.bold),),
          )
          
          ,Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(25),
            width: 400,
            height: 120,
            color: Colors.green,
            uuid.v2();
          // child: Text('책상이 넓고 노트북 좌석이 있지만,\n음료가 맛이 없다.', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),),
          )
          
          ,Container(
            margin: EdgeInsets.all(10),
            width: 50,
            height: 50,
            color: Colors.white70,
          child: RaisedButton(onPressed: () {}, child: Text('리뷰', style: TextStyle(fontWeight: FontWeight.bold),)),
          )
        ])
        
        
        
      ),
      
    );
  }
}