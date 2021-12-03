import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(MaterialApp(home: MyApp()));

// class MyApp extends StatefulWidget { @override _MyAppState createState() => MyAppState(); }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('목록 보기')),
      body: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
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
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },
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
