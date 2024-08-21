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
    //  canvas
    //     ..drawRect(
    //       Rect.fromCenter(
    //         center: start,
    //         width: 15 / info.scaleFactor,
    //         height: 15 / info.scaleFactor,
    //       ),
    //       Paint()
    //         ..style = PaintingStyle.stroke
    //         ..color = Colors.red,
    //     );

    handles
      ..clear()
      ..addAll([
        Handle()
          ..position = start
          ..type = HandleType.start
          ..size = 15 / info.scaleFactor,
        Handle()
          ..position = end
          ..type = HandleType.end
          ..size = 15 / info.scaleFactor,
      ]);

    if (selected) {
      for (final handle in handles) {
        canvas.drawRect(
          Rect.fromCenter(
            center: handle.position,
            width: handle.size,
            height: handle.size,
          ),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red,
        );
      }
    }

    // canvas.restore();
  }

  @override
  Handle? getHandle(Offset position, CurrentCanvasStateInfo info) {
    final _position = transformToOriginalCoordinateSystem(
      position,
      info.rotation * pi / 180,
      info.flip.xFlip,
      info.flip.yFlip,
      rectSize,
    ).transformToDifferentCoordinateSystem(
      info.rotation,
      offsetDif,
      (flipX: info.flip.xFlip, flipY: info.flip.yFlip),
    );

    for (final handle in handles) {
      if (Rect.fromCenter(
              center: handle.position, width: handle.size, height: handle.size)
          .contains(_position)) {
        return handle;
      }

      // if ((handle.position - _position).distance <= handle.size) {
      //   return handle;
      // }
    }

    return null;
  }

  @override
  void select(Offset position, CurrentCanvasStateInfo info) {
    final _position = transformToOriginalCoordinateSystem(
      position,
      info.rotation * pi / 180,
      info.flip.xFlip,
      info.flip.yFlip,
      rectSize,
    ).transformToDifferentCoordinateSystem(
      info.rotation,
      offsetDif,
      (flipX: info.flip.xFlip, flipY: info.flip.yFlip),
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
      Offset point,
      Offset start,
      Offset end,
    ) {
      final dx = end.dx - start.dx;
      final dy = end.dy - start.dy;
      final lengthSquared = dx * dx + dy * dy;
      var t = ((point.dx - start.dx) * dx + (point.dy - start.dy) * dy) /
          lengthSquared;
      t = t.clamp(0.0, 1.0);
      final projection = Offset(start.dx + t * dx, start.dy + t * dy);
      return (point - projection).distance;
    }

    bool _isTapOnAnotation(
      Offset tap,
      Offset start,
      Offset end,
    ) {
      final tolerance = kDefaulTollerance;
      final distance = _distanceFromPointToLineSegment(tap, start, end);

      return distance <= tolerance;
    }

    selected = _isTapOnAnotation(
      _position,
      start,
      end,
    );
  }

  @override
  void move(Offset position, CurrentCanvasStateInfo info) {
    // TODO: implement move
  }

  @override
  void resize(Offset position, CurrentCanvasStateInfo info, HandleType type) {
    final _position = transformToOriginalCoordinateSystem(
      position,
      info.rotation * pi / 180,
      info.flip.xFlip,
      info.flip.yFlip,
      rectSize,
    ).transformToDifferentCoordinateSystem(
      info.rotation,
      offsetDif,
      (flipX: info.flip.xFlip, flipY: info.flip.yFlip),
    );

    print('$_position');
    switch (type) {
      case HandleType.start:
        startPosition = _position;
        return;
      case HandleType.end:
        endPosition = _position;
        return;
      case HandleType.none:
      // TODO: Handle this case.
      case HandleType.topLeft:
      // TODO: Handle this case.
      case HandleType.topRight:
      // TODO: Handle this case.
      case HandleType.bottomLeft:
      // TODO: Handle this case.
      case HandleType.bottomRight:
      // TODO: Handle this case.
    }
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
    rectSize = rect.size;
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
      rotation,
      offsetDif,
      (flipX: xFlip, flipY: yFlip),
    );
    final end = transformToOriginalCoordinateSystem(
      endPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rect.size,
    ).transformToDifferentCoordinateSystem(
      rotation,
      offsetDif,
      (flipX: xFlip, flipY: yFlip),
    );

// flutter: dxogg 276.0    start Offset(1347.3, 1400.0) end Offset(947.1, 977.8)  === statpos Offset(1652.0, 1347.3)

    canvas.drawRect(
      Rect.fromPoints(start, end),
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10,
    );

    if (selected) {
      canvas
        ..drawRect(
          Rect.fromCenter(
            center: start,
            width: 15 / info.scaleFactor,
            height: 15 / info.scaleFactor,
          ),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red,
        )
        ..drawRect(
          Rect.fromCenter(
            center: end,
            width: 15 / info.scaleFactor,
            height: 15 / info.scaleFactor,
          ),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red,
        )
        ..drawRect(
          Rect.fromCenter(
            center: Offset(start.dx, end.dy),
            width: 15 / info.scaleFactor,
            height: 15 / info.scaleFactor,
          ),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red,
        )
        ..drawRect(
          Rect.fromCenter(
            center: Offset(end.dx, start.dy),
            width: 15 / info.scaleFactor,
            height: 15 / info.scaleFactor,
          ),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red,
        );
    }
  }

  @override
  Handle? getHandle(Offset position, CurrentCanvasStateInfo info) {
    throw UnimplementedError();
  }

  @override
  void select(Offset position, CurrentCanvasStateInfo info) {
    bool _isTapOnRectBorder(Offset tap, Rect rect) {
      final tolerance = kDefaulTollerance;
      final isNearLeftBorder = (tap.dx - rect.left).abs() <= tolerance &&
          tap.dy >= rect.top &&
          tap.dy <= rect.bottom;
      final isNearRightBorder = (tap.dx - rect.right).abs() <= tolerance &&
          tap.dy >= rect.top &&
          tap.dy <= rect.bottom;
      final isNearTopBorder = (tap.dy - rect.top).abs() <= tolerance &&
          tap.dx >= rect.left &&
          tap.dx <= rect.right;
      final isNearBottomBorder = (tap.dy - rect.bottom).abs() <= tolerance &&
          tap.dx >= rect.left &&
          tap.dx <= rect.right;

      return isNearLeftBorder ||
          isNearRightBorder ||
          isNearTopBorder ||
          isNearBottomBorder;
    }

    final _position = transformToOriginalCoordinateSystem(
      position,
      info.rotation * pi / 180,
      info.flip.xFlip,
      info.flip.yFlip,
      rectSize,
    ).transformToDifferentCoordinateSystem(
      info.rotation,
      offsetDif,
      (flipX: info.flip.xFlip, flipY: info.flip.yFlip),
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

    selected = _isTapOnRectBorder(_position, Rect.fromPoints(start, end));
  }

  @override
  void move(Offset position, CurrentCanvasStateInfo info) {
    // TODO: implement move
  }

  @override
  void resize(Offset position, CurrentCanvasStateInfo info, HandleType type) {
    // TODO: implement resize
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
    rectSize = rect.size;
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
      rotation,
      offsetDif,
      (flipX: xFlip, flipY: yFlip),
    );
    final end = transformToOriginalCoordinateSystem(
      endPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rect.size,
    ).transformToDifferentCoordinateSystem(
      rotation,
      offsetDif,
      (flipX: xFlip, flipY: yFlip),
    );

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
      canvas
        ..drawRect(
          Rect.fromCenter(
            center: start,
            width: 15 / info.scaleFactor,
            height: 15 / info.scaleFactor,
          ),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red,
        )
        ..drawRect(
          Rect.fromCenter(
            center: end,
            width: 15 / info.scaleFactor,
            height: 15 / info.scaleFactor,
          ),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red,
        );
    }
  }

  @override
  Handle? getHandle(Offset position, CurrentCanvasStateInfo info) {
    throw UnimplementedError();
  }

  @override
  void select(Offset position, CurrentCanvasStateInfo info) {
    bool _isTapOnCircleBorder(Offset tap, Offset center, double radius) {
      final tolerance = kDefaulTollerance;
      final distanceFromCenter = (tap - center).distance;
      return (distanceFromCenter - radius).abs() <= tolerance;
    }

    final _position = transformToOriginalCoordinateSystem(
      position,
      info.rotation * pi / 180,
      info.flip.xFlip,
      info.flip.yFlip,
      rectSize,
    ).transformToDifferentCoordinateSystem(
      info.rotation,
      offsetDif,
      (flipX: info.flip.xFlip, flipY: info.flip.yFlip),
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

  @override
  void move(Offset position, CurrentCanvasStateInfo info) {
    // TODO: implement move
  }

  @override
  void resize(Offset position, CurrentCanvasStateInfo info, HandleType type) {
    // TODO: implement resize
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
      rotation,
      offsetDif,
      (flipX: xFlip, flipY: yFlip),
    );

    final end = transformToOriginalCoordinateSystem(
      endPosition,
      rotation * pi / 180,
      xFlip,
      yFlip,
      rect.size,
    ).transformToDifferentCoordinateSystem(
      rotation,
      offsetDif,
      (flipX: xFlip, flipY: yFlip),
    );
  }

  @override
  Handle? getHandle(Offset position, CurrentCanvasStateInfo info) {
    // TODO: implement getHandle
    throw UnimplementedError();
  }

  @override
  void select(Offset position, CurrentCanvasStateInfo info) {
    // TODO: implement select
  }

  @override
  void move(Offset position, CurrentCanvasStateInfo info) {
    // TODO: implement move
  }

  @override
  void resize(Offset position, CurrentCanvasStateInfo info, HandleType type) {
    // TODO: implement resize
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
