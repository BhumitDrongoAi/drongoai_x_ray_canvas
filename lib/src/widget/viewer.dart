import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:drongoai_x_ray_canvas/drongoai_x_ray_canvas.dart';
import 'package:drongoai_x_ray_canvas/src/controller/canvas_controller.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;

/// A widget that displays an image with zoom and pan capabilities.
///
/// This widget is a wrapper around the Flutter `InteractiveViewer` widget.
/// It accepts a `CanvasController` as a parameter, which is used to
/// provide the image to be displayed.
///
/// To use this widget, you need to create an instance of `CanvasController`
/// and pass it to the `ImageViewer` widget. The `CanvasController` can be
/// obtained by calling the `CanvasController()` constructor.
///
/// Here's an example of how to use the `ImageViewer` widget:
///
///
class ImageViewer extends StatefulWidget {
  /// {@macro image_viewer}
  const ImageViewer({super.key, required this.canvasController});

  ///  Canvas controller for the image viewer
  final CanvasController canvasController;

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  void initState() {
    super.initState();

    widget.canvasController.transformationController.addListener(() {
      widget.canvasController.scaleFactor = widget
          .canvasController.transformationController.value
          .getMaxScaleOnAxis();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        widget.canvasController.containerSize = constraints.biggest;
        return ChangeNotifierProvider.value(
          value: widget.canvasController,
          child: Consumer<CanvasController>(
            builder: (context, controller, _) {
              if (controller.onImagePainted == null) {}
              return InteractiveViewer(
                minScale: 0.05,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                maxScale: 5,
                constrained: false,
                // alignment: Alignment.center,
                panEnabled: controller.panEnabled,
                transformationController: controller.transformationController,
                scaleFactor: 50 * 50,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    controller.onPanUpdate(details);
                  },
                  onTapDown: (details) {
                    controller.onTapDown(details.localPosition);
                  },
                  onPanStart: (details) {
                    controller.onPanStart(details);
                  },
                  onPanEnd: (details) {
                    controller.onPanEnd(details);
                  },
                  child: CustomPaint(
                    // size: Size(controller.image.width.toDouble(),
                    //     controller.image.height.toDouble()),
                    size: controller.imageSize,
                    painter: CanvasPainter(canvasController: controller),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
