library r_border;

import 'dart:ui';

import 'package:flutter/material.dart';

import 'border_side/r_border_side.dart';

class RBorder extends BoxBorder {
  const RBorder({
    this.top = BorderSide.none,
    this.right = BorderSide.none,
    this.bottom = BorderSide.none,
    this.left = BorderSide.none,
  });

  const RBorder.fromBorderSide(BorderSide side)
      : top = side,
        right = side,
        bottom = side,
        left = side;

  const RBorder.symmetric({
    BorderSide vertical = BorderSide.none,
    BorderSide horizontal = BorderSide.none,
  })  : left = vertical,
        top = horizontal,
        right = vertical,
        bottom = horizontal;

  factory RBorder.all({
    Color color = const Color(0xFF000000),
    double width = 1.0,
  }) {
    final BorderSide side =
        BorderSide(color: color, width: width, style: BorderStyle.solid);
    return RBorder.fromBorderSide(
      side,
    );
  }

  static RBorder merge(RBorder a, RBorder b) {
    assert(BorderSide.canMerge(a.top, b.top));
    assert(BorderSide.canMerge(a.right, b.right));
    assert(BorderSide.canMerge(a.bottom, b.bottom));
    assert(BorderSide.canMerge(a.left, b.left));
    return RBorder(
      top: BorderSide.merge(a.top, b.top),
      right: BorderSide.merge(a.right, b.right),
      bottom: BorderSide.merge(a.bottom, b.bottom),
      left: BorderSide.merge(a.left, b.left),
    );
  }

  @override
  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.fromLTRB(
        left.width, top.width, right.width, bottom.width);
  }

  bool get _colorIsUniform {
    final Color topColor = top.color;
    return right.color == topColor &&
        bottom.color == topColor &&
        left.color == topColor;
  }

  bool get _widthIsUniform {
    final double topWidth = top.width;
    return right.width == topWidth &&
        bottom.width == topWidth &&
        left.width == topWidth;
  }

  bool get _styleIsUniform {
    final BorderStyle topStyle = top.style;
    return right.style == topStyle &&
        bottom.style == topStyle &&
        left.style == topStyle;
  }

  bool get _typeIsUniform {
    final Type topStyle = top.runtimeType;
    return right.runtimeType == topStyle &&
        bottom.runtimeType == topStyle &&
        left.runtimeType == topStyle;
  }

  bool get _rBorderSideIsUniform {
    if (top is RBorderSide &&
        right is RBorderSide &&
        bottom is RBorderSide &&
        left is RBorderSide) {
      return (top as RBorderSide).isUniformX(
          left as RBorderSide, right as RBorderSide, bottom as RBorderSide);
    }
    return false;
  }

  @override
  bool get isUniform =>
      _colorIsUniform &&
      _widthIsUniform &&
      _styleIsUniform &&
      _typeIsUniform &&
      _rBorderSideIsUniform;

  @override
  void paint(Canvas canvas, Rect rect,
      {TextDirection? textDirection,
      BoxShape shape = BoxShape.rectangle,
      BorderRadius? borderRadius}) {
    if (isUniform) {
      switch (top.style) {
        case BorderStyle.none:
          return;
        case BorderStyle.solid:
          switch (shape) {
            case BoxShape.circle:
              assert(borderRadius == null,
                  'A borderRadius can only be given for rectangular boxes.');
              final double width = top.width;
              final Paint paint = top.toPaint();
              final double radius = (rect.shortestSide - width) / 2.0;
              if (top is RBorderSide) {
                Rect inner = rect.deflate(width);
                (top as RBorderSide)
                    .paint(canvas, Path()..addOval(inner), paint);
              } else {
                canvas.drawCircle(rect.center, radius, paint);
              }
              break;
            case BoxShape.rectangle:
              if (borderRadius != null) {
                final Paint paint = Paint()..color = top.color;
                final RRect outer = borderRadius.toRRect(rect);
                final double width = top.width;
                if (width == 0.0) {
                  paint
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 0.0;
                  if (top is RBorderSide) {
                    (top as RBorderSide)
                        .paint(canvas, Path()..addRRect(outer), paint);
                  } else {
                    canvas.drawRRect(outer, paint);
                  }
                } else {
                  final RRect inner = outer.deflate(width);
                  if (top is RBorderSide) {
                    (top as RBorderSide)
                        .paint(canvas, Path()..addRRect(inner), paint);
                  } else {
                    canvas.drawDRRect(outer, inner, paint);
                  }
                }
                return;
              }
              final double width = top.width;
              final Paint paint = top.toPaint();
              if (top is RBorderSide) {
                (top as RBorderSide).paint(
                    canvas, Path()..addRect(rect.deflate(width / 2.0)), paint);
              } else {
                canvas.drawRect(rect.deflate(width / 2.0), paint);
              }
              break;
          }
          return;
      }
    }

    assert(() {
      if (borderRadius != null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'A borderRadius can only be given for a uniform Border.'),
          ErrorDescription('The following is not uniform:'),
          if (!_colorIsUniform) ErrorDescription('BorderSide.color'),
          if (!_widthIsUniform) ErrorDescription('BorderSide.width'),
          if (!_styleIsUniform) ErrorDescription('BorderSide.style'),
        ]);
      }
      return true;
    }());
    assert(() {
      if (shape != BoxShape.rectangle) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'A Border can only be drawn as a circle if it is uniform'),
          ErrorDescription('The following is not uniform:'),
          if (!_colorIsUniform) ErrorDescription('BorderSide.color'),
          if (!_widthIsUniform) ErrorDescription('BorderSide.width'),
          if (!_styleIsUniform) ErrorDescription('BorderSide.style'),
        ]);
      }
      return true;
    }());

    // print('paint border');

    paintDottedBorder(canvas, rect,
        top: top, right: right, bottom: bottom, left: left);
  }

  void paintDottedBorder(
    Canvas canvas,
    Rect rect, {
    BorderSide top = BorderSide.none,
    BorderSide right = BorderSide.none,
    BorderSide bottom = BorderSide.none,
    BorderSide left = BorderSide.none,
  }) {
    // We draw the borders as filled shapes, unless the borders are hairline
    // borders, in which case we use PaintingStyle.stroke, with the stroke width
    // specified here.
    final Paint paint = Paint()..strokeWidth = 0.0;

    final Path path = Path();

    switch (top.style) {
      case BorderStyle.solid:
        paint.color = top.color;
        path.reset();
        path.moveTo(rect.left, rect.top + top.width / 2);
        path.lineTo(rect.right, rect.top + top.width / 2);
        paint.style = PaintingStyle.stroke;
        if (top is RBorderSide) {
          top.paint(canvas, path, paint..strokeWidth = top.width);
        } else {
          canvas.drawPath(path, paint..strokeWidth = top.width);
        }
        break;
      case BorderStyle.none:
        break;
    }

    switch (right.style) {
      case BorderStyle.solid:
        paint.color = right.color;
        path.reset();
        path.moveTo(rect.right, rect.top);
        path.lineTo(rect.right, rect.bottom);
        paint.style = PaintingStyle.stroke;

        if (right is RBorderSide) {
          right.paint(canvas, path, paint..strokeWidth = right.width);
        } else {
          canvas.drawPath(path, paint..strokeWidth = right.width);
        }
        break;
      case BorderStyle.none:
        break;
    }

    switch (bottom.style) {
      case BorderStyle.solid:
        paint.color = bottom.color;
        path.reset();
        path.moveTo(rect.right, rect.bottom);
        path.lineTo(rect.left, rect.bottom);
        paint.style = PaintingStyle.stroke;
        if (bottom is RBorderSide) {
          bottom.paint(canvas, path, paint..strokeWidth = bottom.width);
        } else {
          canvas.drawPath(path, paint..strokeWidth = bottom.width);
        }
        break;
      case BorderStyle.none:
        break;
    }

    switch (left.style) {
      case BorderStyle.solid:
        paint.color = left.color;
        path.reset();
        path.moveTo(rect.left + left.width / 2, rect.bottom);
        path.lineTo(rect.left + left.width / 2, rect.top);
        paint.style = PaintingStyle.stroke;
        if (left is RBorderSide) {
          left.paint(canvas, path, paint..strokeWidth = left.width);
        } else {
          canvas.drawPath(path, paint..strokeWidth = left.width);
        }
        break;
      case BorderStyle.none:
        break;
    }
  }

  @override
  ShapeBorder scale(double t) {
    return RBorder(
      top: top.scale(t),
      right: right.scale(t),
      bottom: bottom.scale(t),
      left: left.scale(t),
    );
  }

  @override
  BoxBorder? add(ShapeBorder other, {bool reversed = false}) {
    if (other is RBorder &&
        BorderSide.canMerge(top, other.top) &&
        BorderSide.canMerge(right, other.right) &&
        BorderSide.canMerge(bottom, other.bottom) &&
        BorderSide.canMerge(left, other.left)) {
      return RBorder.merge(this, other);
    }
    return null;
  }

  @override
  final BorderSide top;

  final BorderSide right;

  @override
  final BorderSide bottom;

  final BorderSide left;
}
