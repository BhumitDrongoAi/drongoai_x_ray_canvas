import 'dart:ui';

import 'package:drongoai_x_ray_canvas/src/helper/typedefs.dart';

abstract class ImageCanvas {}

abstract class Shape {
  void draw(
    Canvas canvas,
    Size size,
    Paint paint,
    Rect rect,
    CurrentCanvasStateInfo info,
  );

  ///start position
  Offset startPosition = Offset.zero;

  ///end position
  Offset endPosition = Offset.zero;

  /// Get the handle for the shape
  Handle getHandle();

  /// is the shape selected
  bool selected = false;

  ///select the shape
  void select(Offset position);

  ///resize the shape
  void resize(Offset position);

  ///move the shape
  void move(Offset position);

  ///canvas rotation
  double rotation = 0.0;

  /// scale factor
  double scaleFactor = 1.0;

  ///xFlip
  bool xFlip = false;

  ///yFlip
  bool yFlip = false;

  /// is crop shape
  bool crop = false;

  ///image size
  Size imageSize = Size.zero;

  /// offset difference
  double offsetDif = 0.0;

  ///rect size
  Size rectSize = Size.zero;

  ///toJson
  Map<String, dynamic> toJson() {
    return {
      'startPosition': startPosition,
      'endPosition': endPosition,
      'selected': selected,
      'rotation': rotation,
      'scaleFactor': scaleFactor,
      'xFlip': xFlip,
      'yFlip': yFlip,
      'crop': crop,
      'imageSize': imageSize,
      'offsetDif': offsetDif,
    };
  }

  ///fromJson
}

class Handle {
  Offset position = Offset.zero;

  double size = 60.0;

  void draw(Canvas canvas, Size size) {}

  void select() {}

  void move(Offset position) {}

  void resize(Offset position) {}
}
