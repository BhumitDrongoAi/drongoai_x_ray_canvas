import 'dart:math';
import 'dart:ui';

import 'package:drongoai_x_ray_canvas/src/x_ray_abstract.dart';
import 'package:flutter/material.dart';

class Line extends Shape {
  @override
  void draw(Canvas canvas, Size size, Paint paint, double currentRotation) {
    final start = transformToOriginalCoordinateSystem(
      startPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      size,
    );
    final end = transformToOriginalCoordinateSystem(
      endPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      size,
    );

    print('start $start end $end');
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, size.height),
      paint..color = Colors.red.withOpacity(0.1),
    );
    canvas.drawLine(start, end, paint..color = Colors.yellow);
    // canvas.restore();
  }

  @override
  Handle getHandle() {
    throw UnimplementedError();
  }

  @override
  void move(Offset position) {}

  @override
  void resize(Offset position) {}

  @override
  void select() {}
}

class Rectangle extends Shape {
  @override
  void draw(Canvas canvas, Size size, Paint paint, double currentRotation) {
    final start = transformToOriginalCoordinateSystem(
      startPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      size,
    );
    final end = transformToOriginalCoordinateSystem(
      endPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      size,
    );
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
  void move(Offset position) {}

  @override
  void resize(Offset position) {}

  @override
  void select() {}
}

class Circle extends Shape {
  @override
  void draw(Canvas canvas, Size size, Paint paint, double currentRotation) {
    final radius = (startPosition - endPosition).distance / 2;
    final start = transformToOriginalCoordinateSystem(
      startPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      size,
    );
    final end = transformToOriginalCoordinateSystem(
      endPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      size,
    );
    final center = Offset(
      (start.dx + end.dx) / 2,
      (start.dy + end.dy) / 2,
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
  void move(Offset position) {}

  @override
  void resize(Offset position) {}

  @override
  void select() {}
}

Offset transformToOriginalCoordinateSystem(
  Offset point,
  double angle,
  bool flipX,
  bool flipY,
  Size imageSize,
) {
  print(
    'point: $point, angle: $angle, flipX: $flipX, flipY: $flipY, imageSize: $imageSize',
  );
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
