// lib/modules/payment_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/paid_solution.dart';
import '../models/solution.dart';
import '../repositories/paid_solution_repository.dart';
import '../modules/auth_controller.dart';

class PaymentController extends GetxController {
  final PaidSolutionRepository _paidSolutionRepository =
      Get.find<PaidSolutionRepository>();
  late final AuthController _authController;

  // Form Controllers
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();
  final cardHolderNameController = TextEditingController();

  // Observable variables
  final RxBool isProcessingPayment = false.obs;
  final RxString selectedPaymentMethod = 'card'.obs;
  final RxList<PaidSolution> userPaidSolutions = <PaidSolution>[].obs;

  @override
  void onInit() {
    super.onInit();
    _authController = Get.find<AuthController>();
    loadUserPaidSolutions();
  }

  @override
  void onClose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    cardHolderNameController.dispose();
    super.onClose();
  }

  void loadUserPaidSolutions() async {
    final userId = _authController.currentUser.value?.uid;
    if (userId != null) {
      try {
        final paidSolutions = await _paidSolutionRepository
            .getPaidSolutionsByUser(userId);
        userPaidSolutions.assignAll(paidSolutions);
      } catch (e) {
        Get.snackbar('Error', 'Failed to load paid solutions');
      }
    }
  }

  bool hasUserPaidForSolution(String solutionId) {
    return userPaidSolutions.any(
      (paidSolution) => paidSolution.solutionId == solutionId,
    );
  }

  Future<bool> processPremiumPayment(Solution solution) async {
    final userId = _authController.currentUser.value?.uid;
    if (userId == null) {
      Get.snackbar('Error', 'Please login to purchase premium solutions');
      return false;
    }

    if (hasUserPaidForSolution(solution.solutionId)) {
      Get.snackbar('Info', 'You have already purchased this solution');
      return true;
    }

    isProcessingPayment.value = true;

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Generate transaction ID
      final transactionId = 'txn_${DateTime.now().millisecondsSinceEpoch}';

      // Create paid solution record
      final paidSolution = PaidSolution(
        id: '${userId}_${solution.solutionId}',
        solutionId: solution.solutionId,
        userId: userId,
        purchaseDate: DateTime.now(),
        amountPaid: solution.premiumPrice ?? 0.0,
        paymentMethod: selectedPaymentMethod.value,
        transactionId: transactionId,
      );

      await _paidSolutionRepository.createPaidSolution(paidSolution);
      userPaidSolutions.add(paidSolution);

      Get.snackbar(
        'Success',
        'Payment successful! You can now access this premium solution.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      _clearForm();
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Payment failed. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isProcessingPayment.value = false;
    }
  }

  void _clearForm() {
    cardNumberController.clear();
    expiryDateController.clear();
    cvvController.clear();
    cardHolderNameController.clear();
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  bool validateForm() {
    if (selectedPaymentMethod.value == 'card') {
      return cardNumberController.text.isNotEmpty &&
          expiryDateController.text.isNotEmpty &&
          cvvController.text.isNotEmpty &&
          cardHolderNameController.text.isNotEmpty;
    }
    return true;
  }
}
