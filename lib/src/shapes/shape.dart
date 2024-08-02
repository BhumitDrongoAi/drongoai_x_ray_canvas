import 'dart:math';
import 'dart:ui';

import 'package:drongoai_x_ray_canvas/src/x_ray_abstract.dart';
import 'package:flutter/material.dart';

class Line extends Shape {
  @override
  void draw(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    canvas
      ..save()

      /// Translate the canvas to the center
      ..translate(cx, cy)

      /// Rotate the canvas by the specified angle
      ..rotate(rotation * pi / 180)
      // ..scale(1 / scaleFactor)

      /// Translate the canvas back to the original position
      ..translate(-cx, -cy)
      ..drawLine(startPosition, endPosition, Paint()..color = Colors.red)
      ..restore();
  }

  @override
  Handle getHandle() {
    // TODO: implement getHandle
    throw UnimplementedError();
  }

  @override
  void move(Offset position) {
    // TODO: implement move
  }

  @override
  void resize(Offset position) {
    // TODO: implement resize
  }

  @override
  void select() {
    // TODO: implement select
  }
}
