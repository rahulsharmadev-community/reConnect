import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logs/logs.dart';
import 'package:reConnect/utility/extensions.dart';
import 'package:shared/shared.dart';

class CameraScreen extends StatefulWidget {
  final bool forceOnlyOneClick;
  final void Function(List<(String, Uint8List)>) onPreview;
  final VoidCallback onPop;
  const CameraScreen({
    super.key,
    required this.onPreview,
    required this.onPop,
    this.forceOnlyOneClick = false,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final imageFiles = <XFile>[];
  late final CameraController cameraController;
  late int currentCameraIndex = 0;
  bool isMultiImage = false;
  bool isControllerDefine = false;
  List<CameraDescription> cameras = [];
  double minAvailableZoom = 1.0;
  double maxAvailableZoom = 1.0;
  double currentScale = 1.0;
  FlashMode currentFlashMode = FlashMode.auto;
  double baseScale = 1.0;
  int pointers = 0;
  ValueNotifier<bool> isTakingPicture = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        logs.error('No camera found.');
      } else {
        initializecontroller(cameras.first);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (isControllerDefine || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initializecontroller(cameraController.description);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget cameraPreviewWidget() {
    if (!cameraController.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => pointers++,
        onPointerUp: (_) => pointers--,
        child: CameraPreview(
          cameraController,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: (_) => baseScale = currentScale,
              onScaleUpdate: scaleUpdate,
              onTapDown: (TapDownDetails details) =>
                  setFousPoint(details, constraints),
            );
          }),
        ),
      );
    }
  }

  /// Display the thumbnail of the captured image or video.
  Widget thumbnailWidget() {
    return buttonGestureDetector(
        imageFiles.isEmpty
            ? null
            : Badge(
                backgroundColor: context.theme.colorScheme.primary,
                textColor: context.theme.colorScheme.onPrimary,
                label: Text(imageFiles.length.toString()),
                child: Container(
                    width: 46,
                    height: 56,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(6)),
                    clipBehavior: Clip.hardEdge,
                    child: Image.file(
                      File((imageFiles.last).path),
                      fit: BoxFit.cover,
                    )),
              ),
        onDone);
  }

  Widget buttonGestureDetector(Widget? child, VoidCallback? onTap) =>
      GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 72,
          height: 72,
          child: Center(child: child),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (!isControllerDefine) return const SizedBox();
    return WillPopScope(
      onWillPop: () async {
        widget.onPop();
        return false;
      },
      child: SafeArea(
        child: Material(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    cameraPreviewWidget(),
                    Positioned(
                      left: 8,
                      top: 8,
                      child: FloatingActionButton.small(
                        shape: context.decoration.roundedBorder(100),
                        backgroundColor: Colors.black54,
                        child: const Icon(Icons.close_rounded),
                        onPressed: () async => widget.onPop(),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: FloatingActionButton.small(
                        shape: context.decoration.roundedBorder(100),
                        backgroundColor: Colors.black54,
                        onPressed: toggleCamera,
                        child: const Icon(Icons.flip_camera_android),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButton<FlashMode>(
                              enableFeedback: true,
                              isDense: true,
                              iconEnabledColor: Colors.amber,
                              underline: const SizedBox(),
                              value: currentFlashMode,
                              items: flashDropdownItems,
                              onChanged: (_) {
                                setFlashMode(_!);
                                setState(() {});
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: kToolbarHeight * 3,
                color: Colors.black87,
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!widget.forceOnlyOneClick)
                          buttonGestureDetector(
                            Icon(Icons.add_to_photos,
                                color: isMultiImage
                                    ? context.theme.colorScheme.primary
                                    : Colors.white),
                            () => setState(() => isMultiImage = !isMultiImage),
                          ),
                        ValueListenableBuilder(
                            valueListenable: isTakingPicture,
                            builder: (context, hasProcessing, child) =>
                                buttonGestureDetector(
                                  !hasProcessing
                                      ? const Icon(Icons.circle, size: 56)
                                      : const CircularProgressIndicator(),
                                  hasProcessing
                                      ? null
                                      : () async {
                                          final xfile = await takePicture();
                                          if (xfile != null) {
                                            imageFiles.add(xfile);
                                            if (imageFiles.length > 1) {
                                              isMultiImage = true;
                                            }
                                            if (mounted) setState(() {});
                                          }
                                          if (!isMultiImage) await onDone();
                                        },
                                )),
                        thumbnailWidget()
                      ],
                    ),
                    if (imageFiles.isNotEmpty)
                      OutlinedButton(
                        onPressed: onDone,
                        child: const Text(
                          'Preview',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onDone() async {
    var images = await compute(
        (files) => Future.wait(files.map(
            (e) async => (FilesFormat(e.name).ext, await e.readAsBytes()))),
        imageFiles);
    widget.onPreview(images);
  }

  List<DropdownMenuItem<FlashMode>> flashDropdownItems = [
    (FlashMode.auto, Icons.flash_auto),
    (FlashMode.always, Icons.flash_on),
    (FlashMode.off, Icons.flash_off),
    (FlashMode.torch, Icons.flashlight_on)
  ]
      .map((e) => DropdownMenuItem<FlashMode>(value: e.$1, child: Icon(e.$2)))
      .toList();

  Future<void> initializecontroller(CameraDescription cameraDescription) async {
    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    isControllerDefine = true;
    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        logs.error('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        cameraController
            .getMaxZoomLevel()
            .then((double value) => maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((double value) => minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      logs.error(e.description ?? 'Camera exception');
    }
  }

  void setFousPoint(TapDownDetails details, BoxConstraints constraints) {
    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setFocusPoint(offset);
  }

  Future<XFile?> takePicture() async {
    if (!cameraController.value.isInitialized) {
      logs.error('Error: select a camera first.');
      return null;
    }
    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      isTakingPicture.value = true;
      final XFile file = await cameraController.takePicture();
      isTakingPicture.value = false;
      return file;
    } on CameraException catch (e) {
      logs.error(e);
      return null;
    }
  }

  /// Handles scale update for zoom functionality.
  Future<void> scaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (pointers != 2) return;

    currentScale =
        (baseScale * details.scale).clamp(minAvailableZoom, maxAvailableZoom);
    await cameraController.setZoomLevel(currentScale);
  }

  /// Sets the flash mode of the camera.\
  /// The possible flash modes that can be set for a camera\
  /// ⇨ off, auto, always, torch
  Future<void> setFlashMode(FlashMode mode) async {
    await cameraController.setFlashMode(mode);
    currentFlashMode = mode;
  }

  /// Toggles between front and back cameras if available.
  Future<void> toggleCamera() async {
    if (cameras.length == 2) {
      currentCameraIndex = currentCameraIndex == 0 ? 1 : 0;
      await cameraController.setDescription(cameras[currentCameraIndex]);
    }
  }
}
