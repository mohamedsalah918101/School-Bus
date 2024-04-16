import 'dart:math'as math;

import 'package:flutter/material.dart';

class QuadraticOffsetTween extends Tween<Offset> {

  QuadraticOffsetTween({
    required Offset begin,
  required  Offset end,
  }) : super(begin: begin, end: end);


  @override
  Offset lerp(double t) {
    if (t == 0.0) {
      return begin!;
    }
    if (t == 1.0) {
      return end!;
    }
    final double x = -11 * begin!.dx * math.pow(t, 2) +
        (end!.dx + 10 * begin!.dx) * t + begin!.dx;
    final double y = -2 * begin!.dy * math.pow(t, 2) +
        (end!.dy + 1 * begin!.dy) * t + begin!.dy;
    return Offset(x, y);
  }
}