import 'dart:math';
import 'dart:ui';

import 'package:drongoai_x_ray_canvas/src/x_ray_abstract.dart';
import 'package:flutter/material.dart';

class Line extends Shape {
  @override
  void draw(
    Canvas canvas,
    Size size,
    Paint paint,
  ) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final start = transformToOriginalCoordinateSystem(
        startPosition, rotation, xFlip, yFlip, size);
    final end = transformToOriginalCoordinateSystem(
        endPosition, rotation, xFlip, yFlip, size);
    canvas
      ..save()

      /// Translate the canvas to the center
      ..translate(cx, cy)

      /// Rotate the canvas by the specified angle

      // ..scale(1 / scaleFactor)

      /// Translate the canvas back to the original position
      ..translate(-cx, -cy)
      ..drawLine(start, end, paint)
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
  void draw(Canvas canvas, Size size, Paint paint) {
    final start = transformToOriginalCoordinateSystem(
        startPosition, rotation, xFlip, yFlip, size);
    final end = transformToOriginalCoordinateSystem(
        endPosition, rotation, xFlip, yFlip, size);
    canvas.drawRect(
      Rect.fromPoints(start, end),
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

Offset transformToOriginalCoordinateSystem(
    Offset point, double angle, bool flipX, bool flipY, Size imageSize) {
  // Calculate the center of the image
  final center = Offset(imageSize.width / 2, imageSize.height / 2);

  // Translate the point to the origin
  var translatedPoint = point - center;

  // Apply the inverse rotation
  final rotatedPoint = Offset(
    translatedPoint.dx * cos(-angle) - translatedPoint.dy * sin(-angle),
    translatedPoint.dx * sin(-angle) + translatedPoint.dy * cos(-angle),
  );

  // Apply the inverse flip
  final flippedPoint = Offset(
    flipX ? -rotatedPoint.dx : rotatedPoint.dx,
    flipY ? -rotatedPoint.dy : rotatedPoint.dy,
  );

  // Translate the point back to the original position
  return flippedPoint + center;
}
