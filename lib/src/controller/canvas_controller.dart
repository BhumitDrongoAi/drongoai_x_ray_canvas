import 'dart:math';
import 'dart:ui' as ui;

import 'package:drongoai_x_ray_canvas/src/enum/shape_enum.dart';
import 'package:drongoai_x_ray_canvas/src/helper/typedefs.dart';
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

  ///CurrentCanvasStateInfo info
  CurrentCanvasStateInfo _currentCanvasStateInfo = CurrentCanvasStateInfo();

  /// Get the current canvas state info
  CurrentCanvasStateInfo get currentCanvasStateInfo => _currentCanvasStateInfo;

  /// Set the current canvas state info
  set currentCanvasStateInfo(CurrentCanvasStateInfo value) {
    _currentCanvasStateInfo = value;
  }

  ///xFlip
  bool _xFlip = false;

  /// Get the xFlip
  bool get xFlip => _xFlip;

  /// Set the xFlip
  set xFlip(bool value) {
    _xFlip = value;
    currentCanvasStateInfo.flip.xFlip = _xFlip;
    notifyListeners();
  }

  ///yFlip
  bool _yFlip = false;

  /// Get the yFlip
  bool get yFlip => _yFlip;

  /// Set the yFlip
  set yFlip(bool value) {
    _yFlip = value;
    currentCanvasStateInfo.flip.yFlip = _yFlip;
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
    currentCanvasStateInfo.scaleFactor = _scaleFactor;
    notifyListeners();
  }

  ///restore canvas
  void restoreCanvas() {
    fitImageToViewPort();
    _shapes.clear();
    _activeShape = ActiveShape.none;
    xFlip = false;
    yFlip = false;
    rotation = 0.0;
    notifyListeners();
  }

  /// Fit the image to the view port
  void fitImageToViewPort() {
    final parentSize = containerSize; // Replace with your parent size

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

    currentCanvasStateInfo.rotation = _rotation;
    notifyListeners();

    fitImageToViewPort();
  }

  ///----------------------------------------annotations---------------------------------------------

  Color _paintColor = Colors.red;

  Color get paintColor => _paintColor;

  set paintColor(Color value) {
    _paintColor = value;
    notifyListeners();
  }

  List<Shape> _shapes = [];

  List<Shape> get shapes => _shapes;

  set shapes(List<Shape> value) {
    _shapes = value;
    notifyListeners();
  }

  ActiveShape _activeShape = ActiveShape.none;

  /// Get the selected shape
  ActiveShape get activeShape => _activeShape;

  /// Set the selected shape
  set activeShape(ActiveShape value) {
    _activeShape = _activeShape == value ? ActiveShape.none : value;
    notifyListeners();
  }

  bool _isCrop = false;

  bool get isCrop => _isCrop;

  set isCrop(bool value) {
    _isCrop = value;
    notifyListeners();
  }

  /// add a shape
  void addShape(Shape shape) {
    _shapes.add(shape);
    notifyListeners();
  }

  ///tapDown
  void onTapDown(Offset position) {
    if (activeShape == ActiveShape.none) {
      final isAnyShapeSelected = _shapes.any((shape) => shape.selected);
      if (isAnyShapeSelected) {
        shapes = _shapes.map((shape) => shape..selected = false).toList();
        selectedShape = null;
        selectedHandleType = HandleType.none;
      }

      for (final shape in _shapes) {
        shape.select(position, currentCanvasStateInfo);

        if (shape.selected) {
          // notifyListeners();
          print('shape selected');

          print(
              'handle position : ${shape.getHandle(position, currentCanvasStateInfo)?.type}');
          selectedShape = shape;
          selectedHandleType =
              shape.getHandle(position, currentCanvasStateInfo)?.type ??
                  HandleType.none;
          break;
        }
      }
    }
  }

  HandleType _selectedHandleType = HandleType.none;

  HandleType get selectedHandleType => _selectedHandleType;

  set selectedHandleType(HandleType value) {
    _selectedHandleType = value;
    notifyListeners();
  }

  Shape? _selectedShape = null;

  Shape? get selectedShape => _selectedShape;

  set selectedShape(Shape? value) {
    _selectedShape = value;
    notifyListeners();
  }

  Offset _constrainToImage(Offset position, Size imageSize) {
    final double dx = position.dx.clamp(0.0, imageSize.width);
    final double dy = position.dy.clamp(0.0, imageSize.height);
    return Offset(dx, dy);
  }

  ///panUpdate
  void onPanUpdate(DragUpdateDetails details) {
    try {
      if (activeShape != ActiveShape.none) {
        final constrained = _constrainToImage(details.localPosition, imageSize);
        _shapes.last.endPosition = constrained;
      }

      print('activeShape : ${activeShape}');

      if (activeShape == ActiveShape.none &&
          selectedHandleType != HandleType.none &&
          selectedShape != null) {
        print('handle type : ${selectedHandleType}');
        final shape = selectedShape;
        if (shape != null) {
          final constrained =
              _constrainToImage(details.localPosition, imageSize);
          shape.resize(constrained, currentCanvasStateInfo, selectedHandleType);
        }
      }
      notifyListeners();
    } catch (e) {
      dev.log('error : $e');
    }
  }

  ///panEnd
  void onPanEnd(DragEndDetails details) {
    if (isCrop) {
      // fitImageToViewPortCroped();
      isCrop = false;
      activeShape = ActiveShape.none;
    }
    selectedHandleType = HandleType.none;
  }

  /// panStart
  void onPanStart(DragStartDetails details) {
    if (activeShape != ActiveShape.none) {
      final shape = getShape(activeShape: activeShape);

      print('imageSize: $imageSize');
      final constrained = _constrainToImage(details.localPosition, imageSize);
      // final position = transformToOriginalCoordinateSystem(
      //   constrained,
      //   rotation,
      //   xFlip,
      //   yFlip,
      //   imageSize,
      // );
      if (shape != null) {
        addShape(
          shape
            ..startPosition = constrained
            ..endPosition = constrained
            ..rotation = rotation
            ..xFlip = xFlip
            ..yFlip = yFlip
            ..crop = isCrop
            ..imageSize = imageSize
            ..scaleFactor = scaleFactor,
        );
      }
    }
  }

  /// Get the shape from the active shape
  Shape? getShape({ActiveShape? activeShape}) {
    switch (activeShape ?? this.activeShape) {
      case ActiveShape.none:
        return null;
      case ActiveShape.line:
        return Line();
      case ActiveShape.rectangle:
        return Rectangle();
      case ActiveShape.circle:
        return Circle();
      case ActiveShape.ellipse:
        throw UnimplementedError();
      case ActiveShape.angle:
        throw UnimplementedError();
    }
  }
}
