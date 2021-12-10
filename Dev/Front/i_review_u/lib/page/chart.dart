// @dart=2.9
import 'package:flutter/material.dart';
import 'dart:math';

class PieChart extends CustomPainter {
  
  int percentage = 0; 
  double textScaleFactor = 1.0;
  PieChart({@required this.percentage, this.textScaleFactor = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint() // 화면에 그릴 때 쓸 Paint를 정의합니다. 
        ..color = Colors.redAccent
        ..strokeWidth = 10.0 // 선의 길이를 정합니다. 
        ..style = PaintingStyle.stroke // 선의 스타일을 정합니다. stroke면 외곽선만 그리고, fill이면 다 채웁니다. 
        ..strokeCap = StrokeCap.round; // stroke의 스타일을 정합니다. round를 고르면 stroke의 끝이 둥글게 됩니다. 


    double radius = min(size.width / 2 - paint.strokeWidth / 2 , size.height / 2 - paint.strokeWidth/2); // 원의 반지름을 구함. 선의 굵기에 영향을 받지 않게 보정함. 
    Offset center = Offset(size.width / 2, size.height/ 2); // 원이 위젯의 가운데에 그려지게 좌표를 정함.

    canvas.drawCircle(center, radius, paint); // 원을 그림. 
    double arcAngle = 2 * pi * (percentage / 100); // 호(arc)의 각도를 정함. 정해진 각도만큼만 그리도록 함. 
    paint..color = Colors.blueAccent; // 호를 그릴 때는 색을 바꿔줌. 
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, arcAngle, false, paint); // 호(arc)를 그림.

    drawText(canvas, size, "긍정 $percentage %\n", Colors.blue); // 텍스트를 화면에 표시함.
    drawText(canvas, size, "\n부정 ${100-percentage} %", Colors.red); // 텍스트를 화면에 표시함.
  }

  // 원의 중앙에 텍스트를 적음.
  void drawText(Canvas canvas, Size size, String text, Color myColor) {
    double fontSize = getFontSize(size, text);

    TextSpan sp = TextSpan(style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: myColor), text: text); // TextSpan은 Text위젯과 거의 동일하다. 
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr); 

    tp.layout(); // 필수! 텍스트 페인터에 그려질 텍스트의 크기와 방향를 정함.
    double dx = size.width / 2 - tp.width / 2;
    double dy = size.height / 2 - tp.height / 2;

    Offset offset = Offset(dx, dy); 
    tp.paint(canvas, offset);
  }

  // 화면 크기에 비례하도록 텍스트 폰트 크기를 정함.
  double getFontSize(Size size, String text) {
    return size.width / text.length * textScaleFactor;
  }

  @override
  bool shouldRepaint(PieChart old) {
    return old.percentage != percentage;
  }
}

class BarChart extends CustomPainter {
  Color color;
  double textScaleFactorXAxis = 1.0; // x축 텍스트의 비율을 정함. 
  double textScaleFactorYAxis = 1.2; // y축 텍스트의 비율을 정함. 
  List<double> data = [];
  List<String> labels = [];
  double bottomPadding = 0.0;
  double leftPadding = 0.0;

  BarChart({this.data, this.labels, this.color = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    setTextPadding(size); // 텍스트를 공간을 미리 정함.

    List<Offset> coordinates = getCoordinates(size);

    drawBar(canvas, size, coordinates);
    drawXLabels(canvas, size, coordinates);
    drawYLabels(canvas, size, coordinates);
    drawLines(canvas, size, coordinates);
  }

  void setTextPadding(Size size) {
    bottomPadding = size.height / 10; // 세로 크기의 1/10만큼만 텍스트 패딩을 줌
    leftPadding = size.width / 10; // 가로 길이의 1/10만큼 텍스트 패딩을 줌
  }

  void drawBar(Canvas canvas, Size size, List<Offset> coordinates) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    double barWidthMargin = (size.width * 0.09); // 막대 그래프가 겹치지 않게 간격을 줌. 

    for (var index = 0; index < coordinates.length; index++) {
      Offset offset = coordinates[index];
      double left = offset.dx;
      double right = offset.dx + barWidthMargin; // 간격만큼 가로로 이동
      double top = offset.dy;
      double bottom = size.height - bottomPadding; // 텍스트 크기만큼 패딩을 빼줘서, 텍스트와 겹치지 않게 함.  

      Rect rect = Rect.fromLTRB(right, top, left, bottom);
      canvas.drawRect(rect, paint);
    }
  }

  // X축 텍스트(레이블)을 그림. 
  void drawXLabels(Canvas canvas, Size size, List<Offset> coordinates) {
    double fontSize = calculateFontSize(labels[0], size, xAxis: true); // 화면 크기에 유동적으로 폰트 크기를 계산함. 

    for (int index = 0; index < labels.length; index++) {

      TextSpan span = TextSpan(
          style: TextStyle(
              
              color: Colors.black,
              fontSize: 10,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400),
          text: labels[index]);

      TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();

      Offset offset = coordinates[index];
      double dx = offset.dx;
      double dy = size.height - tp.height;

      tp.paint(canvas, Offset(dx, dy));
    }
  }

  // Y축 텍스트(레이블)을 그림. 최저값과 최고값을 Y축에 표시함.
  void drawYLabels(Canvas canvas, Size size, List<Offset> coordinates) {
    double bottomY = coordinates[0].dy;
    double topY = coordinates[0].dy;
    int indexOfMax = 0; 
    int indexOfMin = 0; 

    for (int index = 0; index < coordinates.length; index++) {
      double dy = coordinates[index].dy;

      if (bottomY < dy) {
        bottomY = dy;
        indexOfMin = index;
      }

      if (topY > dy) {
        topY = dy;
        indexOfMax = index;
      }
    }

    String maxValue = "${data[indexOfMax].toInt()}";
    String minValue = "${data[indexOfMin].toInt()}";

    double fontSize = calculateFontSize(maxValue, size, xAxis: false);

    drawYText(canvas, maxValue, 13, topY);
    drawYText(canvas, minValue, 13, bottomY);
  }

  // 화면 크기에 비례해 폰트 크기를 계산. 
  double calculateFontSize(String value, Size size, {bool xAxis}) {
    int numberOfCharacters = value.length; // 글자수에 따라 폰트 크기를 계산하기 위함. 
    double fontSize = (size.width / numberOfCharacters) / data.length; // width가 600일 때 100글자를 적어야 한다면, fontSize는 글자 하나당 6이어야겠죠. 

    if (xAxis) {
      fontSize *= textScaleFactorXAxis; 
    } else {
      fontSize *= textScaleFactorYAxis;
    }

    return fontSize;
  }

  // x축과 y축을 구분하는 선을 긋습니다. 
  void drawLines(Canvas canvas, Size size, List<Offset> coordinates) {
    Paint paint = Paint()
      ..color = Colors.blueGrey[100]
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    double bottom = size.height - bottomPadding;
    double left = coordinates[0].dx;

    Path path = Path();
    path.moveTo(left, 0);
    path.lineTo(left, bottom);
    path.lineTo(size.width, bottom);

    canvas.drawPath(path, paint);
  }

  void drawYText(Canvas canvas, String text, double fontSize, double y) {

    TextSpan span = TextSpan(
      style: TextStyle(
          fontSize: fontSize,
          color: Colors.pinkAccent,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600),
      text: text+'개',
    );

    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);

    tp.layout();

    Offset offset = Offset(0.0, y);
    tp.paint(canvas, offset);
  }

  List<Offset> getCoordinates(Size size) {
    List<Offset> coordinates = [];

    double maxData = data.reduce(max);

    double width = size.width - leftPadding;
    double minBarWidth = width / data.length;

    for (var index = 0; index < data.length; index++) {
      double left = minBarWidth * (index) + leftPadding; // 그래프의 가로 위치를 정합니다. 
      double normalized = data[index] / maxData; // 그래프의 높이가 [0~1] 사이가 되도록 정규화 합니다.
      double height = size.height - bottomPadding; // x축에 표시되는 글자들과 겹치지 않게 높이에서 패딩을 제외합니다.
      double top = height - normalized * height; // 정규화된 값을 통해 높이를 구해줍니다. 

      Offset offset = Offset(left, top);
      coordinates.add(offset);
    }

    return coordinates;
  }

  @override
  bool shouldRepaint(BarChart old) {
    return old.data != data;
  }
}