
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_dial/dial_painter.dart';

class DialPage extends StatefulWidget {
  const DialPage({Key? key}) : super(key: key);

  @override
  State<DialPage> createState() => _DialPageState();
}

class _DialPageState extends State<DialPage> {


  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: const Color.fromARGB(255, 35, 36, 38),
      child: Center(
        child: CustomPaint( // 使用CustomPaint
          size: Size(width, width),
          painter: DialPainter(),
        ),
      ),
    );
  }
}


