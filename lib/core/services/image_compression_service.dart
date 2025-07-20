import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/app_logger.dart';

/// Service for compressing images before upload
class ImageCompressionService {
  static ImageCompressionService? _instance;
  static ImageCompressionService get instance =>
      _instance ??= ImageCompressionService._();

  ImageCompressionService._();

  /// Compress image for profile photo upload
  /// Target: < 500KB, max 800x800 pixels
  static Future<File?> compressProfileImage(String filePath) async {
    try {
      AppLogger.info('Starting profile image compression for: $filePath');

      final file = File(filePath);
      if (!await file.exists()) {
        AppLogger.error('File does not exist: $filePath');
        return null;
      }

      // Get file size before compression
      final originalSize = await file.length();
      AppLogger.info(
        'Original file size: ${(originalSize / 1024).toStringAsFixed(2)} KB',
      );

      // If file is already small enough, return as is
      if (originalSize <= 300 * 1024) {
        // 300KB
        AppLogger.info('File is already small enough, no compression needed');
        return file;
      }

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final targetPath =
          '${tempDir.path}/compressed_profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Compress image
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        filePath,
        targetPath,
        quality: 70, // Start with 70% quality
        format: CompressFormat.jpeg,
      );

      if (compressedFile == null) {
        AppLogger.error('Failed to compress image');
        return null;
      }

      // Check compressed file size
      final compressedSize = await File(compressedFile.path).length();
      AppLogger.info(
        'Compressed file size: ${(compressedSize / 1024).toStringAsFixed(2)} KB',
      );

      // If still too large, compress more aggressively
      if (compressedSize > 500 * 1024) {
        // 500KB
        AppLogger.info('File still too large, compressing more aggressively');

        final secondCompression = await FlutterImageCompress.compressAndGetFile(
          compressedFile.path,
          '${tempDir.path}/compressed_profile_2_${DateTime.now().millisecondsSinceEpoch}.jpg',
          quality: 50, // More aggressive compression
          format: CompressFormat.jpeg,
        );

        if (secondCompression != null) {
          final finalSize = await File(secondCompression.path).length();
          AppLogger.info(
            'Final compressed file size: ${(finalSize / 1024).toStringAsFixed(2)} KB',
          );

          // Clean up first compressed file
          try {
            await File(compressedFile.path).delete();
          } catch (e) {
            AppLogger.warning('Failed to delete temporary file: $e');
          }

          return File(secondCompression.path);
        }
      }

      return File(compressedFile.path);
    } catch (e) {
      AppLogger.error('Error compressing profile image: $e');
      return null;
    }
  }

  /// Compress image to bytes for direct upload
  static Future<Uint8List?> compressImageToBytes(
    String filePath, {
    int quality = 70,
    int maxWidth = 800,
    int maxHeight = 800,
  }) async {
    try {
      AppLogger.info('Compressing image to bytes: $filePath');

      final compressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      if (compressedBytes != null) {
        AppLogger.info(
          'Compressed to ${(compressedBytes.length / 1024).toStringAsFixed(2)} KB',
        );
      }

      return compressedBytes;
    } catch (e) {
      AppLogger.error('Error compressing image to bytes: $e');
      return null;
    }
  }

  /// Get image file size in KB
  static Future<double> getFileSizeInKB(String filePath) async {
    try {
      final file = File(filePath);
      final size = await file.length();
      return size / 1024;
    } catch (e) {
      AppLogger.error('Error getting file size: $e');
      return 0;
    }
  }

  /// Validate image file
  static Future<bool> validateImageFile(String filePath) async {
    try {
      final file = File(filePath);

      // Check if file exists
      if (!await file.exists()) {
        AppLogger.error('File does not exist: $filePath');
        return false;
      }

      // Check file size (max 10MB)
      final size = await file.length();
      if (size > 10 * 1024 * 1024) {
        AppLogger.error(
          'File too large: ${(size / 1024 / 1024).toStringAsFixed(2)} MB',
        );
        return false;
      }

      // Check file extension
      final extension = filePath.toLowerCase().split('.').last;
      if (!['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
        AppLogger.error('Unsupported file format: $extension');
        return false;
      }

      return true;
    } catch (e) {
      AppLogger.error('Error validating image file: $e');
      return false;
    }
  }

  /// Clean up temporary compressed files
  static Future<void> cleanupTempFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();

      for (final file in files) {
        if (file.path.contains('compressed_profile_')) {
          try {
            await file.delete();
            AppLogger.debug('Deleted temp file: ${file.path}');
          } catch (e) {
            AppLogger.warning(
              'Failed to delete temp file: ${file.path}, Error: $e',
            );
          }
        }
      }
    } catch (e) {
      AppLogger.error('Error cleaning up temp files: $e');
    }
  }
}
