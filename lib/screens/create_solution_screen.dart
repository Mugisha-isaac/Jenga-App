// lib/screens/create_solution_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../modules/solution_controller.dart';
import '../modules/auth_controller.dart';
import '../widgets/secure_image_picker_widget.dart';
import '../models/solution.dart';
import '../themes/app_theme.dart';

class CreateSolutionScreen extends StatelessWidget {
  const CreateSolutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    final controller = Get.put(SolutionController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.isEditMode.value ? 'Edit Solution' : 'Create Solution',
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoSection(controller),
                    const SizedBox(height: 24),
                    _buildLocationSection(controller),
                    const SizedBox(height: 24),
                    _buildCategorySection(controller),
                    const SizedBox(height: 24),
                    _buildImagesSection(controller),
                    const SizedBox(height: 24),
                    _buildMaterialsSection(controller),
                    const SizedBox(height: 24),
                    _buildStepsSection(controller),
                    const SizedBox(height: 24),
                    _buildTagsSection(controller),
                    const SizedBox(height: 24),
                    _buildPremiumSection(controller),
                    const SizedBox(height: 32),
                    _buildSubmitButton(controller),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSubmitButton(SolutionController controller) {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.createSolution,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00BF63),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            controller.isEditMode.value ? 'Update Solution' : 'Create Solution',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(SolutionController controller) {
    return _buildSection(
      title: 'Basic Information',
      child: Column(
        children: [
          _buildTextField(
            controller: controller.titleController,
            label: 'Title',
            hint: 'Enter solution title',
            required: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: controller.descriptionController,
            label: 'Description',
            hint: 'Describe your solution',
            maxLines: 4,
            required: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(SolutionController controller) {
    return _buildSection(
      title: 'Location',
      child: Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: controller.countryController,
              label: 'Country',
              hint: 'Country',
              required: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTextField(
              controller: controller.cityController,
              label: 'City',
              hint: 'City',
              required: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(SolutionController controller) {
    return _buildSection(
      title: 'Category',
      child: Obx(
        () => DropdownButtonFormField<String>(
          value: controller.selectedCategory.value.isEmpty
              ? null
              : controller.selectedCategory.value,
          decoration: InputDecoration(
            labelText: 'Select Category',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          items: controller.categories.map((category) {
            return DropdownMenuItem(value: category, child: Text(category));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.setCategory(value);
            }
          },
          validator: (value) =>
              value == null ? 'Please select a category' : null,
        ),
      ),
    );
  }

  Widget _buildImagesSection(SolutionController controller) {
    return _buildSection(
      title: 'Images',
      child: Column(
        children: [
          // Image picker widgets
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              // Add new image picker
              SecureImagePickerWidget(
                onImageUploaded: (url) {
                  if (kDebugMode) {
                    print('Image uploaded successfully: $url');
                  }
                  controller.addImageUrlFromUpload(url);
                  controller.endImageUpload();
                },
                isUploading: controller.isUploadingImages.value,
                onStartUpload: () {
                  if (kDebugMode) {
                    print('Starting image upload...');
                  }
                  controller.startImageUpload();
                },
                onEndUpload: () {
                  if (kDebugMode) {
                    print('Image upload completed');
                  }
                  controller.endImageUpload();
                },
                folder: 'jenga_solutions',
              ),
              // Display uploaded images
              ...controller.imageUrls.asMap().entries.map((entry) {
                return Stack(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          entry.value,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
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
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => controller.removeImageUrl(entry.key),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          // Manual URL input (optional)
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Or paste image URL',
                    hintText: 'Enter image URL manually',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty &&
                        _isValidImageUrl(value.trim())) {
                      controller.addImageUrl(value.trim());
                    } else if (value.trim().isNotEmpty) {
                      Get.snackbar(
                        'Invalid URL',
                        'Please enter a valid image URL',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  // Get text from a temporary controller or show dialog
                  _showManualUrlDialog(controller);
                },
                icon: const Icon(Icons.add_link),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF00BF63),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Total Images: ${controller.imageUrls.length}',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showManualUrlDialog(SolutionController controller) {
    final TextEditingController urlController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Image URL'),
        content: TextField(
          controller: urlController,
          decoration: const InputDecoration(
            labelText: 'Image URL',
            hintText: 'https://example.com/image.jpg',
          ),
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final url = urlController.text.trim();
              if (url.isNotEmpty && _isValidImageUrl(url)) {
                controller.addImageUrl(url);
                Get.back();
              } else if (url.isNotEmpty) {
                Get.snackbar(
                  'Invalid URL',
                  'Please enter a valid image URL (jpg, png, webp)',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsSection(SolutionController controller) {
    return _buildSection(
      title: 'Materials',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.materialController,
                  decoration: InputDecoration(
                    labelText: 'Material',
                    hintText: 'Enter material name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  onSubmitted: (_) => controller.addMaterial(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: controller.addMaterial,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF00BF63),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => controller.materials.isEmpty
                ? const Text('No materials added yet')
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.materials.asMap().entries.map((entry) {
                      return _buildChip(entry.value, () {
                        controller.removeMaterial(entry.key);
                      });
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsSection(SolutionController controller) {
    return _buildSection(
      title: 'Steps',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.stepDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Step Description',
                    hintText: 'Describe the step',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  maxLines: 2,
                  onSubmitted: (_) => controller.addStep(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: controller.addStep,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF00BF63),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => controller.steps.isEmpty
                ? const Text('No steps added yet')
                : Column(
                    children: controller.steps.asMap().entries.map((entry) {
                      return _buildStepCard(entry.value, () {
                        controller.removeStep(entry.key);
                      });
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection(SolutionController controller) {
    return _buildSection(
      title: 'Tags',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.tagController,
                  decoration: InputDecoration(
                    labelText: 'Tag',
                    hintText: 'Enter tag',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  onSubmitted: (_) => controller.addTag(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: controller.addTag,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF00BF63),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => controller.tags.isEmpty
                ? const Text('No tags added yet')
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.tags.asMap().entries.map((entry) {
                      return _buildChip(entry.value, () {
                        controller.removeTag(entry.key);
                      });
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumSection(SolutionController controller) {
    return _buildSection(
      title: 'Premium Options',
      child: Column(
        children: [
          Obx(
            () => SwitchListTile(
              title: const Text('Premium Solution'),
              subtitle: const Text('Charge users to access this solution'),
              value: controller.isPremium.value,
              onChanged: (_) => controller.togglePremium(),
              activeColor: const Color(0xFF00BF63),
            ),
          ),
          Obx(
            () => controller.isPremium.value
                ? Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _buildTextField(
                      controller: controller.premiumPriceController,
                      label: 'Premium Price',
                      hint: 'Enter price in USD',
                      keyboardType: TextInputType.number,
                      required: true,
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool required = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  Widget _buildChip(String text, VoidCallback onDelete) {
    return Chip(
      label: Text(text),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: onDelete,
      backgroundColor: const Color(0xFF00BF63).withOpacity(0.1),
      labelStyle: const TextStyle(color: Color(0xFF00BF63)),
    );
  }

  Widget _buildStepCard(SolutionStep step, VoidCallback onDelete) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF00BF63),
          child: Text(
            step.stepNumber.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(step.description),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }

  /// Validate if a URL is a valid image URL
  bool _isValidImageUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || !['http', 'https'].contains(uri.scheme)) {
        return false;
      }

      final path = uri.path.toLowerCase();
      const allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
      return allowedExtensions.any((ext) => path.endsWith('.$ext')) ||
          path.contains(RegExp(r'\.(jpg|jpeg|png|gif|webp)(\?|$)'));
    } catch (e) {
      if (kDebugMode) {
        print('URL validation error: $e');
      }
      return false;
    }
  }
}
