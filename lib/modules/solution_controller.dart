// lib/controllers/solution_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/solution.dart';
import '../repositories/solution_repository.dart';
import '../modules/auth_controller.dart';

class SolutionController extends GetxController {
  final SolutionRepository _solutionRepository = Get.find<SolutionRepository>();

  // Form Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final materialController = TextEditingController();
  final tagController = TextEditingController();
  final stepDescriptionController = TextEditingController();
  final premiumPriceController = TextEditingController();

  // Observable lists and variables
  final RxList<String> materials = <String>[].obs;
  final RxList<String> tags = <String>[].obs;
  final RxList<SolutionStep> steps = <SolutionStep>[].obs;
  final RxList<String> imageUrls = <String>[].obs;
  final RxBool isPremium = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isUploadingImages = false.obs;
  final RxString selectedCategory = ''.obs;

  // Predefined categories
  final List<String> categories = [
    'Agriculture',
    'Technology',
    'Healthcare',
    'Education',
    'Environment',
    'Business',
    'Social',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    // Set default values
    countryController.text = 'Rwanda';
    cityController.text = 'Kigali';
  }

  @override
  void onClose() {
    // Dispose controllers
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    countryController.dispose();
    cityController.dispose();
    materialController.dispose();
    tagController.dispose();
    stepDescriptionController.dispose();
    premiumPriceController.dispose();
    super.onClose();
  }

  // Add material to the list
  void addMaterial() {
    if (materialController.text.trim().isNotEmpty) {
      materials.add(materialController.text.trim());
      materialController.clear();
    }
  }

  // Remove material from the list
  void removeMaterial(int index) {
    materials.removeAt(index);
  }

  // Add tag to the list
  void addTag() {
    if (tagController.text.trim().isNotEmpty) {
      tags.add(tagController.text.trim());
      tagController.clear();
    }
  }

  // Remove tag from the list
  void removeTag(int index) {
    tags.removeAt(index);
  }

  // Add step to the list
  void addStep() {
    if (stepDescriptionController.text.trim().isNotEmpty) {
      steps.add(
        SolutionStep(
          stepNumber: steps.length + 1,
          description: stepDescriptionController.text.trim(),
        ),
      );
      stepDescriptionController.clear();
    }
  }

  // Remove step from the list
  void removeStep(int index) {
    steps.removeAt(index);
    // Renumber steps
    for (int i = 0; i < steps.length; i++) {
      steps[i] = SolutionStep(
        stepNumber: i + 1,
        description: steps[i].description,
      );
    }
  }

  // Add image URL from Cloudinary upload
  void addImageUrlFromUpload(String url) {
    if (url.trim().isNotEmpty) {
      imageUrls.add(url.trim());
    }
  }

  // Start image upload
  void startImageUpload() {
    isUploadingImages.value = true;
  }

  // End image upload
  void endImageUpload() {
    isUploadingImages.value = false;
  }

  // Add image URL
  void addImageUrl(String url) {
    if (url.trim().isNotEmpty) {
      imageUrls.add(url.trim());
    }
  }

  // Remove image URL
  void removeImageUrl(int index) {
    imageUrls.removeAt(index);
  }

  // Validate form
  bool validateForm() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Title is required');
      return false;
    }
    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Description is required');
      return false;
    }
    if (selectedCategory.value.isEmpty) {
      Get.snackbar('Error', 'Category is required');
      return false;
    }
    if (materials.isEmpty) {
      Get.snackbar('Error', 'At least one material is required');
      return false;
    }
    if (steps.isEmpty) {
      Get.snackbar('Error', 'At least one step is required');
      return false;
    }
    if (tags.isEmpty) {
      Get.snackbar('Error', 'At least one tag is required');
      return false;
    }
    if (isPremium.value && premiumPriceController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Premium price is required for premium solutions');
      return false;
    }
    return true;
  }

  // Create solution
  Future<void> createSolution() async {
    if (!validateForm()) return;

    isLoading.value = true;

    try {
      final solution = Solution(
        solutionId: _generateSolutionId(),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory.value,
        userId:
            Get.find<AuthController>().currentUser.value?.uid ??
            'user123', // Assuming you have AuthController
        country: countryController.text.trim(),
        city: cityController.text.trim(),
        images: imageUrls.map((url) => SolutionImage(url: url)).toList(),
        materials: materials.toList(),
        steps: steps.toList(),
        tags: tags.toList(),
        metrics: SolutionMetrics(), // Default metrics (all zeros)
        premiumPrice: isPremium.value
            ? double.tryParse(premiumPriceController.text)
            : null,
        isPremium: isPremium.value,
        featured: false, // Default to false, can be changed by admin
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _solutionRepository.createSolution(solution);

      Get.snackbar(
        'Success',
        'Solution created successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear form
      clearForm();

      // Navigate back or to solutions list
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create solution: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Generate unique solution ID
  String _generateSolutionId() {
    return 'sol_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (9000 * (DateTime.now().millisecond / 1000))).round()}';
  }

  // Clear form
  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    categoryController.clear();
    countryController.text = 'Rwanda';
    cityController.text = 'Kigali';
    materialController.clear();
    tagController.clear();
    stepDescriptionController.clear();
    premiumPriceController.clear();

    materials.clear();
    tags.clear();
    steps.clear();
    imageUrls.clear();
    isPremium.value = false;
    isUploadingImages.value = false;
    selectedCategory.value = '';
  }

  // Set category
  void setCategory(String category) {
    selectedCategory.value = category;
  }

  // Toggle premium status
  void togglePremium() {
    isPremium.value = !isPremium.value;
    if (!isPremium.value) {
      premiumPriceController.clear();
    }
  }
}
