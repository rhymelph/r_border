import 'package:flutter/material.dart';

abstract class RBorderSide extends BorderSide {
  const RBorderSide({
    super.color = const Color(0xFF000000),
    super.width = 1.0,
    super.style = BorderStyle.solid,
  }) : assert(width >= 0.0);

  void paint(Canvas canvas, Path path, Paint paint);

  bool isUniformX(RBorderSide left, RBorderSide right, RBorderSide bottom);
}
