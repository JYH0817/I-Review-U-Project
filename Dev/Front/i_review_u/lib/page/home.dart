import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:i_review_u/repository/contents_repository.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String currentLocation;
  late ContentsRepository contentsRepository;
  final Map<String, String> locationTypeToString = {
    "seongnam" : "성남시 스터디카페",
    "songpa" : "송파구 스터디카페",
    "gangnam" : "강남구 스터디카페",
  };
  @override
  void initState() {
    super.initState();
    currentLocation = "seongnam";
    contentsRepository = ContentsRepository();
    
  }

  // 앱 바
  AppBar _appbarWidget(){
    return AppBar(
        title: GestureDetector(
          onTap: (){ // 탭
            print("tap");
          },
          onLongPress: (){ // 길게 클릭
            print("long press");
          }, // 추후 다른 이벤트 추가
          child: PopupMenuButton<String>(
            offset: Offset(0, 25), // 평행이동
            shape: ShapeBorder.lerp( // 원처리
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              1),
            onSelected: (String location){ // 클릭 이벤트
              setState(() {
                currentLocation = location;
              });
            },
            itemBuilder: (BuildContext context){ // 지역 리스트
              return [
                PopupMenuItem(value: "seongnam", child:Text("성남시")),
                PopupMenuItem(value: "songpa", child:Text("송파구")),
                PopupMenuItem(value: "gangnam", child:Text("강남구")),
              ];
            },
            child: Row(
              children: [ // 지역 선택
                Text(locationTypeToString[currentLocation].toString()),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.pink,
        elevation: 1,
        actions: [ // 상단 아이콘
          IconButton( onPressed: (){}, icon: Icon(Icons.search),), // 검색
          IconButton( onPressed: (){}, icon: Icon(Icons.tune),), // 기타
          IconButton( // 알림
            onPressed: (){}, 
            icon: SvgPicture.asset(
              "assets/svg/bell.svg",
              width: 22,
              )),
        ],
      );
  }

  _loadContents(){
    return contentsRepository.loadContentsFromLocation(currentLocation);
  }

  _makeDataList(List<Map<String, String>> datas){ // 매장 데이터
    return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (BuildContext _context, int index) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    ClipRRect(
                        // 매장 이미지
                        borderRadius:
                            BorderRadius.all(Radius.circular(20)), // 원 효과
                        child: Image.asset(
                          datas[index]["image"].toString(),
                          width: 100,
                          height: 100,
                        )),
                    Expanded(
                      // 화면 확장
                      child: Container(
                        // 매장 정보
                        height: 100,
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                          children: [
                            Text(
                              datas[index]["title"].toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 5),
                            Text(
                              datas[index]["location"].toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.3)),
                            ),
                            SizedBox(height: 5),
                            Text(
                              datas[index]["star"].toString() + "점",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 5),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/heart_off.svg",
                                    width: 13,
                                    height: 13,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(datas[index]["likes"].toString()),
                                ],
                              ),
                            )
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
          );
  }

  // 바디 (리스트)
  Widget _bodyWidget(){
    return FutureBuilder(
      future: _loadContents(),
      builder: (BuildContext context,dynamic snapshot) {
        if(snapshot.connectionState != ConnectionState.done){ // 데이터 없을 때 로딩 처리
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.hasError){
          return Center(child: Text("데이터 로드 오류"),);
        }
        if(snapshot.hasData){// 데이터 있을 때만
          return _makeDataList(snapshot.data);
        }

        return Center(child: Text("해당 지역에 데이터가 없습니다"));

        
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
