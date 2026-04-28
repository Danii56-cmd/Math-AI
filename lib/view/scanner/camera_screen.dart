import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math_ai/core/app_colors.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;
  CameraController? controller;
  bool isFlashOn = false;
  bool isCapturing = false;
  String _statusText = "Align formula within the frame";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        controller = CameraController(
          cameras![0],
          ResolutionPreset.max,
          enableAudio: false,
        );
        await controller!.initialize();
        if (!mounted) return;
        setState(() => isCameraInitialized = true);
      } else {
        debugPrint("No cameras found");
      }
    } catch (e) {
      debugPrint("Camera Error: $e");
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _processImage(File imageFile, AppColors c) async {
    if (isCapturing) return;

    try {
      setState(() {
        isCapturing = true;
        _statusText = "Cropping...";
      });

      final File? croppedImage = await _cropImage(imageFile, c);
      if (croppedImage == null) {
        setState(() {
          isCapturing = false;
          _statusText = "Align formula within the frame";
        });
        return;
      }

      // ✅ Send image directly to Gemini Vision — no OCR, no MathCleaner
      setState(() => _statusText = "Solving...");

      if (!mounted) return;

      final navProvider = Provider.of<NavigationProvider>(
        context,
        listen: false,
      );

      // Pass the cropped image directly — Gemini reads it
      navProvider.setExpressionAndNavigate(
        "", // No pre-cleaned expression needed
        2,
        image: croppedImage,
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint("Process image error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: $e"),
          backgroundColor: c.bg,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isCapturing = false;
          _statusText = "Align formula within the frame";
        });
      }
    }
  }

  Future<File?> _cropImage(File imageFile, AppColors c) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Math Expression',
          toolbarColor: c.primary,
          toolbarWidgetColor: c.surface,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    if (!isCameraInitialized) {
      return Scaffold(
        backgroundColor: c.bg,
        body: Center(child: SpinKitCircle(color: c.primary)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox.expand(child: CameraPreview(controller!)),
          Container(color: Colors.black.withAlpha(80)),

          // Processing overlay
          if (isCapturing)
            Container(
              color: Colors.black.withAlpha(170),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpinKitCircle(color: c.primary, size: 60),
                    SizedBox(height: 16.h),
                    Text(
                      _statusText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                children: [
                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRoundButton(
                        Icons.close,
                        () => Navigator.pop(context),
                        c,
                      ),
                      _buildScannerTag(c),
                      _buildRoundButton(
                        isFlashOn ? Icons.flash_off : Icons.bolt,
                        () async {
                          setState(() => isFlashOn = !isFlashOn);
                          await controller!.setFlashMode(
                            isFlashOn ? FlashMode.torch : FlashMode.off,
                          );
                        },
                        c,
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Scanning frame
                  _buildScanningFrame(c),
                  SizedBox(height: 20.h),
                  Text(
                    _statusText,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),

                  const Spacer(),

                  // Bottom controls
                  Padding(
                    padding: EdgeInsets.only(bottom: 30.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildGalleryButton(c),
                        _buildShutterButton(c),
                        SizedBox(width: 60.w),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundButton(IconData icon, VoidCallback onTap, AppColors c) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: c.surface.withAlpha(60),
          shape: BoxShape.circle,
          border: Border.all(color: c.border.withAlpha(120)),
        ),
        child: Icon(
          icon,
          color: icon == Icons.bolt ? Colors.amber : Colors.white,
          size: 24.sp,
        ),
      ),
    );
  }

  Widget _buildScannerTag(AppColors c) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: c.surface.withAlpha(150),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: c.border),
      ),
      child: Text(
        "SCANNING MATH",
        style: TextStyle(
          color: c.primary,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildScanningFrame(AppColors c) {
    return SizedBox(
      width: 280.w,
      height: 200.h,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: _corner(top: true, left: true, c: c),
          ),
          Align(
            alignment: Alignment.topRight,
            child: _corner(top: true, left: false, c: c),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: _corner(top: false, left: true, c: c),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: _corner(top: false, left: false, c: c),
          ),
        ],
      ),
    );
  }

  Widget _corner({
    required bool top,
    required bool left,
    required AppColors c,
  }) {
    return Container(
      width: 45.w,
      height: 45.h,
      decoration: BoxDecoration(
        border: Border(
          top: top ? BorderSide(color: c.primary, width: 4.w) : BorderSide.none,
          bottom: !top
              ? BorderSide(color: c.primary, width: 4.w)
              : BorderSide.none,
          left: left
              ? BorderSide(color: c.primary, width: 4.w)
              : BorderSide.none,
          right: !left
              ? BorderSide(color: c.primary, width: 4.w)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: (top && left) ? Radius.circular(15.r) : Radius.zero,
          topRight: (top && !left) ? Radius.circular(15.r) : Radius.zero,
          bottomLeft: (!top && left) ? Radius.circular(15.r) : Radius.zero,
          bottomRight: (!top && !left) ? Radius.circular(15.r) : Radius.zero,
        ),
      ),
    );
  }

  Widget _buildGalleryButton(AppColors c) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: isCapturing
              ? null
              : () async {
                  final XFile? pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile == null) return;
                  await _processImage(File(pickedFile.path), c);
                },
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: c.surface.withAlpha(60),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: c.border.withAlpha(120)),
            ),
            child: const Icon(Icons.photo_library, color: Colors.white),
          ),
        ),
        SizedBox(height: 5.h),
        const Text(
          "GALLERY",
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildShutterButton(AppColors c) {
    return GestureDetector(
      onTap: isCapturing
          ? null
          : () async {
              if (controller == null || !controller!.value.isInitialized) {
                return;
              }
              final XFile file = await controller!.takePicture();
              await _processImage(File(file.path), c);
            },
      child: isCapturing
          ? const SpinKitCircle(color: Colors.white, size: 50)
          : Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Container(
                height: 60.r,
                width: 60.r,
                margin: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.document_scanner, color: c.primary),
              ),
            ),
    );
  }
}
