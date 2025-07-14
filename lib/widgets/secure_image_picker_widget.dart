// lib/widgets/secure_image_picker_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../services/signed_cloudinary_service.dart';
import '../themes/app_theme.dart';

class SecureImagePickerWidget extends StatefulWidget {
  final Function(String) onImageUploaded;
  final String? initialImageUrl;
  final bool isUploading;
  final VoidCallback? onStartUpload;
  final VoidCallback? onEndUpload;
  final String? folder;

  const SecureImagePickerWidget({
    super.key,
    required this.onImageUploaded,
    this.initialImageUrl,
    this.isUploading = false,
    this.onStartUpload,
    this.onEndUpload,
    this.folder,
  });

  @override
  State<SecureImagePickerWidget> createState() =>
      _SecureImagePickerWidgetState();
}

class _SecureImagePickerWidgetState extends State<SecureImagePickerWidget> {
  final SignedCloudinaryService _cloudinaryService = SignedCloudinaryService();
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85, // Balanced quality vs size
        maxWidth: 1920,
        maxHeight: 1080,
        requestFullMetadata: false, // Reduce memory usage
      );

      if (pickedFile != null) {
        await _uploadImage(pickedFile);
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Image picker error:');
        print('Error: $e');
        print('StackTrace: $stackTrace');
      }
      _showErrorMessage('Error selecting image: ${e.toString()}');
    }
  }

  Future<void> _uploadImage(XFile imageFile) async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    widget.onStartUpload?.call();

    try {
      // Simulate progress for user feedback
      _updateProgress(0.1);

      // Convert XFile to File
      final file = File(imageFile.path);

      final imageUrl = await _cloudinaryService.uploadImage(
        file,
        folder: widget.folder ?? 'jenga_solutions',
      );

      _updateProgress(1.0);

      widget.onImageUploaded(imageUrl);
      _showSuccessMessage('Image uploaded successfully');
    } on CloudinaryException catch (e) {
      if (kDebugMode) {
        print('CloudinaryException in single image upload:');
        print('Message: ${e.message}');
        print('Details: ${e.details}');
      }
      _showErrorMessage('Upload failed: ${e.message}');
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Single image upload exception:');
        print('Error: $e');
        print('StackTrace: $stackTrace');
      }
      _showErrorMessage('Upload failed: ${e.toString()}');
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
      widget.onEndUpload?.call();
    }
  }

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
        requestFullMetadata: false,
      );

      if (pickedFiles.isNotEmpty) {
        await _uploadMultipleImages(pickedFiles);
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Multiple image picker error:');
        print('Error: $e');
        print('StackTrace: $stackTrace');
      }
      _showErrorMessage('Error selecting images: ${e.toString()}');
    }
  }

  Future<void> _uploadMultipleImages(List<XFile> imageFiles) async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    widget.onStartUpload?.call();

    try {
      // Convert XFiles to Files
      final files = imageFiles.map((xFile) => File(xFile.path)).toList();

      final uploadedUrls = await _cloudinaryService.uploadMultipleImages(
        files,
        folder: widget.folder ?? 'jenga_solutions',
        onProgress: (completed, total) {
          setState(() {
            _uploadProgress = completed / total;
          });
        },
      );

      for (String url in uploadedUrls) {
        widget.onImageUploaded(url);
      }

      _showSuccessMessage(
        'Uploaded ${uploadedUrls.length} of ${imageFiles.length} images',
      );
    } on CloudinaryException catch (e) {
      if (kDebugMode) {
        print('CloudinaryException in multiple image upload:');
        print('Message: ${e.message}');
        print('Details: ${e.details}');
      }
      _showErrorMessage('Multiple upload failed: ${e.message}');
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Multiple image upload exception:');
        print('Error: $e');
        print('StackTrace: $stackTrace');
      }
      _showErrorMessage('Multiple upload failed: ${e.toString()}');
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
      widget.onEndUpload?.call();
    }
  }

  void _updateProgress(double progress) {
    if (mounted) {
      setState(() {
        _uploadProgress = progress;
      });
    }
  }

  void _showSuccessMessage(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppTheme.successColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppTheme.error,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Image Source',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: Color(0xFF00BF63),
                  ),
                  title: const Text('Choose from Gallery'),
                  subtitle: const Text('Select single image'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndUploadImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_camera,
                    color: Color(0xFF00BF63),
                  ),
                  title: const Text('Take Photo'),
                  subtitle: const Text('Use camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndUploadImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: Color(0xFF00BF63),
                  ),
                  title: const Text('Multiple Images'),
                  subtitle: const Text('Select multiple images'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickMultipleImages();
                  },
                ),
                const SizedBox(height: 8),
                const Text(
                  'Max size: 5MB per image\nSupported: JPG, PNG, WebP',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentlyUploading = _isUploading || widget.isUploading;

    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: isCurrentlyUploading
          ? _buildUploadingWidget()
          : widget.initialImageUrl != null
          ? _buildImageWidget()
          : _buildAddImageWidget(),
    );
  }

  Widget _buildUploadingWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  value: _uploadProgress > 0 ? _uploadProgress : null,
                  strokeWidth: 3,
                  color: const Color(0xFF00BF63),
                ),
              ),
              if (_uploadProgress > 0)
                Text(
                  '${(_uploadProgress * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00BF63),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Uploading...',
            style: TextStyle(fontSize: 12, color: Color(0xFF00BF63)),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        widget.initialImageUrl!,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade50,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                color: const Color(0xFF00BF63),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red, size: 32),
                SizedBox(height: 4),
                Text(
                  'Load Error',
                  style: TextStyle(fontSize: 10, color: Colors.red),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddImageWidget() {
    return InkWell(
      onTap: _showImageSourceDialog,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade50,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, size: 40, color: Color(0xFF00BF63)),
            SizedBox(height: 8),
            Text(
              'Add Image',
              style: TextStyle(
                color: Color(0xFF00BF63),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
