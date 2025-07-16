// lib/screens/payment_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/solution.dart';
import '../modules/payment_controller.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());
    final Solution solution = Get.arguments as Solution;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSolutionInfo(solution),
            const SizedBox(height: 32),
            _buildPaymentMethods(controller),
            const SizedBox(height: 32),
            _buildPaymentForm(controller),
            const SizedBox(height: 32),
            _buildPayButton(controller, solution),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionInfo(Solution solution) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Premium Solution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green.shade100,
                  image: solution.images.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(solution.images.first.url),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: solution.images.isEmpty
                    ? const Icon(
                        Icons.lightbulb_outlined,
                        color: Colors.green,
                        size: 30,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      solution.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      solution.category,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Price:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                '\$${solution.premiumPrice?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods(PaymentController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Column(
              children: [
                _buildPaymentMethodOption(
                  controller,
                  'card',
                  'Credit/Debit Card',
                  Icons.credit_card,
                ),
                const SizedBox(height: 12),
                _buildPaymentMethodOption(
                  controller,
                  'paypal',
                  'PayPal',
                  Icons.payment,
                ),
                const SizedBox(height: 12),
                _buildPaymentMethodOption(
                  controller,
                  'mobile',
                  'Mobile Money',
                  Icons.phone_android,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption(
    PaymentController controller,
    String value,
    String title,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () => controller.selectPaymentMethod(value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: controller.selectedPaymentMethod.value == value
                ? Colors.green
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
          color: controller.selectedPaymentMethod.value == value
              ? Colors.green.shade50
              : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: controller.selectedPaymentMethod.value == value
                  ? Colors.green
                  : Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: controller.selectedPaymentMethod.value == value
                    ? Colors.green
                    : Colors.black87,
              ),
            ),
            const Spacer(),
            if (controller.selectedPaymentMethod.value == value)
              const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm(PaymentController controller) {
    return Obx(() {
      if (controller.selectedPaymentMethod.value == 'card') {
        return _buildCardForm(controller);
      } else if (controller.selectedPaymentMethod.value == 'paypal') {
        return _buildPayPalForm();
      } else {
        return _buildMobileMoneyForm();
      }
    });
  }

  Widget _buildCardForm(PaymentController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Card Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller.cardHolderNameController,
            decoration: const InputDecoration(
              labelText: 'Card Holder Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller.cardNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
              hintText: '**** **** **** ****',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.expiryDateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date',
                    border: OutlineInputBorder(),
                    hintText: 'MM/YY',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: controller.cvvController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(),
                    hintText: '***',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPayPalForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(Icons.payment, size: 48, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'You will be redirected to PayPal to complete your payment',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileMoneyForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(Icons.phone_android, size: 48, color: Colors.orange),
          SizedBox(height: 16),
          Text(
            'You will receive a payment prompt on your mobile device',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton(PaymentController controller, Solution solution) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: controller.isProcessingPayment.value
              ? null
              : () async {
                  if (controller.validateForm()) {
                    final success = await controller.processPremiumPayment(
                      solution,
                    );
                    if (success) {
                      Get.back(result: true);
                    }
                  } else {
                    Get.snackbar(
                      'Error',
                      'Please fill in all required fields',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: controller.isProcessingPayment.value
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Processing Payment...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Text(
                  'Pay \$${solution.premiumPrice?.toStringAsFixed(2) ?? '0.00'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
