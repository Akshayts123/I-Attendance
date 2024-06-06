import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iattendence/Widget/wave.dart';


import 'customClipper.dart';

class BezierContainer extends StatelessWidget {
  const BezierContainer({Key ?key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Container(
      child: Stack(
        children: [
          Container(
            height: size.height - 100,
            color: Color(0xFF314f8c),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuad,
            top: keyboardOpen ? -size.height / 3.7 : 0.0,
            child: WaveWidget(
              size: size,
              yOffset: size.height / 2.7,
              color: Colors.white,
            ),
          ),
        ],
      )
    );
  }
}