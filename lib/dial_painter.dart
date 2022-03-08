
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;


class DialPainter extends CustomPainter{

  late double width;
  late double height;
  late double radius;
  late final Paint _paint = _initPaint();
  late double unit ;

  Paint _initPaint() {
    return Paint()
      ..isAntiAlias = true
      ..color = Colors.white;
  }

  @override
  void paint(Canvas canvas, Size size) {
    initSize(size);

    drawDial(canvas);

    drawCalibration(canvas);

    drawText(canvas);


    drawCenter(canvas);

    var date = DateTime.now();

    drawHour(canvas, date);

    drawMinutes(canvas, date);

    drawSeconds(canvas, date);

  }

  void initSize(Size size) {
    width = size.width;
    height = size.height;
    radius = min(width, height) / 2;
    unit = radius / 15;
  }

  void drawSeconds(Canvas canvas, DateTime date) {
    double hourHalfHeight = 0.4 * unit;
    double secondsLeft = -4.5 * unit;
    double secondsTop = -hourHalfHeight;
    double secondsRight = 12.5 * unit;
    double secondsBottom = hourHalfHeight;

    Path secondsPath = Path();
    secondsPath.moveTo(secondsLeft, secondsTop);

    /// 尾部弧形
    var rect = Rect.fromLTWH(secondsLeft, secondsTop, 2.5 * unit, hourHalfHeight * 2);
    secondsPath.addArc(rect, pi/2, pi);

    /// 尾部圆角矩形
    var rRect = RRect.fromLTRBR(secondsLeft + 1 * unit, secondsTop, - 2 * unit, secondsBottom, Radius.circular(0.25 * unit));
    secondsPath.addRRect(rRect);

    /// 指针
    secondsPath.moveTo(- 2 * unit, - 0.125 * unit);
    secondsPath.lineTo(secondsRight, 0);
    secondsPath.lineTo(-2 * unit, 0.125 * unit);

    /// 中心圆
    var ovalRect = Rect.fromLTWH(- 0.67 * unit, - 0.67 * unit, 1.33 * unit, 1.33 * unit);
    secondsPath.addOval(ovalRect);

    canvas.save();
    canvas.translate(width/2, height/2);
    canvas.rotate(2*pi/60 * (date.second - 15));

    /// 绘制阴影
    canvas.drawShadow(secondsPath, const Color(0xFFcc0000), 0.17 * unit, true);

    /// 绘制秒针
    _paint.color = const Color(0xFFcc0000);
    canvas.drawPath(secondsPath, _paint);

    canvas.restore();
  }

  void drawMinutes(Canvas canvas, DateTime date) {
    double hourHalfHeight = 0.4 * unit;
    double minutesLeft = -1.33 * unit;
    double minutesTop = -hourHalfHeight;
    double minutesRight = 11* unit;
    double minutesBottom = hourHalfHeight;

    canvas.save();
    canvas.translate(width/2, height/2);
    canvas.rotate(2*pi/60 * (date.minute - 15 + date.second / 60));

    /// 绘制分针
    var rRect = RRect.fromLTRBR(minutesLeft, minutesTop, minutesRight, minutesBottom, Radius.circular(0.42 * unit));
    _paint.color = const Color(0xFF343536);
    canvas.drawRRect(rRect, _paint);

    canvas.restore();
  }

  void drawHour(Canvas canvas, DateTime date) {

    double hourHalfHeight = 0.4 * unit;
    double hourRectRight =   7 * unit;

    Path hourPath = Path();
    /// 添加矩形 时针主体
    hourPath.moveTo(0 - hourHalfHeight, 0 - hourHalfHeight);
    hourPath.lineTo(hourRectRight, 0 - hourHalfHeight);
    hourPath.lineTo(hourRectRight, 0 + hourHalfHeight);
    hourPath.lineTo(0 - hourHalfHeight, 0 + hourHalfHeight);

    /// 时针箭头尾部弧形
    double offsetTop = 0.5 * unit;
    double arcWidth = 1.5 * unit;
    double arrowWidth = 2.17 * unit;
    double offset = 0.42 * unit;
    var rect = Rect.fromLTWH(hourRectRight - offset, 0 - hourHalfHeight - offsetTop, arcWidth, hourHalfHeight * 2 + offsetTop * 2);
    hourPath.addArc(rect, pi/2, pi);
    /// 时针箭头
    hourPath.moveTo(hourRectRight - offset + arcWidth/2, 0 - hourHalfHeight - offsetTop);
    hourPath.lineTo(hourRectRight - offset + arcWidth/2 + arrowWidth, 0);
    hourPath.lineTo(hourRectRight - offset + arcWidth/2, 0 + hourHalfHeight + offsetTop);
    hourPath.close();

    canvas.save();
    canvas.translate(width/2, height/2);
    canvas.rotate(2*pi/60*((date.hour - 3 + date.minute / 60 + date.second/60/60) * 5 ));
    ///绘制
    _paint.color = const Color(0xFF232425);
    canvas.drawPath(hourPath, _paint);
    canvas.restore();
  }

  void drawCenter(Canvas canvas) {
    var radialGradient =
        ui.Gradient.radial(Offset(width / 2, height / 2), radius, [
      const Color.fromARGB(255, 200, 200, 200),
      const Color.fromARGB(255, 190, 190, 190),
      const Color.fromARGB(255, 130, 130, 130),
    ], [0, 0.9, 1.0]);

    /// 底部背景
    _paint
      ..shader = radialGradient
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(width/2, height/2), 2 * unit, _paint);


    /// 顶部圆点
    _paint
      ..shader = null
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF121314);
    canvas.drawCircle(Offset(width/2, height/2), 0.8 * unit, _paint);
  }

  void drawDial(ui.Canvas canvas) {
    /// 绘制一个线性渐变的圆
    var gradient = ui.Gradient.linear(
        Offset(width/2, height/2 - radius,),
        Offset(width/2, height/2 + radius),
        [const Color(0xFFF9F9F9), const Color(0xFF666666)]);

    _paint.shader = gradient;
    _paint.color = Colors.white;
    canvas.drawCircle(Offset(width/2, height/2), radius, _paint);

    /// 绘制一层径向渐变的圆
    var radialGradient = ui.Gradient.radial(Offset(width/2, height/2), radius, [
      const Color.fromARGB(216, 246, 248, 249),
      const Color.fromARGB(216, 229, 235, 238),
      const Color.fromARGB(216,205, 212, 217),
      const Color.fromARGB(216,245, 247, 249),
    ], [0, 0.92, 0.93, 1.0]);

    _paint.shader = radialGradient;
    canvas.drawCircle(Offset(width/2, height/2), radius -  0.3 * unit, _paint);

    /// 绘制一层border
    var shadowRadius = radius -  0.8 * unit;
    _paint
      ..color = const Color.fromARGB(33, 0, 0, 0)
      ..shader = null
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.1 * unit;
    canvas.drawCircle(Offset(width/2, height/2), shadowRadius - 0.2 * unit, _paint);

    ///绘制阴影
    Path path = Path();
    path.moveTo(width/2, height/2);
    var rect = Rect.fromLTRB(width/2 - shadowRadius, height/2 - shadowRadius, width/2+shadowRadius, height /2 +shadowRadius);
    path.addOval(rect);
    canvas.drawShadow(path, const Color.fromARGB(51, 0, 0, 0), 1 * unit, true);
  }

  /// 绘制刻度
  void drawCalibration(ui.Canvas canvas) {
    double dialCanvasRadius = radius -  0.8 * unit;
    canvas.save();
    canvas.translate(width/2, height/2);

    var y = 0.0;
    var x1 = 0.0;
    var x2 = 0.0;

    _paint.shader = null;
    _paint.color = const Color(0xFF929394);
    for( int i = 0; i < 60; i++){
      x1 =  dialCanvasRadius - (i % 5 == 0 ? 0.85 * unit : 1 * unit);
      x2 = dialCanvasRadius - (i % 5 == 0 ? 2 * unit : 1.67 * unit);
      _paint.strokeWidth = i % 5 == 0 ? 0.38 * unit : 0.2 * unit;
      canvas.drawLine(Offset(x1, y), Offset(x2, y), _paint);
      canvas.rotate(2*pi/60);
    }
    canvas.restore();
  }

  /// 绘制刻度上的值 3 6 9 12
  void drawText(ui.Canvas canvas) {
    double dialCanvasRadius = radius -  0.8 * unit;
    var textPainter = TextPainter(
      text: const TextSpan(
          text:
          "3",
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, height: 1.0)),
      textDirection: TextDirection.rtl,
      textWidthBasis: TextWidthBasis.longestLine,
      maxLines: 1,
    )..layout();

    var offset = 2.25 * unit;
    var points = [
      Offset(width / 2 + dialCanvasRadius - offset - textPainter.width , height / 2 - textPainter.height / 2),
      Offset(width / 2 - textPainter.width /2, height / 2 + dialCanvasRadius - offset - textPainter.height),
      Offset(width / 2 - dialCanvasRadius + offset, height / 2 - textPainter.height / 2),
      Offset(width / 2 - textPainter.width, height / 2 - dialCanvasRadius + offset),
    ];
    for(int i = 0; i< 4; i++){

      textPainter = TextPainter(
        text: TextSpan(
            text:
            "${(i + 1) * 3}",
            style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, height: 1.0)),
        textDirection: TextDirection.rtl,
        textWidthBasis: TextWidthBasis.longestLine,
        maxLines: 1,
      )..layout();

      textPainter.paint(canvas, points[i]);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}