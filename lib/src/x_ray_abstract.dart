import 'dart:ui';

abstract class ImageCanvas {}

abstract class Shape {
  void draw(Canvas canvas, Size size);

  ///start position
  Offset startPosition = Offset.zero;

  ///end position
  Offset endPosition = Offset.zero;

  /// Get the handle for the shape
  Handle getHandle();

  /// is the shape selected
  bool selected = false;

  ///select the shape
  void select();

  ///resize the shape
  void resize(Offset position);

  ///move the shape
  void move(Offset position);

  ///canvas rotation
  double rotation = 0.0;

  /// scale factor
  double scaleFactor = 1.0;
}

class Handle {
  Offset position = Offset.zero;

  double size = 60.0;

  void draw(Canvas canvas, Size size) {}

  void select() {}

  void move(Offset position) {}

  void resize(Offset position) {}
}
