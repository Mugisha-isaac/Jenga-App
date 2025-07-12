// lib/services/cloudinary_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  static const String _cloudName = 'dnfeo5ce9'; // Replace with your Cloudinary cloud name
  static const String _apiKey = '262367665752528'; // Replace with your API key
  static const String _apiSecret = 'xpnLEFUJHLJjRdDemkn9LG2ViXs'; // Replace with your API secret
 // static const String _uploadPreset = 'your_upload_preset'; // Replace with your upload preset

  // Upload image to Cloudinary
  Future<String?> uploadImage(XFile imageFile) async {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');

      var request = http.MultipartRequest('POST', url);

      // Add the image file
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      // Add upload parameters
     // request.fields['upload_preset'] = _uploadPreset;
      request.fields['folder'] = 'jenga_solutions'; // Optional: organize in folders

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);
        return jsonResponse['secure_url']; // Return the secure URL
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  // Upload multiple images
  Future<List<String>> uploadMultipleImages(List<XFile> imageFiles) async {
    List<String> uploadedUrls = [];

    for (XFile imageFile in imageFiles) {
      try {
        final url = await uploadImage(imageFile);
        if (url != null) {
          uploadedUrls.add(url);
        }
      } catch (e) {
        print('Error uploading image ${imageFile.name}: $e');
        // Continue with other images even if one fails
      }
    }

    return uploadedUrls;
  }

  // Delete image from Cloudinary (optional)
  Future<bool> deleteImage(String publicId) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final signature = _generateSignature(publicId, timestamp);

      final url = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/destroy');

      final response = await http.post(
        url,
        body: {
          'public_id': publicId,
          'timestamp': timestamp,
          'api_key': _apiKey,
          'signature': signature,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['result'] == 'ok';
      }

      return false;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  // Generate signature for authenticated requests
  String _generateSignature(String publicId, String timestamp) {
    final params = 'public_id=$publicId&timestamp=$timestamp$_apiSecret';
    final bytes = utf8.encode(params);
    final digest = sha1.convert(bytes);
    return digest.toString();
  }

  // Get optimized image URL with transformations
  String getOptimizedImageUrl(String originalUrl, {
    int? width,
    int? height,
    String quality = 'auto',
    String format = 'auto',
  }) {
    if (!originalUrl.contains('cloudinary.com')) {
      return originalUrl;
    }

    // Extract public ID from URL
    final parts = originalUrl.split('/');
    final uploadIndex = parts.indexOf('upload');
    if (uploadIndex == -1) return originalUrl;

    final publicIdParts = parts.sublist(uploadIndex + 1);
    final publicId = publicIdParts.join('/').split('.').first;

    // Build transformation string
    List<String> transformations = [];
    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    transformations.add('q_$quality');
    transformations.add('f_$format');

    final transformationString = transformations.join(',');

    return 'https://res.cloudinary.com/$_cloudName/image/upload/$transformationString/$publicId';
  }

  // Get thumbnail URL
  String getThumbnailUrl(String originalUrl) {
    return getOptimizedImageUrl(
      originalUrl,
      width: 150,
      height: 150,
      quality: 'auto',
      format: 'auto',
    );
  }
}