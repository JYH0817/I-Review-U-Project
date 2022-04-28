// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:i_review_u/page/chart.dart';

Future<List<Post>> getData() async {
  var slug = Get.arguments;
  final response = await http.get(
    //Uri.parse("http://192.168.55.233:8000/api/buildingdata/"),//세훈
      Uri.parse("http://192.168.55.233:8000/api/buildingdata/" + slug + "/analysis"),
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
  final double positivity;
  final String attribute;

  Post({this.buildingName, this.review, this.star, this.positivity, this.attribute});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        buildingName: json["building_name"],
        review: json["review_content"],
        star: json["star_num"].toString(),
        positivity: json["positivity"],
        attribute: json["attribute"],
        );

  }
}

class ReviewAnalysis extends StatefulWidget {
  ReviewAnalysis({Key key}) : super(key: key);

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<ReviewAnalysis> {
  Future<List<Post>> postList;
  String currentLocation;
  String currentTag;
  final Map<String, String> sortTypeToString = {
    "default": "작성순",
    "positivity": "긍정순",
    "negativity": "부정순",
  };
  final Map<String, String> TagTypeToString = {
    "all": "전체",
    "food": "음식",
    "temperature": "온도",
    "clean": "청결",
    "convinience": "편의성",
    "mood": "분위기",
    "kind": "친절",
    "price": "가격",
    "location": "위치",
  };

  @override
  void initState() {
    super.initState();
    postList = getData();
    currentLocation = "default";
    currentTag = "all";
  }

  // 앱 바
  AppBar _appbarWidget() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          // 탭
          print("tap");
        },
        onLongPress: () {
          // 길게 클릭
          print("long press");
        }, // 추후 다른 이벤트 추가
        child: PopupMenuButton<String>(
          color: Colors.pink[50],
          offset: Offset(0, 25), // 평행이동
          shape: ShapeBorder.lerp(
              // 원처리
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              1),
          onSelected: (String location) {
            // 클릭 이벤트
            setState(() {
              currentLocation = location;
            });
          },
          itemBuilder: (BuildContext context) {
            // 지역 리스트
            return [
              PopupMenuItem(value: "default", child: Text("작성순")),
              PopupMenuItem(value: "positivity", child: Text("긍정순")),
              PopupMenuItem(value: "negativity", child: Text("부정순")),
            ];
          },
          child: Row(
            children: [
              // 지역 선택
              Text(sortTypeToString[currentLocation].toString(),
              style: TextStyle(fontSize: 20, color:Colors.white),),
              Icon(Icons.arrow_drop_down,
                color:Colors.white,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.pink,
      elevation: 1,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.tune),
        ),
        // 상단 아이콘
        GestureDetector(
            onTap: () {
            // 탭
          },
          onLongPress: () {
            // 길게 클릭
          },
           // 추후 다른 이벤트 추가
          child: PopupMenuButton<String>(
            color: Colors.pink[50],
            
            offset: Offset(0, 25), // 평행이동
            shape: ShapeBorder.lerp(
                // 원처리
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                1),
            onSelected: (String tag) {
              // 클릭 이벤트
              setState(() {
                currentTag = tag;
              });
            },
            itemBuilder: (BuildContext context) {
              // 속성 리스트
              return [
                PopupMenuItem(value: "all", child: Text("전체")),
                PopupMenuItem(value: "food", child: Text("음식")),
                PopupMenuItem(value: "temperature", child: Text("온도")),
                PopupMenuItem(value: "clean", child: Text("청결")),
                PopupMenuItem(value: "convinience", child: Text("편의성")),
                PopupMenuItem(value: "mood", child: Text("분위기")),
                PopupMenuItem(value: "kind", child: Text("친절")),
                PopupMenuItem(value: "price", child: Text("가격")),
                PopupMenuItem(value: "location", child: Text("위치")),
              ];
            },
            child: Row(
              children: [
                // 속성 선택
                Text(
                  TagTypeToString[currentTag].toString(),
                  style: TextStyle(fontSize: 15, color:Colors.white),
                  ),
                Icon(Icons.arrow_drop_down,
                color:Colors.white,),
              ],
            ),
          ),
        )
        ,
         // 속성
        IconButton(
            // 알림
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/svg/bell.svg",
              width: 22,
            )),
      ],
    );
  }
  int getNum(List<Post> myData){
    int num = myData.length;
    return num;
  }

  double getStar(List<Post> myData){
    double starAvr;
    double sum = 0;
    myData.forEach((data) {
      sum += double.parse(data.star);
    });
    if(myData.length == 0){
      return 0;
    }
    starAvr = sum / myData.length;
    starAvr = (starAvr * 100).round() / 100;
    return starAvr;
  }

  int getRatio(List<Post> myData){
    List<Post> positive;
    List<Post> negative;
    positive = myData.where((x) => x.positivity >= 0.5).toList();
    negative = myData.where((x) => x.positivity < 0.5).toList();
    int a = positive.length;
    int b = negative.length;
    if(a == 0 && b == 0){
      return 100;
    }
    return ((a/(a+b))*100).round();
  }

  List<double> getAttributeList(List<Post> myData){
    List<Post> a, b, c, d, e, f, g, h;
    a = myData.where((x) => x.attribute == "음식").toList();
    print(a);
    b = myData.where((x) => x.attribute == "온도").toList();
    c = myData.where((x) => x.attribute == "청결").toList();
    d = myData.where((x) => x.attribute == "편의성").toList();
    e = myData.where((x) => x.attribute == "분위기").toList();
    f = myData.where((x) => x.attribute == "친절").toList();
    g = myData.where((x) => x.attribute == "가격").toList();
    h = myData.where((x) => x.attribute == "위치").toList();

    List<double> myList = [a.length/1, b.length/1, c.length/1, d.length/1, e.length/1, f.length/1, g.length/1, h.length/1];
    
    return myList;
  }
  _makeDataList(List<Post> datas) {
    // 리뷰 데이터
    
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            height: 50,
            color: Colors.green[200],
            child:Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "리뷰 분석 레포트",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                    child:Text(
                    "리뷰 개수: ${getNum(datas)}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                    child:Text(
                    "평균 별점: ${getStar(datas)}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                )
              ],
              )
          ),
          Row( 
            children:[
              Container( // PieChart
                padding: const EdgeInsets.symmetric(vertical: 20),
                height: 180,
                width: 150,
                color: Colors.green[50],
                child: CustomPaint(
                  size:Size(50,50),
                  painter: PieChart(
                    percentage: getRatio(datas),
                    textScaleFactor: 0.8,
                  )

                )
              ),
              Container( // BarChart
                padding: const EdgeInsets.symmetric(vertical: 20),
                height: 180,
                width: 230,
                color: Colors.green[50],
                child: CustomPaint(
                  size:Size(100,100),
                  painter: BarChart(
                    data: getAttributeList(datas),
                    labels: ["음식","온도","청결","편의","무드","친절","가격","위치"],
                    color: Colors.pinkAccent
                  )

                )
              ),
            ]
          ),
          Expanded(
            child:Container(
              
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (BuildContext _context, int index) {
                  return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              // 화면 확장
                              child: Container(
                                // 매장 정보
                                
                                
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                                  children: [
                                    Text(
                                      datas[index].star.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 15, color: Colors.orange.withOpacity(0.7)),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      datas[index].review.toString(),
                                      
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black.withOpacity(0.7)),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "긍정도: "+((datas[index].positivity * 10000).round()/100).toString() + "%",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.blue),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                    
                                      "속성: "+datas[index].attribute.toString(),
                                      
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.pink),
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    
                  
                },
                separatorBuilder: (BuildContext _context, int index) {
                  // 분할선
                  return Container(height: 1, color: Colors.pink.withOpacity(0.4));
                },
                itemCount: datas.length,
              )
          )
        )
        ],
      )
    );
  }

  // 바디 (리스트)
  Widget _bodyWidget() {
    return FutureBuilder(
        future: postList,
        builder: (BuildContext context, dynamic snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            // 데이터 없을 때 로딩 처리
            return Center(
                //child: CircularProgressIndicator(),
                child: Image.asset("assets/images/analysis.gif"),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("데이터 로드 오류"),
            );
          }
          if (snapshot.hasData) {
            // 데이터 있을 때만
            List<Post> myData = snapshot.data;
            switch (currentTag){
              case "all":
                break;
              case "food":
                myData = myData.where((x) => x.attribute == "음식").toList();
                break;
              case "temperature":
                myData = myData.where((x) => x.attribute == "온도").toList();
                break;
              case "clean":
                myData = myData.where((x) => x.attribute == "청결").toList();
                break;
              case "convinience":
                myData = myData.where((x) => x.attribute == "편의성").toList();
                break;
              case "mood":
                myData = myData.where((x) => x.attribute == "분위기").toList();
                break; 
              case "kind":
                myData = myData.where((x) => x.attribute == "친절").toList();
                break;
              case "price":
                myData = myData.where((x) => x.attribute == "가격").toList();
                break;
              case "location":
                myData = myData.where((x) => x.attribute == "위치").toList();
                break; 
            }

            if(currentLocation == "default"){ // 최신순
            }
            else if(currentLocation == "positivity"){ // 긍정순
              myData.sort((b, a) => a.positivity.compareTo(b.positivity));
            }
            else if(currentLocation == "negativity"){ // 부정순
              myData.sort((a, b) => a.positivity.compareTo(b.positivity));
            }
            return _makeDataList(myData);
          }
          return Center(child: Text("해당 매장에 리뷰가 없습니다"));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}
