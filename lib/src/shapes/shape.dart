import 'dart:math';
import 'dart:ui';

import 'package:drongoai_x_ray_canvas/src/helper/rotation_offset.dart';
import 'package:drongoai_x_ray_canvas/src/helper/typedefs.dart';
import 'package:drongoai_x_ray_canvas/src/x_ray_abstract.dart';
import 'package:flutter/material.dart';

double kDefaulTollerance = 30.0;

class Line extends Shape {
  @override
  void draw(
    Canvas canvas,
    Size size,
    Paint paint,
    Rect rect,
    CurrentCanvasStateInfo info,
  ) {
    final _offsetDif = rect.topLeft.dx.abs();
    rectSize = rect.size;
    if (_offsetDif > 0) {
      offsetDif = _offsetDif;
    }
    final start = transformToOriginalCoordinateSystem(
      startPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rectSize,
    ).transformToDifferentCoordinateSystem(
      rotation,
      offsetDif,
      (flipX: xFlip, flipY: yFlip),
    );
    final end = transformToOriginalCoordinateSystem(
      endPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rectSize,
    ).transformToDifferentCoordinateSystem(
      rotation,
      offsetDif,
      (flipX: xFlip, flipY: yFlip),
    );

// flutter: dxogg 276.0    start Offset(1347.3, 1400.0) end Offset(947.1, 977.8)  === statpos Offset(1652.0, 1347.3)

    canvas.drawLine(start, end, paint..color = Colors.yellow);

    if (selected) {
      canvas.drawRect(
          Rect.fromCenter(
              center: start,
              width: 15 / info.scaleFactor,
              height: 15 / info.scaleFactor),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red);
      canvas.drawRect(
          Rect.fromCenter(
              center: end,
              width: 15 / info.scaleFactor,
              height: 15 / info.scaleFactor),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red);
    }

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
  void select(Offset position) {
    final _position = transformToOriginalCoordinateSystem(
      position,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rectSize,
    ).transformToDifferentCoordinateSystem(
      rotation,
      offsetDif,
      (flipX: xFlip, flipY: yFlip),
    );

    final start = transformToOriginalCoordinateSystem(
      startPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rectSize,
    ).transformToDifferentCoordinateSystem(
      rotation,
      offsetDif,
      (flipX: xFlip, flipY: yFlip),
    );
    final end = transformToOriginalCoordinateSystem(
      endPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rectSize,
    ).transformToDifferentCoordinateSystem(
      rotation,
      offsetDif,
      (flipX: xFlip, flipY: yFlip),
    );

    ///select line shape if postion is between start and end offset and if postion and shape coordinates diffrence is less than 60
    double _distanceFromPointToLineSegment(
        Offset point, Offset start, Offset end) {
      double dx = end.dx - start.dx;
      double dy = end.dy - start.dy;
      double lengthSquared = dx * dx + dy * dy;
      double t = ((point.dx - start.dx) * dx + (point.dy - start.dy) * dy) /
          lengthSquared;
      t = t.clamp(0.0, 1.0);
      Offset projection = Offset(start.dx + t * dx, start.dy + t * dy);
      return (point - projection).distance;
    }

    bool _isTapOnAnotation(
      Offset tap,
      Offset start,
      Offset end,
    ) {
      double tolerance = kDefaulTollerance;
      double distance = _distanceFromPointToLineSegment(tap, start, end);

      return distance <= tolerance;
    }

    selected = _isTapOnAnotation(
      _position,
      start,
      end,
    );
  }
}

class Rectangle extends Shape {
  @override
  void draw(
    Canvas canvas,
    Size size,
    Paint paint,
    Rect rect,
    CurrentCanvasStateInfo info,
  ) {
    final _offsetDif = rect.topLeft.dx.abs();

    if (_offsetDif > 0) {
      offsetDif = _offsetDif;
    }
    final start = transformToOriginalCoordinateSystem(
      startPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rect.size,
    ).transformToDifferentCoordinateSystem(
        rotation, offsetDif, (flipX: xFlip, flipY: yFlip));
    final end = transformToOriginalCoordinateSystem(
      endPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rect.size,
    ).transformToDifferentCoordinateSystem(
        rotation, offsetDif, (flipX: xFlip, flipY: yFlip));

// flutter: dxogg 276.0    start Offset(1347.3, 1400.0) end Offset(947.1, 977.8)  === statpos Offset(1652.0, 1347.3)

    canvas.drawRect(
      Rect.fromPoints(start, end),
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10,
    );

    if (selected) {
      canvas.drawRect(
          Rect.fromCenter(
              center: start,
              width: 15 / info.scaleFactor,
              height: 15 / info.scaleFactor),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red);
      canvas.drawRect(
          Rect.fromCenter(
              center: end,
              width: 15 / info.scaleFactor,
              height: 15 / info.scaleFactor),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red);
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(start.dx, end.dy),
              width: 15 / info.scaleFactor,
              height: 15 / info.scaleFactor),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red);

      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(end.dx, start.dy),
              width: 15 / info.scaleFactor,
              height: 15 / info.scaleFactor),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red);
    }
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
  void select(Offset position) {
    bool _isTapOnRectBorder(Offset tap, Rect rect) {
      double tolerance = kDefaulTollerance;
      bool isNearLeftBorder = (tap.dx - rect.left).abs() <= tolerance &&
          tap.dy >= rect.top &&
          tap.dy <= rect.bottom;
      bool isNearRightBorder = (tap.dx - rect.right).abs() <= tolerance &&
          tap.dy >= rect.top &&
          tap.dy <= rect.bottom;
      bool isNearTopBorder = (tap.dy - rect.top).abs() <= tolerance &&
          tap.dx >= rect.left &&
          tap.dx <= rect.right;
      bool isNearBottomBorder = (tap.dy - rect.bottom).abs() <= tolerance &&
          tap.dx >= rect.left &&
          tap.dx <= rect.right;

      return isNearLeftBorder ||
          isNearRightBorder ||
          isNearTopBorder ||
          isNearBottomBorder;
    }

    final _position = transformToOriginalCoordinateSystem(
      position,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rectSize,
    ).transformToDifferentCoordinateSystem(
      rotation,
      offsetDif,
      (flipX: xFlip, flipY: yFlip),
    );
    final start = transformToOriginalCoordinateSystem(
      startPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rectSize,
    ).transformToDifferentCoordinateSystem(
        rotation, offsetDif, (flipX: xFlip, flipY: yFlip));
    final end = transformToOriginalCoordinateSystem(
      endPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rectSize,
    ).transformToDifferentCoordinateSystem(
        rotation, offsetDif, (flipX: xFlip, flipY: yFlip));

    selected = _isTapOnRectBorder(position, Rect.fromPoints(start, end));
  }
}

class Circle extends Shape {
  @override
  void draw(
    Canvas canvas,
    Size size,
    Paint paint,
    Rect rect,
    CurrentCanvasStateInfo info,
  ) {
    final _offsetDif = rect.topLeft.dx.abs();

    if (_offsetDif > 0) {
      offsetDif = _offsetDif;
    }

    final start = transformToOriginalCoordinateSystem(
      startPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rect.size,
    ).transformToDifferentCoordinateSystem(
        rotation, offsetDif, (flipX: xFlip, flipY: yFlip));
    final end = transformToOriginalCoordinateSystem(
      endPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rect.size,
    ).transformToDifferentCoordinateSystem(
        rotation, offsetDif, (flipX: xFlip, flipY: yFlip));

// flutter: dxogg 276.0    start Offset(1347.3, 1400.0) end Offset(947.1, 977.8)  === statpos Offset(1652.0, 1347.3)
    final radius = (start - end).distance / 2;
    final center = Offset(
      (start.dx + end.dx) / 2,
      (start.dy + end.dy) / 2,
    );
    canvas.drawCircle(
      center,
      radius,
      paint..style = PaintingStyle.stroke,
    );

    if (selected) {
      canvas.drawRect(
          Rect.fromCenter(
              center: start,
              width: 15 / info.scaleFactor,
              height: 15 / info.scaleFactor),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red);
      canvas.drawRect(
          Rect.fromCenter(
              center: end,
              width: 15 / info.scaleFactor,
              height: 15 / info.scaleFactor),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red);
    }
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
  void select(Offset position) {
    bool _isTapOnCircleBorder(Offset tap, Offset center, double radius) {
      double tolerance = kDefaulTollerance;
      double distanceFromCenter = (tap - center).distance;
      return (distanceFromCenter - radius).abs() <= tolerance;
    }

    final _position = transformToOriginalCoordinateSystem(
      position,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rectSize,
    ).transformToDifferentCoordinateSystem(
      rotation,
      offsetDif,
      (flipX: xFlip, flipY: yFlip),
    );
    final start = transformToOriginalCoordinateSystem(
      startPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rectSize,
    ).transformToDifferentCoordinateSystem(
        rotation, offsetDif, (flipX: xFlip, flipY: yFlip));
    final end = transformToOriginalCoordinateSystem(
      endPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rectSize,
    ).transformToDifferentCoordinateSystem(
        rotation, offsetDif, (flipX: xFlip, flipY: yFlip));
    final radius = (start - end).distance / 2;
    final center = Offset(
      (start.dx + end.dx) / 2,
      (start.dy + end.dy) / 2,
    );
    selected = _isTapOnCircleBorder(
      _position,
      center,
      radius,
    );
    // TODO: implement select
  }
}

class Angle extends Shape {
  @override
  void draw(
    Canvas canvas,
    Size size,
    Paint paint,
    Rect rect,
    CurrentCanvasStateInfo info,
  ) {
    final _offsetDif = rect.topLeft.dx.abs();

    if (_offsetDif > 0) {
      offsetDif = _offsetDif;
    }

    final start = transformToOriginalCoordinateSystem(
      startPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rect.size,
    ).transformToDifferentCoordinateSystem(
        rotation, offsetDif, (flipX: xFlip, flipY: yFlip));

    final end = transformToOriginalCoordinateSystem(
      endPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rect.size,
    ).transformToDifferentCoordinateSystem(
        rotation, offsetDif, (flipX: xFlip, flipY: yFlip));
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
  void select(Offset position) {
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
  // Calculate the center of the image
  final center = Offset(imageSize.width / 2, imageSize.height / 2);

  // Translate the point to the origin
  final translatedPoint = point - center;

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
