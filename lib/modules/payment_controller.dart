// lib/modules/payment_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/paid_solution.dart';
import '../models/solution.dart';
import '../models/payment.dart';
import '../repositories/paid_solution_repository.dart';
import '../modules/auth_controller.dart';
import '../services/paypal_service.dart';
import '../screens/payment_success_screen.dart';

class PaymentController extends GetxController {
  final PaidSolutionRepository _paidSolutionRepository =
      Get.find<PaidSolutionRepository>();
  late final AuthController _authController;

  // Observable variables
  final RxBool isProcessingPayment = false.obs;
  final RxList<PaidSolution> userPaidSolutions = <PaidSolution>[].obs;

  @override
  void onInit() {
    super.onInit();
    _authController = Get.find<AuthController>();
    loadUserPaidSolutions();
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

  Future<bool> processPremiumPayment(Solution solution, BuildContext context) async {
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
      // Create PayPal payment item
      final paymentItem = PaymentItem(
        name: solution.title,
        price: solution.premiumPrice ?? 0.0,
        quantity: 1,
        currency: 'USD',
      );

      // Process PayPal payment
      final paymentTransaction = await PayPalService.makePayment(
        item: paymentItem,
        context: context,
      );

      if (paymentTransaction != null) {
        // Create paid solution record
        final paidSolution = PaidSolution(
          id: '${userId}_${solution.solutionId}',
          solutionId: solution.solutionId,
          userId: userId,
          purchaseDate: paymentTransaction.createdAt,
          amountPaid: paymentTransaction.amount,
          paymentMethod: 'paypal',
          transactionId: paymentTransaction.transactionId,
        );

        await _paidSolutionRepository.createPaidSolution(paidSolution);
        userPaidSolutions.add(paidSolution);

        // Navigate to success screen
        await Get.to(
          () => const PaymentSuccessScreen(),
          arguments: paymentTransaction,
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 300),
        );

        return true;
      } else {
        Get.snackbar(
          'Error',
          'Payment was cancelled or failed. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return false;
      }
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
}
