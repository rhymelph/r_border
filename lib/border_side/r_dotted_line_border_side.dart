import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

import 'r_border_side.dart';

class RDottedLineBorderSide extends RBorderSide {
  final double dottedLength;
  final double dottedSpace;

  const RDottedLineBorderSide(
      {this.dottedLength = 5,
      this.dottedSpace = 5,
      super.color = const Color(0xFF000000),
      super.width = 1.0,
      super.style = BorderStyle.solid});

  @override
  void paint(Canvas canvas, Path path, Paint paint) {
    canvas.drawPath(_buildDashPath(path, dottedLength, dottedSpace), paint);
  }

  Path _buildDashPath(Path path, double dottedLength, double dottedSpace) {
    final Path r = Path();
    for (PathMetric metric in path.computeMetrics()) {
      double start = 0.0;
      while (start < metric.length) {
        double end = start + dottedLength;
        r.addPath(metric.extractPath(start, end), Offset.zero);
        start = end + dottedSpace;
      }
    }
    return r;
  }

  @override
  bool isUniformX(RBorderSide left, RBorderSide right, RBorderSide bottom) {
    if (left is RDottedLineBorderSide &&
        right is RDottedLineBorderSide &&
        bottom is RDottedLineBorderSide) {
      return dottedLength == left.dottedLength &&
          dottedLength == right.dottedLength &&
          dottedLength == bottom.dottedLength &&
          dottedSpace == left.dottedSpace &&
          dottedSpace == right.dottedSpace &&
          dottedSpace == bottom.dottedSpace;
    }
    return false;
  }
}
