// lib/services/signed_cloudinary_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

class CloudinaryException implements Exception {
  final String message;
  final Map<String, dynamic> details;

  CloudinaryException(this.message, this.details);

  @override
  String toString() => 'CloudinaryException: $message';
}

class SignedCloudinaryService {
  // Use environment variables - never hardcode credentials
  static const String _cloudName = String.fromEnvironment(
    'CLOUDINARY_CLOUD_NAME',
    defaultValue: 'dnfeo5ce9',
  );
  static const String _apiKey = String.fromEnvironment(
    'CLOUDINARY_API_KEY',
    defaultValue: '262367665752528',
  );
  static const String _apiSecret = String.fromEnvironment(
    'CLOUDINARY_API_SECRET',
    defaultValue: 'xpnLEFUJHLJjRdDemkn9LG2ViXs',
  );

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
    final paramString = sortedKeys
        .map((key) => '$key=${params[key]}')
        .join('&');

    // Add API secret to the end
    final stringToSign = '$paramString$apiSecret';

    if (kDebugMode) {
      print('=== Signature Debug ===');
      print('Sorted Keys: $sortedKeys');
      print('Param String: $paramString');
      print('String to Sign: $stringToSign');
      print('API Secret Length: ${apiSecret.length}');
      print('Expected Format: folder=X&format=auto&timestamp=Y');
      print('Actual Format: $paramString');
      print('=====================');
    }

    // Generate SHA-1 hash
    final bytes = utf8.encode(stringToSign);
    final digest = sha1.convert(bytes);

    return digest.toString();
  }

  /// Get HTTP status text
  String _getStatusText(int statusCode) {
    switch (statusCode) {
      case 200:
        return 'OK';
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 413:
        return 'Payload Too Large';
      case 429:
        return 'Too Many Requests';
      case 500:
        return 'Internal Server Error';
      default:
        return 'Unknown';
    }
  }

  /// Upload single image using signed uploads (no upload preset needed)
  Future<String> uploadImage(
    File imageFile, {
    String folder = 'uploads',
  }) async {
    try {
      if (kDebugMode) {
        print('Folder: $folder');
      }

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

      if (kDebugMode) {
        print('=== Signature Generation Debug ===');
        print('Timestamp: $timestamp');
        print('Signature Params: $signatureParams');
        print('Generated Signature: $signature');
        print('Note: format parameter excluded from signature');
        print('================================');
      }

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
        print('================================');
        print('=== Cloudinary Signed Upload Request ===');
        print('URL: ${request.url}');
        print('Method: ${request.method}');
        print(
          'Fields: ${Map.from(request.fields)..remove('signature')}',
        ); // Don't log signature
        print('File: ${imageFile.path}');
        print('File Size: ${fileSize} bytes');
        print('Timestamp: $timestamp');
        print('================================');
      }

      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () =>
            throw CloudinaryException('Upload timeout after 30 seconds', {}),
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print('================================');
        print('=== Cloudinary Upload Response ===');
        print('Status Code: ${response.statusCode}');
        print('Headers: ${response.headers}');
        print('Body: ${response.body}');
        print('================================');
      }

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final secureUrl = responseData['secure_url'] as String?;

        if (secureUrl != null) {
          if (kDebugMode) {
            print('✅ Upload successful: $secureUrl');
          }
          return secureUrl;
        } else {
          throw CloudinaryException('No secure_url in response', responseData);
        }
      } else {
        // Enhanced error logging for debugging
        if (kDebugMode) {
          print('================================');
          print('=== Cloudinary Upload Failed ===');
          print('Status Code: ${response.statusCode}');
          print('Request URL: ${request.url}');
          print('Cloud Name: $_cloudName');
          print('API Key: ${_apiKey.substring(0, 6)}...');
          print('File Path: ${imageFile.path}');
          print('Response Headers: ${response.headers}');
          print('Response Body: ${response.body}');
          print(
            '=== HTTP ${response.statusCode} ${_getStatusText(response.statusCode)} Analysis ===',
          );
          print('Common causes:');
          if (response.statusCode == 400) {
            print('- Invalid signature or parameters');
            print('- File validation failed on Cloudinary side');
            print('- Malformed request parameters');
            print('- Timestamp too old (>1 hour)');
          } else if (response.statusCode == 401) {
            print('- Invalid API credentials');
            print('- Expired or revoked API key');
            print('- Invalid signature');
          } else if (response.statusCode == 403) {
            print('- Insufficient permissions');
            print('- Account limits exceeded');
          }
          print('===============================');
        }

        final responseData = json.decode(response.body);
        throw CloudinaryException(
          'Upload failed (${response.statusCode})',
          responseData,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('CloudinaryException in single image upload:');
        print('Message: ${e.toString()}');
        if (e is CloudinaryException) {
          print('Details: ${e.details}');
        }
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
          if (kDebugMode) {
            print('Failed to upload ${file.path}: $e');
          }
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
      return false;
    }
  }

  /// Get upload configuration status
  static Map<String, dynamic> getConfigStatus() {
    return {
      'cloudName': _cloudName.isNotEmpty ? 'configured' : 'missing',
      'apiKey': _apiKey.isNotEmpty ? 'configured' : 'missing',
      'apiSecret': _apiSecret.isNotEmpty ? 'configured' : 'missing',
      'maxFileSize': '${maxFileSize ~/ (1024 * 1024)}MB',
      'allowedTypes': allowedExtensions,
      'uploadMethod': 'signed (no preset required)',
    };
  }
}
