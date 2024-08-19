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
    ui.PictureRecorder recorder = ui.PictureRecorder();
    final image = canvasController.image;

    final srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: image.width.toDouble(),
      height: image.height.toDouble(),
    );
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
      ..drawImageRect(image, srcRect, dstRect, paint);

    /// Restore the canvas state
    ///

    /// Draw a black rectangle
    canvas.drawRect(dstRect, Paint()..color = Colors.white.withOpacity(0.3));

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 20,
        paint..color = Colors.white);

    for (final shape in canvasController.shapes) {
      canvas.save();

      canvas.translate(dstRect.topLeft.dx, dstRect.topLeft.dy);

      shape.draw(
          canvas,
          dstRect.size,
          Paint()..color = canvasController.paintColor,
          canvasController.rotation,
          dstRect);
      canvas.translate(-dstRect.topLeft.dx, -dstRect.topLeft.dy);

      canvas.restore();
    }
    // Restore the canvas state

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
