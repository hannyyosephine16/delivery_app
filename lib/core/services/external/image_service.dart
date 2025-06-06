// lib/core/services/external/image_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:get/get.dart' as getx;
import 'package:delivery_app/app/config/app_config.dart';

class ImageService extends getx.GetxService {
  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image from gallery: $e');
    }
  }

  // Pick image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image from camera: $e');
    }
  }

  // Pick multiple images
  Future<List<File>?> pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        return images.map((image) => File(image.path)).toList();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick multiple images: $e');
    }
  }

  // Compress image
  Future<File> compressImage(File imageFile, {int quality = 85}) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize if too large
      img.Image resized = image;
      if (image.width > 1024 || image.height > 1024) {
        resized = img.copyResize(
          image,
          width: image.width > image.height ? 1024 : null,
          height: image.height > image.width ? 1024 : null,
        );
      }

      final compressedBytes = img.encodeJpg(resized, quality: quality);

      // Create new file with compressed data
      final compressedFile = File('${imageFile.path}_compressed.jpg');
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      throw Exception('Failed to compress image: $e');
    }
  }

  // Convert image to base64
  Future<String> imageToBase64(File imageFile) async {
    try {
      // Check file size
      final fileSize = await imageFile.length();
      if (fileSize > AppConfig.maxImageSize) {
        throw Exception('Image size exceeds maximum limit');
      }

      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);

      // Get file extension
      final extension = imageFile.path.split('.').last.toLowerCase();
      if (!AppConfig.allowedImageTypes.contains(extension)) {
        throw Exception('Unsupported image type');
      }

      return 'data:image/$extension;base64,$base64String';
    } catch (e) {
      throw Exception('Failed to convert image to base64: $e');
    }
  }

  // Convert base64 to image file
  Future<File> base64ToImage(String base64String, String fileName) async {
    try {
      // Extract base64 data
      final base64Data = base64String.split(',').last;
      final bytes = base64Decode(base64Data);

      // Create temporary file
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(bytes);

      return file;
    } catch (e) {
      throw Exception('Failed to convert base64 to image: $e');
    }
  }

  // Resize image
  Future<File> resizeImage(File imageFile, int width, int height) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      final resized = img.copyResize(image, width: width, height: height);
      final resizedBytes = img.encodeJpg(resized);

      final resizedFile = File('${imageFile.path}_resized.jpg');
      await resizedFile.writeAsBytes(resizedBytes);

      return resizedFile;
    } catch (e) {
      throw Exception('Failed to resize image: $e');
    }
  }

  // Create thumbnail
  Future<File> createThumbnail(File imageFile, {int size = 150}) async {
    return await resizeImage(imageFile, size, size);
  }

  // Validate image file
  bool validateImageFile(File imageFile) {
    // Check file extension
    final extension = imageFile.path.split('.').last.toLowerCase();
    if (!AppConfig.allowedImageTypes.contains(extension)) {
      return false;
    }

    return true;
  }

  // Get image size
  Future<int> getImageSize(File imageFile) async {
    return await imageFile.length();
  }

  // Show image picker options
  Future<File?> showImagePickerOptions() async {
    return await getx.Get.bottomSheet<File?>(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Image Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    final image = await pickImageFromCamera();
                    getx.Get.back(result: image);
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.camera_alt, size: 50),
                      SizedBox(height: 8),
                      Text('Camera'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final image = await pickImageFromGallery();
                    getx.Get.back(result: image);
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.photo_library, size: 50),
                      SizedBox(height: 8),
                      Text('Gallery'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
