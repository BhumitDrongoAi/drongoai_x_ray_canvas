import 'dart:math';

import 'package:drongoai_x_ray_canvas/drongoai_x_ray_canvas.dart';
import 'package:drongoai_x_ray_canvas/src/x_ray_abstract.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// [CanvasPainter] is a custom painter.
///
class CanvasPainter extends CustomPainter {
  /// [CanvasPainter] is a custom painter.
  CanvasPainter({required this.canvasController}) : super();

  final CanvasController canvasController;
  @override
  void paint(Canvas canvas, Size size) {
    final image = canvasController.image;

    final srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: image.width.toDouble(),
        height: image.height.toDouble());
    final paint = Paint();
    final cx = size.width / 2;
    final cy = size.height / 2;
    //

    // Save the current canvas state
    canvas
      ..save()

      /// Translate the canvas to the center
      ..translate(cx, cy)

      /// Rotate the canvas by the specified angle
      ..rotate(canvasController.rotation * pi / 180)
      ..scale(canvasController.xFlip ? -1 : 1, canvasController.yFlip ? -1 : 1)

      /// Translate the canvas back to the original position
      ..translate(-cx, -cy)

      /// Define the source and destination rectangles
      ..drawImageRect(image, srcRect, dstRect, paint)

      /// Restore the canvas state
      ..restore()

      /// Draw a black rectangle
      ..drawRect(Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
          Paint()..color = Colors.black.withOpacity(0.2));

    for (final shape in canvasController.shapes) {
      ///rotation for the shape

      shape.draw(canvas, size, Paint()..color = canvasController.paintColor);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
