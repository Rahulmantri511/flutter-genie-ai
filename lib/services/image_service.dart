import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class ImagePickerService {
  static Future<ImageResult?> pickImage() async {
    if (kIsWeb) {
      // Web implementation
      try {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
          withData: true,
        );

        if (result != null && result.files.isNotEmpty) {
          return ImageResult(
            fileName: result.files.first.name,
            bytes: result.files.first.bytes!,
          );
        }
        return null;
      } catch (e) {
        print('Error picking image on web: $e');
        return null;
      }
    } else {
      // Mobile implementation
      try {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);

        if (image != null) {
          final bytes = await image.readAsBytes();
          return ImageResult(
            fileName: image.name,
            bytes: bytes,
          );
        }
        return null;
      } catch (e) {
        print('Error picking image on mobile: $e');
        return null;
      }
    }
  }
}

class ImageResult {
  final String fileName;
  final Uint8List bytes;

  ImageResult({required this.fileName, required this.bytes});
}