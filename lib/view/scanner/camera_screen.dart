import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math_ai/core/app_constants.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:math_ai/services/ocr_service.dart';
import 'package:math_ai/utills/math_cleaner.dart';
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
  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();

      if (cameras != null && cameras!.isNotEmpty) {
        // Use the first available camera (usually the back one)
        controller = CameraController(
          cameras![0],
          ResolutionPreset.high,
          enableAudio:
              false, // Set to false if you don't need audio to avoid extra permission hits
        );

        await controller!.initialize();

        if (!mounted) return;

        setState(() {
          isCameraInitialized = true;
        });
      } else {
        debugPrint("No cameras found");
      }
    } catch (e) {
      debugPrint("Camera Error: $e");
      // You might want to show a SnackBar here to tell the user what went wrong
    }
  }

  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  bool isFlashOn = false;
  bool isCapturing = false;
  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized)
      return Scaffold(
        body: Center(child: SpinKitCircle(color: AppConstants.primaryColor)),
      );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Live Camera Preview
          SizedBox.expand(child: CameraPreview(controller!)),

          // 2. Dark Overlay for focus
          Container(color: Colors.black.withOpacity(0.3)),

          // 3. UI Controls
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                children: [
                  // Top Row: Close, Title, Flash
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRoundButton(
                        Icons.close,
                        () => Navigator.pop(context),
                      ),
                      _buildScannerTag(),
                      _buildRoundButton(
                        isFlashOn ? Icons.flash_off : Icons.bolt,

                        () async {
                          setState(() {
                            isFlashOn = !isFlashOn;
                          });

                          if (isFlashOn) {
                            await controller!.setFlashMode(FlashMode.torch);
                          } else {
                            await controller!.setFlashMode(FlashMode.off);
                          }
                        },
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Center Frame (Scanning Area)
                  _buildScanningFrame(),

                  SizedBox(height: 20.h),
                  Text(
                    "Align formula within the frame",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),

                  const Spacer(),

                  // Bottom Row: Gallery, Shutter
                  Padding(
                    padding: EdgeInsets.only(bottom: 30.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildGalleryButton(),
                        _buildShutterButton(),
                        SizedBox(width: 60.w), // Spacer to balance the row
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

  Widget _buildRoundButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: icon == Icons.bolt ? Colors.amber : Colors.white,
          size: 24.sp,
        ),
      ),
    );
  }

  Widget _buildScannerTag() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        "SCANNING MATH",
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildScanningFrame() {
    return Container(
      width: 280.w,
      height: 200.h,
      child: Stack(
        children: [
          // Custom corners implementation
          Align(
            alignment: Alignment.topLeft,
            child: _corner(top: true, left: true),
          ),
          Align(
            alignment: Alignment.topRight,
            child: _corner(top: true, left: false),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: _corner(top: false, left: true),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: _corner(top: false, left: false),
          ),
        ],
      ),
    );
  }

  Widget _corner({required bool top, required bool left}) {
    return Container(
      width: 45.w,
      height: 45.h,
      decoration: BoxDecoration(
        // Only show borders on the outer edges
        border: Border(
          top: top
              ? BorderSide(color: AppConstants.primaryColor, width: 4.w)
              : BorderSide.none,
          bottom: !top
              ? BorderSide(color: AppConstants.primaryColor, width: 4.w)
              : BorderSide.none,
          left: left
              ? BorderSide(color: AppConstants.primaryColor, width: 4.w)
              : BorderSide.none,
          right: !left
              ? BorderSide(color: AppConstants.primaryColor, width: 4.w)
              : BorderSide.none,
        ),
        // Apply radius only to the specific corner to get that bracket look
        borderRadius: BorderRadius.only(
          topLeft: (top && left) ? Radius.circular(15.r) : Radius.zero,
          topRight: (top && !left) ? Radius.circular(15.r) : Radius.zero,
          bottomLeft: (!top && left) ? Radius.circular(15.r) : Radius.zero,
          bottomRight: (!top && !left) ? Radius.circular(15.r) : Radius.zero,
        ),
      ),
    );
  }

  Widget _buildGalleryButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            if (isCapturing) return;

            try {
              final ImagePicker picker = ImagePicker();
              final XFile? pickedFile = await picker.pickImage(
                source: ImageSource.gallery,
              );

              if (pickedFile == null) return;

              setState(() => isCapturing = true);

              File image = File(pickedFile.path);

              // 🧠 OCR
              String extractedText = await OCRService.extractText(image);

              // 🧹 Clean
              String cleanedText = MathCleaner.clean(extractedText);

              // ❌ if empty
              if (cleanedText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No math detected. Try again.")),
                );
                return;
              }

              // 🚀 NAVIGATE (PROPER WAY)
              final navProvider = Provider.of<NavigationProvider>(
                context,
                listen: false,
              );

              navProvider.setExpressionAndNavigate(
                cleanedText,
                2,
                image: image,
              );
              if (mounted) Navigator.pop(context);
            } catch (e) {
              debugPrint("Gallery error: $e");
            } finally {
              if (mounted) setState(() => isCapturing = false);
            }
          },
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(Icons.photo_library, color: Colors.white),
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          "GALLERY",
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
        ),
      ],
    );
  }

  Widget _buildShutterButton() {
    return GestureDetector(
      onTap: () async {
        if (isCapturing ||
            controller == null ||
            !controller!.value.isInitialized)
          return;

        try {
          setState(() => isCapturing = true);

          final XFile file = await controller!.takePicture();
          File image = File(file.path);

          // 🧠 OCR
          String extractedText = await OCRService.extractText(image);

          // 🧹 Clean
          String cleanedText = MathCleaner.clean(extractedText);

          // ❌ empty check
          if (cleanedText.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No math detected. Try again.")),
            );
            return;
          }

          // 🔥 NAVIGATE TO SOLVER
          final navProvider = Provider.of<NavigationProvider>(
            context,
            listen: false,
          );

          navProvider.setExpressionAndNavigate(cleanedText, 2, image: image);
          if (mounted) Navigator.pop(context);
        } catch (e) {
          debugPrint("Camera capture error: $e");
        } finally {
          if (mounted) setState(() => isCapturing = false);
        }
      },

      child: isCapturing
          ? SpinKitCircle(color: Colors.white, size: 50)
          : Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4.w),
              ),
              child: Container(
                height: 60.r,
                width: 60.r,
                margin: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.document_scanner, color: Colors.blue),
              ),
            ),
    );
  }
}
