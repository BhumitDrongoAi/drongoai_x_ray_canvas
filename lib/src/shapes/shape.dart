import 'dart:math';
import 'dart:ui';

import 'package:drongoai_x_ray_canvas/src/x_ray_abstract.dart';
import 'package:flutter/material.dart';

class Line extends Shape {
  @override
  void draw(Canvas canvas, Size size, Paint paint, double currentRotation) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    canvas
      ..save()

      /// Translate the canvas to the center
      ..translate(cx, cy)

      /// Rotate the canvas by the specified angle
      // ..rotate(0 * pi / 180)
      // ..scale(1 / scaleFactor)

      /// Translate the canvas back to the original position
      ..translate(-cx, -cy)
      ..drawLine(startPosition, endPosition, paint)
      ..restore();
  }

  @override
  Handle getHandle() {
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
  void select() {}
}

class Rectangle extends Shape {
  @override
  void draw(Canvas canvas, Size size, Paint paint, double currentRotation) {
    canvas.drawRect(
      Rect.fromPoints(startPosition, endPosition),
      paint..style = PaintingStyle.stroke,
    );
  }

  @override
  Handle getHandle() {
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

class Circle extends Shape {
  @override
  void draw(Canvas canvas, Size size, Paint paint, double currentRotation) {
    final radius = (startPosition - endPosition).distance / 2;
    final center = Offset(
      (startPosition.dx + endPosition.dx) / 2,
      (startPosition.dy + endPosition.dy) / 2,
    );
    canvas.drawCircle(
      center,
      radius,
      paint..style = PaintingStyle.stroke,
    );
  }

  @override
  Handle getHandle() {
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

Offset _transformOffset(
    Offset offset, bool xFlip, bool yFlip, double rotationAngle, Size image) {
  // Apply flip transformations
  double x = xFlip ? image.width - offset.dx : offset.dx;
  double y = yFlip ? image.height - offset.dy : offset.dy;
  Offset flippedOffset = Offset(x, y);

  // Apply rotation transformation
  return _rotateOffset(
      flippedOffset, rotationAngle, Offset(image.width / 2, image.height / 2));
}

Offset _rotateOffset(Offset offset, double angle, Offset center) {
  double rad = angle;
  double cosRad = cos(rad);
  double sinRad = sin(rad);
  double dx = offset.dx - center.dx;
  double dy = offset.dy - center.dy;

  return Offset(
    dx * cosRad - dy * sinRad + center.dx,
    dx * sinRad + dy * cosRad + center.dy,
  );
}
