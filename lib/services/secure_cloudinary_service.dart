// // lib/services/secure_cloudinary_service.dart
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:crypto/crypto.dart';
// import 'package:path/path.dart' as path;

// class CloudinaryException implements Exception {
//   final String message;
//   final Map<String, dynamic> details;

//   CloudinaryException(this.message, this.details);

//   @override
//   String toString() => 'CloudinaryException: $message';
// }

// class SecureCloudinaryService {
//   // Use environment variables - never hardcode credentials
//   static const String _cloudName = String.fromEnvironment(
//     'CLOUDINARY_CLOUD_NAME',
//     defaultValue: 'dnfeo5ce9',
//   );
//   static const String _apiKey = String.fromEnvironment(
//     'CLOUDINARY_API_KEY',
//     defaultValue: '262367665752528',
//   );
//   static const String _apiSecret = String.fromEnvironment(
//     'CLOUDINARY_API_SECRET',
//     defaultValue: 'xpnLEFUJHLJjRdDemkn9LG2ViXs',
//   );

//   // File size limits
//   static const int maxFileSize = 10 * 1024 * 1024; // 10MB
//   static const List<String> allowedExtensions = [
//     'jpg',
//     'jpeg',
//     'png',
//     'webp',
//     'gif',
//   ];

//   /// Generate signature for signed uploads
//   String _generateSignature(Map<String, dynamic> params, String apiSecret) {
//     // Sort parameters by key
//     final sortedKeys = params.keys.toList()..sort();

//     // Create parameter string
//     final paramString = sortedKeys
//         .map((key) => '$key=${params[key]}')
//         .join('&');

//     // Add API secret to the end
//     final stringToSign = '$paramString$apiSecret';

//     // Generate SHA-1 hash
//     final bytes = utf8.encode(stringToSign);
//     final digest = sha1.convert(bytes);

//     return digest.toString();
//   }

//   /// Get HTTP status text
//   String _getStatusText(int statusCode) {
//     switch (statusCode) {
//       case 200:
//         return 'OK';
//       case 400:
//         return 'Bad Request';
//       case 401:
//         return 'Unauthorized';
//       case 403:
//         return 'Forbidden';
//       case 404:
//         return 'Not Found';
//       case 413:
//         return 'Payload Too Large';
//       case 429:
//         return 'Too Many Requests';
//       case 500:
//         return 'Internal Server Error';
//       default:
//         return 'Unknown';
//     }
//   }

//   /// Validate image file before upload
//   Future<void> _validateImage(XFile imageFile) async {
//     // Check file size
//     final bytes = await imageFile.readAsBytes();
//     if (bytes.length > maxFileSizeBytes) {
//       throw CloudinaryException('Image too large. Maximum size is 5MB.');
//     }

//     // Check file extension
//     final extension = imageFile.path.toLowerCase().split('.').last;
//     if (!allowedExtensions.contains(extension)) {
//       throw CloudinaryException(
//         'Unsupported file type. Use JPG, PNG, or WebP.',
//       );
//     }

//     // Additional validation for actual image content could be added here
//   }

//   /// Upload single image with comprehensive error handling
//   Future<String> uploadImage(XFile imageFile, {String? folder}) async {
//     try {
//       // Validate image first
//       await _validateImage(imageFile);

//       // Debug logging for request details
//       if (kDebugMode) {
//         print('=== Cloudinary Upload Request ===');
//         print('Cloud Name: $_cloudName');
//         print('Upload Preset: $_uploadPreset');
//         print('File Path: ${imageFile.path}');
//         print('File Size: ${(await imageFile.readAsBytes()).length} bytes');
//         print('Folder: ${folder ?? 'none'}');
//         print('================================');
//       }

//       final url = Uri.parse(
//         'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
//       );
//       var request = http.MultipartRequest('POST', url);

//       // Add the image file
//       request.files.add(
//         await http.MultipartFile.fromPath('file', imageFile.path),
//       );

//       // Use upload preset for security (configured in Cloudinary dashboard)
//       request.fields['upload_preset'] = _uploadPreset;

//       // Optional folder organization
//       if (folder != null) {
//         request.fields['folder'] = folder;
//       }

//       // Add quality optimization
//       request.fields['quality'] = 'auto';
//       request.fields['fetch_format'] = 'auto';

//       // Send request with timeout
//       final streamedResponse = await request.send().timeout(
//         const Duration(seconds: 30),
//         onTimeout: () => throw CloudinaryException(
//           'Upload timeout - please check your connection',
//         ),
//       );

//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         final secureUrl = jsonResponse['secure_url'] as String?;

//         if (secureUrl == null) {
//           throw CloudinaryException('Invalid response: missing secure_url');
//         }

//         return secureUrl;
//       } else {
//         final errorBody = response.body;

//         // Log detailed error information for debugging
//         if (kDebugMode) {
//           print('=== Cloudinary Upload Failed ===');
//           print('Status Code: ${response.statusCode}');
//           print(
//             'Request URL: https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
//           );
//           print('Cloud Name: $_cloudName');
//           print('Upload Preset: $_uploadPreset');
//           print('File Path: ${imageFile.path}');
//           print('Response Headers: ${response.headers}');
//           print('Response Body: $errorBody');

//           // Special handling for common error codes
//           if (response.statusCode == 400) {
//             print('=== HTTP 400 Bad Request Analysis ===');
//             print('Common causes:');
//             print('- Invalid upload preset name');
//             print('- Missing or incorrect configuration');
//             print('- File validation failed on Cloudinary side');
//             print('- Malformed request parameters');
//           }
//           print('===============================');
//         }

//         try {
//           final errorJson = json.decode(errorBody);
//           final errorMessage =
//               errorJson['error']?['message'] ?? 'Unknown error';
//           throw CloudinaryException(
//             'Upload failed (${response.statusCode}): $errorMessage',
//             errorBody,
//           );
//         } catch (jsonError) {
//           // If JSON parsing fails, use raw response
//           throw CloudinaryException(
//             'Upload failed (${response.statusCode})',
//             errorBody.isNotEmpty ? errorBody : 'No error details provided',
//           );
//         }
//       }
//     } on CloudinaryException {
//       rethrow;
//     } catch (e, stackTrace) {
//       if (kDebugMode) {
//         print('Cloudinary Upload Exception:');
//         print('Error: $e');
//         print('StackTrace: $stackTrace');
//       }
//       throw CloudinaryException('Upload failed: ${e.toString()}');
//     }
//   }

//   /// Upload multiple images in parallel with progress tracking
//   Future<List<String>> uploadMultipleImages(
//     List<XFile> imageFiles, {
//     String? folder,
//     Function(int completed, int total)? onProgress,
//   }) async {
//     if (imageFiles.isEmpty) return [];

//     final List<String> uploadedUrls = [];
//     int completed = 0;

//     try {
//       // Create upload futures
//       final uploadFutures = imageFiles.map((file) async {
//         try {
//           final url = await uploadImage(file, folder: folder);
//           completed++;
//           onProgress?.call(completed, imageFiles.length);
//           return url;
//         } catch (e) {
//           if (kDebugMode) {
//             print('Failed to upload ${file.name}: $e');
//           }
//           completed++;
//           onProgress?.call(completed, imageFiles.length);
//           return null;
//         }
//       });

//       // Wait for all uploads to complete
//       final results = await Future.wait(uploadFutures);

//       // Filter out failed uploads
//       uploadedUrls.addAll(results.where((url) => url != null).cast<String>());

//       return uploadedUrls;
//     } catch (e) {
//       throw CloudinaryException('Multiple upload failed: ${e.toString()}');
//     }
//   }

//   /// Delete image from Cloudinary (for cleanup)
//   /// ⚠️ WARNING: This uses API secret and should only be used server-side!
//   Future<bool> deleteImage(String publicId) async {
//     try {
//       // ⚠️ SECURITY WARNING: Using API secret in client is NOT recommended
//       // This should ideally be implemented on your backend server

//       final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
//       final signature = _generateSignature(publicId, timestamp);

//       final url = Uri.parse(
//         'https://api.cloudinary.com/v1_1/$_cloudName/image/destroy',
//       );

//       final response = await http.post(
//         url,
//         body: {
//           'public_id': publicId,
//           'timestamp': timestamp,
//           'api_key': _apiKey,
//           'signature': signature,
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         return jsonResponse['result'] == 'ok';
//       }

//       return false;
//     } catch (e) {
//       if (kDebugMode) {
//         print('Delete error: $e');
//       }
//       return false;
//     }
//   }

//   /// Generate signature for authenticated requests
//   /// ⚠️ WARNING: Uses API secret - only for server-side use!
//   String _generateSignature(String publicId, String timestamp) {
//     final params = 'public_id=$publicId&timestamp=$timestamp$_apiSecret';
//     final bytes = utf8.encode(params);
//     final digest = sha1.convert(bytes);
//     return digest.toString();
//   }

//   /// Get optimized image URL with transformations
//   String getOptimizedImageUrl(
//     String originalUrl, {
//     int? width,
//     int? height,
//     String quality = 'auto',
//     String format = 'auto',
//     String crop = 'fill',
//   }) {
//     if (!originalUrl.contains('cloudinary.com')) {
//       return originalUrl;
//     }

//     try {
//       // Extract public ID from URL
//       final uri = Uri.parse(originalUrl);
//       final pathSegments = uri.pathSegments;
//       final uploadIndex = pathSegments.indexOf('upload');

//       if (uploadIndex == -1 || uploadIndex >= pathSegments.length - 1) {
//         return originalUrl;
//       }

//       final publicIdParts = pathSegments.sublist(uploadIndex + 1);
//       final publicId = publicIdParts.join('/').split('.').first;

//       // Build transformation string
//       List<String> transformations = [];
//       if (width != null) transformations.add('w_$width');
//       if (height != null) transformations.add('h_$height');
//       transformations.addAll(['c_$crop', 'q_$quality', 'f_$format']);

//       final transformationString = transformations.join(',');

//       return 'https://res.cloudinary.com/$_cloudName/image/upload/$transformationString/v1/$publicId';
//     } catch (e) {
//       if (kDebugMode) {
//         print('URL transformation error: $e');
//       }
//       return originalUrl;
//     }
//   }

//   /// Get thumbnail URL
//   String getThumbnailUrl(String originalUrl) {
//     return getOptimizedImageUrl(
//       originalUrl,
//       width: 150,
//       height: 150,
//       quality: 'auto',
//       format: 'auto',
//     );
//   }

//   /// Get medium sized image URL
//   String getMediumImageUrl(String originalUrl) {
//     return getOptimizedImageUrl(
//       originalUrl,
//       width: 400,
//       height: 400,
//       quality: 'auto',
//       format: 'auto',
//     );
//   }

//   /// Validate if a URL is a valid image URL
//   static bool isValidImageUrl(String url) {
//     try {
//       final uri = Uri.parse(url);
//       if (!uri.hasScheme || !['http', 'https'].contains(uri.scheme)) {
//         return false;
//       }

//       final path = uri.path.toLowerCase();
//       return allowedExtensions.any((ext) => path.endsWith('.$ext')) ||
//           path.contains(RegExp(r'\.(jpg|jpeg|png|gif|webp)(\?|$)'));
//     } catch (e) {
//       return false;
//     }
//   }

//   /// Get upload configuration status
//   static Map<String, dynamic> getConfigStatus() {
//     return {
//       'cloudName': _cloudName != 'your_cloud_name' ? 'configured' : 'missing',
//       'uploadPreset': _uploadPreset != 'your_upload_preset'
//           ? 'configured'
//           : 'missing',
//       'maxFileSize': '${maxFileSizeBytes ~/ (1024 * 1024)}MB',
//       'allowedTypes': allowedExtensions,
//     };
//   }
// }
