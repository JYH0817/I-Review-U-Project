// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'info.dart';
import 'dart:convert';
import 'package:get/get.dart';

Future<List<Post>> getData() async {
  var slug = Get.arguments;
  final response = await http.get(
      Uri.parse("http://192.168.0.9:8000/api/buildingdata/" + slug +"/"),
      headers: {"Access-Control-Allow-Origin": "*"});
  if (response.statusCode == 200) {
    List list = (json.decode(utf8.decode(response.bodyBytes)));
    var postList = list.map((element) => Post.fromJson(element)).toList();
    return postList;
  } else {
    throw Exception('Failed to load post');
  }
}

class Post {
  final String buildingName;
  final String review;
  final String star;

  Post({this.buildingName, this.review, this.star});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        buildingName: json["building_name"],
        review: json["review_content"],
        star: json["star_num"]);
  }
}

void main() => runApp(MaterialApp(home: MyApp()));

// class MyApp extends StatefulWidget { @override _MyAppState createState() => MyAppState(); }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('목록 보기')),
      body: Review2(),
    );
  }
}

class Review2 extends StatefulWidget {
  @override
  _Review2State createState() => _Review2State();
}

class _Review2State extends State<Review2> {
  final _valueList = ['분위기', '시설', '속성3', '속성4'];
  var _selectedValue = '속성 선택';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text("0"),
          Row(
            children: <Widget>[
              CupertinoButton(child: Text("신뢰도순"), onPressed: () => {}),
              CupertinoButton(child: Text("평점순"), onPressed: () => {}),
              Container(width: 100, height: 50),
              Text('속성 : '),
              Container(
                width: 70,
                height: 40,
                child: DropdownButton(
                  value: _selectedValue,
                  items: _valueList.map(
                    (value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  /*onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },*/
                ),
              ), //container
            ], //Widget
          ), //Row

          Divider(
            height: 60.0,
            color: Colors.grey[850],
            // thickness: 0.8,
            // endIndent: 30.0,
          ),
          SizedBox(
            height: 500.0,
            child: ListView(
              // 1. 리스트뷰 생성하고
              children: <Widget>[
                ListTile(
                  // 2. 리스트 항목 추가!
                  leading: Icon(Icons.star), //별점만큼 별의 갯수 넣는 방법?
                  title: Text('조용해요!'),
                  subtitle: Text('책상이 넓고 조용해요! 자주 와야겠어요.'),
                  trailing: Icon(Icons.more_vert),
                  isThreeLine: true,
                ),
                ListTile(
                  leading: Icon(Icons.star),
                  title: Text('괜찮아요!'),
                  subtitle:
                      Text('노트북 좌석이 따로 있어서 넘 좋아요~ 시설도 괜찮은 편이고 조용해서 집중 잘 됐어요!'),
                  trailing: Icon(Icons.more_vert),
                  isThreeLine: true,
                ),
                ListTile(
                  leading: Icon(Icons.star),
                  title: Text('그냥 그래요'),
                  subtitle: Text('백색소음기가 있는건 좋은데 음료종류와 좌석수가 적어요.'),
                  trailing: Icon(Icons.more_vert),
                  isThreeLine: true,
                ),
              ],
            ),
          ),
          CupertinoButton(child: Text("더보기"), onPressed: () => {}),
        ],
      ),
    );
  }
}
