class ContentsRepository{
  Map<String, dynamic> data = { 
    "seongnam" : [
      {
        "image" : "assets/images/sample.jpg",
        "title" : "스터디 카페 1",
        "location" : "경기도 성남시 복정동",
        "star" : "4.5",
        "likes" : "2"
      },
      {
        "image" : "assets/images/sample.jpg",
        "title" : "스터디 카페 2",
        "location" : "경기도 성남시 복정동",
        "star" : "3",
        "likes" : "5"
      },
      {
        "image" : "assets/images/sample.jpg",
        "title" : "스터디 카페 3",
        "location" : "경기도 성남시 복정동",
        "star" : "1",
        "likes" : "1"
      },
      {
        "image" : "assets/images/sample.jpg",
        "title" : "스터디 카페 4",
        "location" : "경기도 성남시 복정동",
        "star" : "2",
        "likes" : "10"
      },
      {
        "image" : "assets/images/sample.jpg",
        "title" : "스터디 카페 5",
        "location" : "경기도 성남시 복정동",
        "star" : "5",
        "likes" : "3"
      },
      {
        "image" : "assets/images/sample.jpg",
        "title" : "스터디 카페 6",
        "location" : "경기도 성남시 복정동",
        "star" : "4",
        "likes" : "7"
      },
      {
        "image" : "assets/images/sample.jpg",
        "title" : "스터디 카페 7",
        "location" : "경기도 성남시 복정동",
        "star" : "3",
        "likes" : "6"
      },
      {
        "image" : "assets/images/sample.jpg",
        "title" : "스터디 카페 8",
        "location" : "경기도 성남시 복정동",
        "star" : "1",
        "likes" : "2"
      },
    ],
    "songpa" : [
      {
        "image" : "assets/images/sample.jpg",
        "title" : "스터디 카페 1",
        "location" : "서울시 송파구 위례동",
        "star" : "4.5",
        "likes" : "2"
      },
      {
        "image" : "assets/images/sample.jpg",
        "title" : "스터디 카페 2",
        "location" : "서울시 송파구 위례동",
        "star" : "3",
        "likes" : "5"
      },
      {
        "image" : "assets/images/sample.jpg",
        "title" : "스터디 카페 3",
        "location" : "서울시 송파구 위례동",
        "star" : "1",
        "likes" : "1"
      },
    ],

  };
   
    Future<List<Map<String, String>>> loadContentsFromLocation(String location) async {
      // API 통신 추가 필요
      await Future.delayed(Duration(milliseconds: 1000)); // 지연시간
      return data[location];
    }
}