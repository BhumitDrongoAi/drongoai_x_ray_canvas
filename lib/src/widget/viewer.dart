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

    widget.canvasController.addListener(() {
      // print(
      //     'image_viewer===> ${widget.canvasController.transformationController}');
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
                  onTap: () async {
                    Future<void> saveImage(ByteData byteData) async {
                      final buffer = byteData.buffer.asUint8List();

                      // Get the directory to save the image
                      final directory =
                          await getApplicationDocumentsDirectory();
                      final path = '${directory.path}/custom_painter_image.png';

                      // Save the file
                      final file = File(path);
                      await file.writeAsBytes(buffer);
                      print('Image saved to $path');
                    }

                    ui.PictureRecorder recorder = ui.PictureRecorder();
                    Canvas canvas = Canvas(
                        recorder,
                        Rect.fromPoints(
                            Offset(0, 0),
                            Offset(controller.imageSize.width,
                                controller.imageSize.height)));

                    final painter = CanvasPainter(canvasController: controller);
                    painter.paint(
                        canvas,
                        Size(controller.imageSize.width,
                            controller.imageSize.height));
                    ui.Picture picture = recorder.endRecording();
                    ui.Image image = await picture.toImage(
                        controller.imageSize.width.toInt(),
                        controller.imageSize.height
                            .toInt()); // Specify the width and height
                    ByteData? byteData = await image.toByteData(
                        format: ui.ImageByteFormat.rawExtendedRgba128);
                    if (byteData != null) {
                      img.Image imgImage = img.Image.fromBytes(
                        width: controller.imageSize.width.toInt(),
                        height: controller.imageSize.height.toInt(),
                        bytes: byteData.buffer,
                        format: img.Format
                            .uint8, // This reads as an 8-bit image, we'll convert it next
                      );

                      // Step 5: Convert the img.Image to 16-bit per channel
                      // img.Image img16Bit = img.Image.from(
                      //   imgImage,
                      // );

                      // // Example: Adjust the image to use 16-bit per channel (scaling pixel values)
                      // for (int y = 0; y < img16Bit.height / 2; y++) {
                      //   for (int x = 0; x < img16Bit.width / 2; x++) {
                      //     final pixel = img16Bit.getPixel(x, y);
                      //     num red = pixel.getChannel(img.Channel.red);
                      //     num green = pixel.getChannel(img.Channel.green);
                      //     num blue = pixel.getChannel(img.Channel.blue);
                      //     num alpha = pixel.getChannel(img.Channel.alpha);
                      //     img16Bit.setPixelRgba(x, y, red, green, blue, alpha);
                      //   }
                      // }
                      Future<void> _saveImage(img.Image image) async {
                        final directory =
                            await getApplicationDocumentsDirectory();
                        final path =
                            '${directory.path}/custom_painter_image_16bit.tiff';
                        final path2 =
                            '${directory.path}/custom_painter_image_16bit.tiff';
                        File(path).writeAsBytesSync(img.encodeTiff(image));
                        await img.encodeTiffFile(path2, image);
                        print('Image saved to $path');
                      }

                      // Step 6: Save the image as PNG
                      await _saveImage(imgImage);
                      // Step 4: Convert the image to ByteData
                      // ByteData? byteData = await image.toByteData(
                      //     format: ui.ImageByteFormat.rawExtendedRgba128);

                      // if (byteData != null) {
                      //   // Step 5: Save the image
                      //   saveImage(byteData);
                      //   showBottomSheet(
                      //       context: context,
                      //       builder: (_) {
                      //         return Image.memory(byteData.buffer.asUint8List());
                      //       });
                      // }
                    }
                  },
                  onPanUpdate: (details) {
                    controller.onPanUpdate(details);
                  },
                  onTapDown: (details) {
                    // controller.onTapDown(details.localPosition);
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
