// lib/services/signed_cloudinary_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryException implements Exception {
  final String message;
  final Map<String, dynamic> details;

  CloudinaryException(this.message, this.details);

  @override
  String toString() => 'CloudinaryException: $message';
}

class SignedCloudinaryService {
  // Get credentials from environment variables first, then .env file as fallback
  static String get _cloudName {
    // Try environment variable first
    const envCloudName = String.fromEnvironment('CLOUDINARY_CLOUD_NAME');
    if (envCloudName.isNotEmpty) return envCloudName;

    // Fallback to .env file
    return dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  }

  static String get _apiKey {
    // Try environment variable first
    const envApiKey = String.fromEnvironment('CLOUDINARY_API_KEY');
    if (envApiKey.isNotEmpty) return envApiKey;

    // Fallback to .env file
    return dotenv.env['CLOUDINARY_API_KEY'] ?? '';
  }

  static String get _apiSecret {
    // Try environment variable first
    const envApiSecret = String.fromEnvironment('CLOUDINARY_API_SECRET');
    if (envApiSecret.isNotEmpty) return envApiSecret;

    // Fallback to .env file
    return dotenv.env['CLOUDINARY_API_SECRET'] ?? '';
  }

  // File size limits
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
    'gif',
  ];

  /// Generate signature for signed uploads
  String _generateSignature(Map<String, String> params, String apiSecret) {
    // Sort parameters by key
    final sortedKeys = params.keys.toList()..sort();

    // Create parameter string
    final paramString =
        sortedKeys.map((key) => '$key=${params[key]}').join('&');

    // Add API secret to the end
    final stringToSign = '$paramString$apiSecret';

    if (kDebugMode) {}

    // Generate SHA-1 hash
    final bytes = utf8.encode(stringToSign);
    final digest = sha1.convert(bytes);

    return digest.toString();
  }

  /// Upload single image using signed uploads (no upload preset needed)
  Future<String> uploadImage(
    File imageFile, {
    String folder = 'uploads',
  }) async {
    try {
      if (kDebugMode) {}

      // Validate environment variables
      if (_cloudName.isEmpty || _apiKey.isEmpty || _apiSecret.isEmpty) {
        throw CloudinaryException(
          'Missing Cloudinary configuration. Please check environment variables.',
          {
            'cloudName': _cloudName,
            'apiKey': _apiKey.isNotEmpty ? 'SET' : 'MISSING',
          },
        );
      }

      // Validate file
      if (!await imageFile.exists()) {
        throw CloudinaryException('File does not exist', {
          'path': imageFile.path,
        });
      }

      final fileSize = await imageFile.length();
      if (fileSize > maxFileSize) {
        throw CloudinaryException(
          'File too large. Maximum size: ${maxFileSize ~/ (1024 * 1024)}MB',
          {'fileSize': fileSize, 'maxSize': maxFileSize},
        );
      }

      // Generate timestamp for signature
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Create parameters for signature - only include essential parameters
      // The 'format' parameter should NOT be in the signature
      final signatureParams = <String, String>{
        'folder': folder,
        'timestamp': timestamp.toString(),
      };

      // Generate signature
      final signature = _generateSignature(signatureParams, _apiSecret);

      if (kDebugMode) {}

      // Create multipart request
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
      );
      final request = http.MultipartRequest('POST', uri);

      // Add file
      final fileStream = http.ByteStream(imageFile.openRead());
      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileSize,
        filename: path.basename(imageFile.path),
      );
      request.files.add(multipartFile);

      // Add signed upload parameters (only include params that were signed)
      request.fields.addAll({
        'api_key': _apiKey,
        'timestamp': timestamp.toString(),
        'signature': signature,
        'folder': folder,
        // Only include safe optimization parameters
        'quality': 'auto',
      });

      if (kDebugMode) {
        // Fields debug info (signature removed for security)
      }

      // Send request with timeout
      final streamedResponse = await request.send().timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw CloudinaryException(
                'Upload timeout after 30 seconds', {}),
          );

      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {}

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final secureUrl = responseData['secure_url'] as String?;

        if (secureUrl != null) {
          if (kDebugMode) {}
          return secureUrl;
        } else {
          throw CloudinaryException('No secure_url in response', responseData);
        }
      } else {
        // Enhanced error logging for debugging
        if (kDebugMode) {
          // Debug info: HTTP ${response.statusCode} ${_getStatusText(response.statusCode)} Analysis
          if (response.statusCode == 400) {
          } else if (response.statusCode == 401) {
          } else if (response.statusCode == 403) {}
        }

        final responseData = json.decode(response.body);
        throw CloudinaryException(
          'Upload failed (${response.statusCode})',
          responseData,
        );
      }
    } catch (e) {
      // Ignore errors silently
      if (kDebugMode) {
        if (e is CloudinaryException) {}
      }
      rethrow;
    }
  }

  /// Upload multiple images in parallel with progress tracking
  Future<List<String>> uploadMultipleImages(
    List<File> imageFiles, {
    String folder = 'uploads',
    Function(int completed, int total)? onProgress,
  }) async {
    if (imageFiles.isEmpty) return [];

    final List<String> uploadedUrls = [];
    int completed = 0;

    try {
      // Create upload futures
      final uploadFutures = imageFiles.map((file) async {
        try {
          final url = await uploadImage(file, folder: folder);
          completed++;
          onProgress?.call(completed, imageFiles.length);
          return url;
        } catch (e) {
          // Ignore errors silently
          if (kDebugMode) {}
          completed++;
          onProgress?.call(completed, imageFiles.length);
          return null;
        }
      });

      // Wait for all uploads to complete
      final results = await Future.wait(uploadFutures);

      // Filter out failed uploads
      uploadedUrls.addAll(results.where((url) => url != null).cast<String>());

      return uploadedUrls;
    } catch (e) {
      // Ignore errors silently
      throw CloudinaryException('Multiple upload failed', {
        'error': e.toString(),
      });
    }
  }

  /// Validate if a URL is a valid image URL
  static bool isValidImageUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || !['http', 'https'].contains(uri.scheme)) {
        return false;
      }

      final path = uri.path.toLowerCase();
      return allowedExtensions.any((ext) => path.endsWith('.$ext')) ||
          path.contains(RegExp(r'\.(jpg|jpeg|png|gif|webp)(\?|$)'));
    } catch (e) {
      // Ignore errors silently
      return false;
    }
  }
}
