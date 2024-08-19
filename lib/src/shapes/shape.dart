import 'dart:math';
import 'dart:ui';

import 'package:drongoai_x_ray_canvas/src/x_ray_abstract.dart';
import 'package:flutter/material.dart';

class Line extends Shape {
  @override
  void draw(Canvas canvas, Size size, Paint paint, double currentRotation,
      Rect rect) {
    final start = transformToOriginalCoordinateSystem(
      startPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rect.size,
    );
    final end = transformToOriginalCoordinateSystem(
      endPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rect.size,
    );

    print('start $start end $end   end  size ${rect.size}');
    // canvas.drawRect(
    //   Rect.fromLTRB(0, 0, size.width, size.height),
    //   paint..color = Colors.red.withOpacity(0.1),
    // );
    final offsetDif = rect.topLeft.dx.abs();
// flutter: dxogg 276.0    start Offset(1347.3, 1400.0) end Offset(947.1, 977.8)  === statpos Offset(1652.0, 1347.3)

    final _start = rotation == 0 || rotation == 180
        ? start
        : rotation == 90 || rotation == 270
            ? rotation == 90
                ? start + Offset(offsetDif, offsetDif)
                : start - Offset(offsetDif, offsetDif)
            : start;
    final _end = rotation == 0 || rotation == 180
        ? end
        : rotation == 90 || rotation == 270
            ? rotation == 90
                ? end + Offset(offsetDif, offsetDif)
                : end - Offset(offsetDif, offsetDif)
            : end;
    print(
        'dxogg $offsetDif    start $_start end $_end  === statpos ${startPosition}');
    canvas.drawCircle(
        rect.center - rect.topLeft, 20, Paint()..color = Colors.yellow);
    canvas.drawLine(_start, _end, paint..color = Colors.yellow);
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
  void draw(Canvas canvas, Size size, Paint paint, double currentRotation,
      Rect rect) {
    final start = transformToOriginalCoordinateSystem(
      startPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rect.size,
    );
    final end = transformToOriginalCoordinateSystem(
      endPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rect.size,
    );

    final offsetDif = rect.topLeft.dx.abs();
    // canvas.drawRect(
    //   Rect.fromLTRB(0, 0, size.width, size.height),
    //   paint..color = Colors.red.withOpacity(0.1),
    // );
    final _start = rotation == 0 || rotation == 180
        ? start
        : rotation == 90 || rotation == 270
            ? rotation == 90
                ? start + Offset(offsetDif, offsetDif)
                : start - Offset(offsetDif, offsetDif)
            : start;
    final _end = rotation == 0 || rotation == 180
        ? end
        : rotation == 90 || rotation == 270
            ? rotation == 90
                ? end + Offset(offsetDif, offsetDif)
                : end - Offset(offsetDif, offsetDif)
            : end;
    canvas.drawRect(
      Rect.fromPoints(_start, _end),
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10,
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
  void draw(Canvas canvas, Size size, Paint paint, double currentRotation,
      Rect rect) {
    final radius = (startPosition - endPosition).distance / 2;
    final start = transformToOriginalCoordinateSystem(
      startPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rect.size,
    );
    final end = transformToOriginalCoordinateSystem(
      endPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rect.size,
    );

    final offsetDif = rect.topLeft.dx.abs();
    // canvas.drawRect(
    //   Rect.fromLTRB(0, 0, size.width, size.height),
    //   paint..color = Colors.red.withOpacity(0.1),
    // );

    // (currentRotation == 0 || currentRotation == 180) &&
    //         (rotation == 90 || currentRotation == 270)
    //     ? rotation == 90
    //         ? start + Offset(offsetDif, offsetDif)
    //         : start - Offset(offsetDif, offsetDif)
    //     :

    final _start = rotation == 0 || rotation == 180
        ? start
        : rotation == 90 || rotation == 270
            ? rotation == 90
                ? start + Offset(offsetDif, offsetDif)
                : start - Offset(offsetDif, offsetDif)
            : start;
    final _end = rotation == 0 || rotation == 180
        ? end
        : rotation == 90 || rotation == 270
            ? rotation == 90
                ? end + Offset(offsetDif, offsetDif)
                : end - Offset(offsetDif, offsetDif)
            : end;
    final center = Offset(
      (_start.dx + _end.dx) / 2,
      (_start.dy + _end.dy) / 2,
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

class Angle extends Shape {
  @override
  void draw(Canvas canvas, Size size, Paint paint, double currentRotation,
      Rect rect) {
    // TODO: implement draw
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
  return (flippedPoint + center);
}
