import 'dart:math';
import 'dart:ui' as ui;

import 'package:drongoai_x_ray_canvas/src/shapes/shape.dart';
import 'package:drongoai_x_ray_canvas/src/x_ray_abstract.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

/// {@template canvas_controller}
/// Canvas controller for the image viewer
/// {@endtemplate}
///
/// {@macro image_viewer}
///
/// To use this widget, you need to create an instance of `CanvasController`
/// and pass it to the `ImageViewer` widget. The `CanvasController` can be
/// obtained by calling the `CanvasController()` constructor.
///
/// Here's an example of how to use the `ImageViewer` widget:
///
///

class CanvasController extends ChangeNotifier {
  /// {@macro canvas_controller}
  CanvasController({
    required this.image,
  }) {
    imageSize = Size(image.width.toDouble(), image.height.toDouble());
  }

  ///image size
  Size _imageSize = Size.zero;

  /// Get the image size
  Size get imageSize => _imageSize;

  /// Set the image size
  set imageSize(Size value) {
    _imageSize = value;
    // notifyListeners();
  }

  /// The image to draw
  final ui.Image image;
  final TransformationController _transformationController =
      TransformationController();

  /// Get the transformation controller
  TransformationController get transformationController =>
      _transformationController;

  /// pan enabled
  bool _panEnabled = true;

  /// Get the pan enabled
  bool get panEnabled => _panEnabled;

  /// Set the pan enabled
  set panEnabled(bool value) {
    _panEnabled = value;
    notifyListeners();
  }

  ///container size
  Size _containerSize = Size.zero;

  /// Get the container size
  Size get containerSize => _containerSize;

  /// Set the container size
  set containerSize(Size value) {
    _containerSize = value;
    // notifyListeners();
  }

  /// Whether the image is painted
  bool isImagePainted = false;

  void Function(CanvasController)? onImagePainted;

  /// scale factor
  double _scaleFactor = 1.0;

  /// Get the scale factor
  double get scaleFactor => _scaleFactor;

  /// Set the scale factor
  set scaleFactor(double value) {
    _scaleFactor = value;
    notifyListeners();
  }

  /// Fit the image to the view port
  void fitImageToViewPort() {
    final parentSize = containerSize; // Replace with your parent size
    final imageSize = rotation == 90 || rotation == 270
        ? Size(image.height.toDouble(), image.width.toDouble())
        : Size(image.width.toDouble(), image.height.toDouble());
// Calculate the scale to fit the image
    final scale = _calculateScale(parentSize, imageSize);
    scaleFactor = scale;
    // Set the matrix to the TransformationController
    _transformationController.value = Matrix4.identity()
      ..translate(
        (containerSize.width - (imageSize.width * scale)) / 2,
        (containerSize.height - (imageSize.height * scale)) / 2,
      )
      ..scale(scale);
  }

  /// Fit the image to the view port
  void fitImageToViewPortAtCurrentScale() {
    final parentSize = containerSize; // Replace with your parent size
    final imageSize = rotation == 90 || rotation == 270
        ? Size(image.height.toDouble(), image.width.toDouble())
        : Size(image.width.toDouble(), image.height.toDouble());
// Calculate the scale to fit the image
    final scale = scaleFactor;

    // Set the matrix to the TransformationController
    _transformationController.value = Matrix4.identity()
      ..translate(
        (containerSize.width - (imageSize.width * scale)) / 2,
        (containerSize.height - (imageSize.height * scale)) / 2,
      )
      ..scale(scale);
  }

  double _calculateScale(Size parentSize, Size imageSize) {
    final scaleX = parentSize.width / imageSize.width;
    final scaleY = parentSize.height / imageSize.height;
    return scaleX < scaleY ? scaleX : scaleY;
  }

  /// Calculate the translation to center the image (not in use)
  Offset _calculateTranslation(
      Size parentSize, Size imageSize, double scale, double angle) {
    final radian = angle * pi / 180;
    final scaledImageWidth = imageSize.width * scale;
    final scaledImageHeight = imageSize.height * scale;

    // Calculate the bounding box of the rotated image
    final rotatedWidth = scaledImageWidth * cos(radian).abs() +
        scaledImageHeight * sin(radian).abs();
    final rotatedHeight = scaledImageHeight * cos(radian).abs() +
        scaledImageWidth * sin(radian).abs();

    final dx = (parentSize.width - rotatedWidth) / 2;
    final dy = (parentSize.height - rotatedHeight) / 2;

    return Offset(dx, dy);
  }

  double _rotation = 0;

  /// Get the rotation
  double get rotation => _rotation;

  set rotation(double value) {
    _rotation = value % 360;
    dev.log('rotation : ${value % 360}');

    imageSize = rotation == 0 || rotation == 180
        ? Size(image.width.toDouble(), image.height.toDouble())
        : Size(image.height.toDouble(), image.width.toDouble());

    notifyListeners();

    fitImageToViewPort();
  }

  ///----------------------------------------annotations---------------------------------------------
  List<Shape> _shapes = [];

  List<Shape> get shapes => _shapes;

  set shapes(List<Shape> value) {
    _shapes = value;
    notifyListeners();
  }

  /// add a shape
  void addShape(Shape shape) {
    _shapes.add(shape);
    notifyListeners();
  }

  ///tapDown
  void onTapDown(Offset position) {
    print('tapDown===> $position');

    addShape(Line()
      ..startPosition = position
      ..endPosition = position
      ..rotation = rotation
      ..scaleFactor = scaleFactor);
  }

  ///panUpdate
  void onPanUpdate(DragUpdateDetails details) {
    final shape = _shapes.last;

    shape.endPosition = details.localPosition;
    notifyListeners();
  }
}
