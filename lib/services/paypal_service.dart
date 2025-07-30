// lib/services/paypal_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/payment.dart';

class PayPalService {
  // PayPal Configuration from environment variables
  static String get _clientId {
    final clientId = dotenv.env['PAYPAL_CLIENT_ID_SANDBOX'];
    if (clientId == null || clientId.isEmpty) {
      throw Exception(
          'PayPal Client ID not found in .env file. Please add PAYPAL_CLIENT_ID_SANDBOX to your .env file.');
    }
    return clientId;
  }

  static String get _secretKey {
    final secretKey = dotenv.env['PAYPAL_SECRET_SANDBOX'];
    if (secretKey == null || secretKey.isEmpty) {
      throw Exception(
          'PayPal Secret Key not found in .env file. Please add PAYPAL_SECRET_SANDBOX to your .env file.');
    }
    return secretKey;
  }

  static bool get _isProduction =>
      dotenv.env['PAYPAL_IS_PRODUCTION']?.toLowerCase() == 'true';

  static Future<PaymentTransaction?> makePayment({
    required PaymentItem item,
    required BuildContext context,
  }) async {
    try {
      // Validate PayPal configuration
      print(
          'Initializing PayPal with Client ID: ${_clientId.substring(0, 10)}...');
      print('PayPal Environment: ${_isProduction ? 'Production' : 'Sandbox'}');

      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PaypalCheckoutView(
            sandboxMode: !_isProduction,
            clientId: _clientId,
            secretKey: _secretKey,
            transactions: [
              {
                "amount": {
                  "total": item.price.toStringAsFixed(2),
                  "currency": item.currency,
                  "details": {
                    "subtotal": item.price.toStringAsFixed(2),
                    "shipping": "0",
                    "shipping_discount": "0"
                  }
                },
                "description": "Payment for ${item.name}",
                "payment_options": {
                  "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
                },
                "item_list": {
                  "items": [
                    {
                      "name": item.name,
                      "quantity": item.quantity,
                      "price": item.price.toStringAsFixed(2),
                      "currency": item.currency
                    }
                  ],
                }
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              print("PayPal payment successful: $params");
              Navigator.of(context).pop({'status': 'success', 'data': params});
            },
            onError: (error) {
              print("PayPal payment error: $error");
              Navigator.of(context)
                  .pop({'status': 'error', 'error': error.toString()});
            },
            onCancel: (params) {
              print("PayPal payment cancelled: $params");
              Navigator.of(context)
                  .pop({'status': 'cancelled', 'data': params});
            },
          ),
        ),
      );

      print("PayPal result: $result");

      if (result != null) {
        if (result['status'] == 'success') {
          final data = result['data'];
          return PaymentTransaction(
            transactionId:
                data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
            paymentId: data['id'] ?? '',
            payerId: data['payer']?['payer_info']?['payer_id'] ?? '',
            amount: item.price,
            currency: item.currency,
            status: 'completed',
            createdAt: DateTime.now(),
            additionalData: result,
          );
        } else if (result['status'] == 'error') {
          throw Exception('PayPal payment failed: ${result['error']}');
        } else if (result['status'] == 'cancelled') {
          throw Exception('Payment was cancelled by user');
        }
      }

      return null;
    } catch (e) {
      print('PayPal payment error: $e');
      rethrow; // Re-throw to let the controller handle it
    }
  }

  static String getCurrencyCode() => "USD";

  static String getEnvironmentUrl() {
    return _isProduction
        ? "https://api.paypal.com"
        : "https://api.sandbox.paypal.com";
  }

  static bool get isProduction => _isProduction;
  static bool get isSandbox => !_isProduction;
}
