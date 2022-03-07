
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DialPage extends StatefulWidget {
  const DialPage({Key? key}) : super(key: key);

  @override
  State<DialPage> createState() => _DialPageState();
}

class _DialPageState extends State<DialPage> {


  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      child: CustomPaint( // 使用CustomPaint
        painter: DialView(width, height),
      ),
    );
  }
}


class DialView extends CustomPainter{

  final double width;
  final double height;
  final double radius;
  late final Paint _paint = _initPaint();
  DialView(this.width, this.height) : radius = width / 2 -20;


  Paint _initPaint(){
    return Paint()..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTRB(0, 0, width, height), _paint..color = Color.fromARGB(255, 35, 36, 38));

    double shadowRadius = drawDial(canvas);

    drawCalibration(shadowRadius, canvas);

    drawText(shadowRadius, canvas);



    var radialGradient = ui.Gradient.radial(Offset(width/2, height/2), radius, [
      const Color.fromARGB(255, 200,200,200),
      const Color.fromARGB(255,190,190,190),
      const Color.fromARGB(255,130,130,130),
    ], [0, 0.9, 1.0]);
    canvas.drawCircle(Offset(width/2, height/2), radius/15*2, _paint..shader = radialGradient..style = PaintingStyle.fill);


    canvas.drawCircle(Offset(width/2, height/2), radius/15*0.8, _paint..shader = null..style = PaintingStyle.fill..color = const Color(0xFF121314));

    var date = DateTime.now();


    double hourHalfHeight = radius/15 * 0.4;
    double hourRectRight =   radius/15 * 7;
    Path hourPath = Path();
    hourPath.moveTo(0 - hourHalfHeight, 0 - hourHalfHeight);
    hourPath.lineTo(hourRectRight, 0 - hourHalfHeight);
    hourPath.lineTo(hourRectRight, 0 + hourHalfHeight);
    hourPath.lineTo(0 - hourHalfHeight, 0 + hourHalfHeight);

    double offsetTop = 6;
    double arcWidth = 18;
    double arrowWidth = 26;
    hourPath.addArc(Rect.fromLTWH(hourRectRight - 5, 0 - hourHalfHeight - offsetTop, arcWidth, hourHalfHeight * 2 + offsetTop * 2), pi/2, pi);
    hourPath.moveTo(hourRectRight - 5 + arcWidth/2, 0 - hourHalfHeight - offsetTop);
    hourPath.lineTo(hourRectRight - 5 + arcWidth/2 + arrowWidth, 0);
    hourPath.lineTo(hourRectRight - 5 + arcWidth/2, 0 + hourHalfHeight + offsetTop);
    hourPath.close();
    canvas.save();
    canvas.translate(width/2, height/2);

    canvas.rotate(2*pi/60*((date.hour - 3 + date.minute / 60 + date.second/60/60) * 5 ));
    canvas.drawPath(hourPath, _paint..color = const Color(0xFF232425));
    canvas.restore();

    double minutesLeft = -16;
    double minutesTop = -hourHalfHeight;
    double minutesRight = radius/15 * 11;
    double minutesBottom = hourHalfHeight;

    canvas.save();
    canvas.translate(width/2, height/2);
    canvas.rotate(2*pi/60 * (date.minute - 15 + date.second / 60));
    canvas.drawRRect(RRect.fromLTRBR(minutesLeft, minutesTop, minutesRight, minutesBottom, Radius.circular(5)), _paint..color = const Color(0xFF343536));
    canvas.restore();

    double secondsLeft = -30 - radius/15*2;
    double secondsTop = -hourHalfHeight;
    double secondsRight = radius/15 * 12.5;
    double secondsBottom = hourHalfHeight;

    Path secondsPath = Path();
    secondsPath.moveTo(secondsLeft, secondsTop);
    secondsPath.addArc(Rect.fromLTWH(secondsLeft, secondsTop, 30, hourHalfHeight * 2), pi/2, pi);
    secondsPath.addRRect(RRect.fromLTRBR(secondsLeft + 12, secondsTop, -radius/15*2, secondsBottom, Radius.circular(3)));
    secondsPath.moveTo(-radius/15*2, -1.5);
    secondsPath.lineTo(secondsRight, 0);
    secondsPath.lineTo(-radius/15*2, 1.5);
    secondsPath.addOval(Rect.fromLTWH(0-8, 0-8, 16, 16));
    canvas.save();
    canvas.translate(width/2, height/2);
    canvas.rotate(2*pi/60 * (date.second - 15));
    canvas.drawShadow(secondsPath, const Color(0xFFcc0000), 2, true);
    canvas.drawPath(secondsPath, _paint..color = const Color(0xFFcc0000));
    // canvas.drawRRect(RRect.fromLTRBR(secondsLeft, secondsTop, secondsRight, secondsBottom, Radius.circular(5)), _paint..color = const Color(0xFFcc0000));
    canvas.restore();




  }

  double drawDial(ui.Canvas canvas) {
    var gradient = ui.Gradient.linear(Offset(width/2, height/2 - radius,), Offset(width/2, height/2 + radius), [const Color(0xFFF9F9F9), const Color(0xFF666666)]);
    canvas.drawCircle(Offset(width/2, height/2), radius, _paint..color = Colors.white..shader = gradient);

    var radialGradient = ui.Gradient.radial(Offset(width/2, height/2), radius, [
      const Color.fromARGB(255, 246, 248, 249),
      const Color.fromARGB(255, 229, 235, 238),
      const Color.fromARGB(255,205, 212, 217),
      const Color.fromARGB(255,245, 247, 249),
    ], [0, 0.92, 0.93, 1.0]);

    var shadowRadius = radius - radius / 15 * 0.8;
    canvas.drawCircle(Offset(width/2, height/2), radius - radius / 15 * 0.3, _paint..color = Colors.white..shader = radialGradient);

    canvas.drawCircle(Offset(width/2, height/2), shadowRadius - radius/15*0.2, _paint..color = Color.fromARGB(33, 0, 0, 0)..shader = null..style = PaintingStyle.stroke..strokeWidth = radius/15*0.1);

    Path path = Path();
    path.moveTo(width/2, height/2);
    path.addOval(Rect.fromLTRB(width/2 - shadowRadius, height/2 - shadowRadius, width/2+shadowRadius, height /2 +shadowRadius));
    canvas.drawShadow(path, const Color.fromARGB(51, 0, 0, 0), radius/15, true);
    return shadowRadius;
  }

  void drawCalibration(double shadowRadius, ui.Canvas canvas) {

    for( int i = 0; i < 60; i++){

      if(i % 5 == 0){

        var x1 = width/2 + (shadowRadius - 10) * cos(6 * i * pi / 180);
        var y1 = height/2 + (shadowRadius - 10) * sin(6 * i * pi / 180);

        var x2 = width/2 + (shadowRadius - 24) * cos(6 * i * pi / 180);
        var y2 = height/2 + (shadowRadius - 24) * sin(6 * i * pi / 180);

        _paint..shader = null..strokeWidth = 4;
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), _paint..color = Color(0xFF929394));
      }else{
        var x1 = width/2 + (shadowRadius - 12) * cos(6 * i * pi / 180);
        var y1 = height/2 + (shadowRadius - 12) * sin(6 * i * pi / 180);

        var x2 = width/2 + (shadowRadius - 20) * cos(6 * i * pi / 180);
        var y2 = height/2 + (shadowRadius - 20) * sin(6 * i * pi / 180);

        _paint..shader = null..strokeWidth = 2;
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), _paint..color = Color(0xFF929394));
      }
    }
  }

  void drawText(double shadowRadius, ui.Canvas canvas) {

    for(int i = 0; i< 4; i++){
      var x = width/2 + (shadowRadius - 24) * cos(90 * i * pi / 180);
      var y = height/2 + (shadowRadius - 24) * sin(90 * i * pi / 180);

      var textPainter = TextPainter(
        text: TextSpan(
            text:
            "${(i + 1) * 3}",
            style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.rtl,
        textWidthBasis: TextWidthBasis.longestLine,
        maxLines: 1,
      )..layout();

      var offset = Offset(x - textPainter.width - 5, y - textPainter.height / 2);


      ///  0.5 1 0.5 0
      ///  0   1  2  3
      ///
      /// 1   0.5   0    0.5
      // Offset(x - textPainter.width, y - (textPainter.height - textPainter.height / ((i + 1) % 2) * 2));
      if(i == 1){
        offset = Offset(x - textPainter.width / 2, y - textPainter.height);
      }else if(i == 2){
        offset = Offset(x + 5 , y - textPainter.height/2);
      }else if(i == 3){
        offset = Offset(x - textPainter.width / 2 , y);
      }
      textPainter.paint(canvas, offset);

    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
