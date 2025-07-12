// lib/widgets/image_picker_widget.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../services/cloudinary_service.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(String) onImageUploaded;
  final String? initialImageUrl;
  final bool isUploading;
  final VoidCallback? onStartUpload;

  const ImagePickerWidget({
    super.key,
    required this.onImageUploaded,
    this.initialImageUrl,
    this.isUploading = false,
    this.onStartUpload,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        setState(() {
          _isUploading = true;
        });

        if (widget.onStartUpload != null) {
          widget.onStartUpload!();
        }

        final imageUrl = await _cloudinaryService.uploadImage(pickedFile);

        if (imageUrl != null) {
          widget.onImageUploaded(imageUrl);
          Get.snackbar(
            'Success',
            'Image uploaded successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to upload image',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error picking/uploading image: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _isUploading = true;
        });

        if (widget.onStartUpload != null) {
          widget.onStartUpload!();
        }

        final uploadedUrls = await _cloudinaryService.uploadMultipleImages(pickedFiles);

        for (String url in uploadedUrls) {
          widget.onImageUploaded(url);
        }

        Get.snackbar(
          'Success',
          'Uploaded ${uploadedUrls.length} images successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error uploading images: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndUploadImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndUploadImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Multiple Images'),
                onTap: () {
                  Navigator.pop(context);
                  _pickMultipleImages();
                },
              ),
            ],
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
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: isCurrentlyUploading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text('Uploading...', style: TextStyle(fontSize: 12)),
          ],
        ),
      )
          : widget.initialImageUrl != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          widget.initialImageUrl!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade200,
              child: const Icon(
                Icons.error,
                color: Colors.red,
                size: 40,
              ),
            );
          },
        ),
      )
          : InkWell(
        onTap: _showImageSourceDialog,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade50,
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate,
                size: 40,
                color: Color(0xFF00BF63),
              ),
              SizedBox(height: 8),
              Text(
                'Add Image',
                style: TextStyle(
                  color: Color(0xFF00BF63),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}