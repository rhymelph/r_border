import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

import 'r_border_side.dart';

class RGradientLineBorderSide extends RBorderSide {
  final Gradient gradient;

  const RGradientLineBorderSide(
      {this.gradient = const LinearGradient(colors: <Color>[
        Colors.black,
        Colors.white,
      ]),
      super.color = const Color(0xFF000000),
      super.width = 1.0,
      super.style = BorderStyle.solid});

  @override
  void paint(Canvas canvas, Path path, Paint paint) {
    canvas.drawPath(
        path, paint..shader = gradient.createShader(path.getBounds()));
  }

  @override
  bool isUniformX(RBorderSide left, RBorderSide right, RBorderSide bottom) {
    if (left is RGradientLineBorderSide &&
        right is RGradientLineBorderSide &&
        bottom is RGradientLineBorderSide) {
      return gradient == left.gradient &&
          gradient == right.gradient &&
          gradient == bottom.gradient;
    }
    return false;
  }
}
