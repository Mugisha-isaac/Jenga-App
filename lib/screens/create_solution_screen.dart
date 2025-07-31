// lib/screens/create_solution_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../modules/solution_controller.dart';
import '../modules/auth_controller.dart';
import '../widgets/secure_image_picker_widget.dart';
import '../models/solution.dart';

class CreateSolutionScreen extends StatefulWidget {
  const CreateSolutionScreen({super.key});

  @override
  State<CreateSolutionScreen> createState() => _CreateSolutionScreenState();
}

class _CreateSolutionScreenState extends State<CreateSolutionScreen> {
  late SolutionController controller;
  bool _isInitialized = false;

  // Local text controllers for safer management
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _countryController;
  late TextEditingController _cityController;
  late TextEditingController _materialController;
  late TextEditingController _tagController;
  late TextEditingController _stepDescriptionController;
  late TextEditingController _premiumPriceController;

  @override
  void initState() {
    super.initState();
    _initializeLocalControllers();
    _initializeController();
  }

  void _initializeLocalControllers() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _categoryController = TextEditingController();
    _countryController = TextEditingController();
    _cityController = TextEditingController();
    _materialController = TextEditingController();
    _tagController = TextEditingController();
    _stepDescriptionController = TextEditingController();
    _premiumPriceController = TextEditingController();
  }

  void _initializeController() {
    Get.put(AuthController());

    // Use a more robust controller management approach
    try {
      controller = Get.find<SolutionController>();
    } catch (e) {
      controller = Get.put(SolutionController(), permanent: true);
    }

    // Sync local controllers with GetX controller
    _syncControllersWithGetX();

    // Handle edit mode setup after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleEditMode();
    });
  }

  void _syncControllersWithGetX() {
    // Initial sync from GetX controller to local controllers safely
    try {
      _titleController.text = controller.titleController.text;
      _descriptionController.text = controller.descriptionController.text;
      _categoryController.text = controller.categoryController.text;
      _countryController.text = controller.countryController.text;
      _cityController.text = controller.cityController.text;
      _materialController.text = controller.materialController.text;
      _tagController.text = controller.tagController.text;
      _stepDescriptionController.text =
          controller.stepDescriptionController.text;
      _premiumPriceController.text = controller.premiumPriceController.text;
    } catch (e) {
      print('Error syncing controllers: $e');
    }

    // Listen to changes and sync back to GetX controller (with safety checks)
    _titleController.addListener(() {
      _safeSync(() => controller.titleController.text = _titleController.text);
    });

    _descriptionController.addListener(() {
      _safeSync(() =>
          controller.descriptionController.text = _descriptionController.text);
    });

    _countryController.addListener(() {
      _safeSync(
          () => controller.countryController.text = _countryController.text);
    });

    _cityController.addListener(() {
      _safeSync(() => controller.cityController.text = _cityController.text);
    });

    _premiumPriceController.addListener(() {
      _safeSync(() => controller.premiumPriceController.text =
          _premiumPriceController.text);
    });
  }

  void _safeSync(VoidCallback syncOperation) {
    if (!mounted) return;

    try {
      syncOperation();
    } catch (e) {
      // Silently ignore disposal errors during sync
      if (!e.toString().contains('disposed')) {
        print('Sync error: $e');
      }
    }
  }

  void _handleEditMode() {
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map) {
      final solution = arguments['solution'] as Solution?;
      final isEdit = arguments['isEdit'] as bool? ?? false;

      if (isEdit && solution != null) {
        // Immediately sync edit mode data to local controllers
        _syncEditModeData(solution);

        // Set the controller edit mode directly without validation
        try {
          controller.isEditMode.value = true;
          controller.editingSolution.value = solution;

          // Sync data to GetX controller as well
          controller.titleController.text = solution.title;
          controller.descriptionController.text = solution.description;
          controller.countryController.text = solution.country;
          controller.cityController.text = solution.city;
          controller.selectedCategory.value = solution.category;

          if (solution.isPremium && solution.premiumPrice != null) {
            controller.isPremium.value = true;
            controller.premiumPriceController.text =
                solution.premiumPrice.toString();
          } else {
            controller.isPremium.value = false;
          }

          // Sync materials, tags, steps
          controller.materials.clear();
          controller.materials.addAll(solution.materials);

          controller.tags.clear();
          controller.tags.addAll(solution.tags);

          controller.steps.clear();
          controller.steps.addAll(solution.steps);

          // Sync images
          controller.imageUrls.clear();
          controller.imageUrls
              .addAll(solution.images.map((img) => img.url).toList());

          setState(() {
            _isInitialized = true;
          });
        } catch (e) {
          print('Error setting edit mode: $e');
          setState(() {
            _isInitialized = true;
          });
        }
      } else {
        setState(() {
          _isInitialized = true;
        });
      }
    } else {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  void _syncEditModeData(Solution solution) {
    try {
      // Sync basic info
      _titleController.text = solution.title;
      _descriptionController.text = solution.description;
      _countryController.text = solution.country;
      _cityController.text = solution.city;

      // Sync premium info
      if (solution.isPremium && solution.premiumPrice != null) {
        _premiumPriceController.text = solution.premiumPrice.toString();
      } else {
        _premiumPriceController.clear();
      }

      // Clear other controllers for fresh data
      _materialController.clear();
      _tagController.clear();
      _stepDescriptionController.clear();

      print('Edit mode data synced successfully to local controllers');
    } catch (e) {
      print('Error syncing edit mode data: $e');
    }
  }

  @override
  void dispose() {
    // Dispose local controllers safely
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _materialController.dispose();
    _tagController.dispose();
    _stepDescriptionController.dispose();
    _premiumPriceController.dispose();

    // Clear any edit mode if we're leaving
    try {
      if (controller.isEditMode.value) {
        controller.exitEditMode();
      }
    } catch (e) {
      print('Error exiting edit mode: $e');
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.isEditMode.value ? 'Edit Solution' : 'Create Solution',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.createSolution,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            controller.isEditMode.value ? 'Update Solution' : 'Create Solution',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
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
            controller: _titleController,
            label: 'Title',
            hint: 'Enter solution title',
            required: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _descriptionController,
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
              controller: _countryController,
              label: 'Country',
              hint: 'Country',
              required: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTextField(
              controller: _cityController,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
            fillColor: colorScheme.surface,
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
                        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
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
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Theme.of(context).colorScheme.surface,
                              child: Icon(
                                Icons.error,
                                color: Theme.of(context).colorScheme.error,
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
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Theme.of(context).colorScheme.onError,
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
                    fillColor: Theme.of(context).colorScheme.surface,
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
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                  controller: _materialController,
                  decoration: InputDecoration(
                    labelText: 'Material',
                    hintText: 'Enter material name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  onSubmitted: (_) => _addMaterial(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _addMaterial,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
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

  void _addMaterial() {
    if (_materialController.text.trim().isNotEmpty) {
      controller.materials.add(_materialController.text.trim());
      _materialController.clear();
    }
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
                  controller: _stepDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Step Description',
                    hintText: 'Describe the step',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  maxLines: 2,
                  onSubmitted: (_) => _addStep(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _addStep,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
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

  void _addStep() {
    if (_stepDescriptionController.text.trim().isNotEmpty) {
      final step = SolutionStep(
        stepNumber: controller.steps.length + 1,
        description: _stepDescriptionController.text.trim(),
      );
      controller.steps.add(step);
      _stepDescriptionController.clear();
    }
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
                  controller: _tagController,
                  decoration: InputDecoration(
                    labelText: 'Tag',
                    hintText: 'Enter tag',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  onSubmitted: (_) => _addTag(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _addTag,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
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

  void _addTag() {
    if (_tagController.text.trim().isNotEmpty) {
      controller.tags.add(_tagController.text.trim());
      _tagController.clear();
    }
  }

  Widget _buildPremiumSection(SolutionController controller) {
    return _buildSection(
      title: 'Premium Options',
      child: Column(
        children: [
          Obx(
            () => SwitchListTile(
              title: Text('Premium Solution', style: Theme.of(context).textTheme.bodyLarge),
              subtitle: Text('Charge users to access this solution', style: Theme.of(context).textTheme.bodySmall),
              value: controller.isPremium.value,
              onChanged: (_) => controller.togglePremium(),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          Obx(
            () => controller.isPremium.value
                ? Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _buildTextField(
                      controller: _premiumPriceController,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
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
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: colorScheme.surface,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  Widget _buildChip(String text, VoidCallback onDelete) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Chip(
      label: Text(text),
      deleteIcon: Icon(Icons.close, size: 18, color: colorScheme.onPrimary),
      onDeleted: onDelete,
      backgroundColor: colorScheme.primary.withOpacity(0.1),
      labelStyle: TextStyle(color: colorScheme.primary),
    );
  }

  Widget _buildStepCard(SolutionStep step, VoidCallback onDelete) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: colorScheme.surface,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary,
          child: Text(
            step.stepNumber.toString(),
            style: TextStyle(color: colorScheme.onPrimary),
          ),
        ),
        title: Text(step.description, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: colorScheme.error),
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
