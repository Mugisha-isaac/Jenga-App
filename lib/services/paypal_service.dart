// lib/services/paypal_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/payment.dart';

class PayPalService {
  // PayPal Configuration from environment variables
  static String get _clientId => dotenv.env['PAYPAL_CLIENT_ID_SANDBOX'] ?? 
      "AeHcU3n0Po4ImI4ByzFwOKZ-L8qNjmBJsAsQnQqegDJhsP7M_SkUfXqjCVa8se4RaGTgaagNJ8-dGVMp";
  
  static String get _secretKey => dotenv.env['PAYPAL_SECRET_SANDBOX'] ?? 
      "ELQYpHspP6Jv1RNGBpT4nM8Uo8hZ8HhXy4Iu4kLJKpR9QJtHqHvPRuJ2KqZxY4Y";
  
  static bool get _isProduction => dotenv.env['PAYPAL_IS_PRODUCTION']?.toLowerCase() == 'true';

  static Future<PaymentTransaction?> makePayment({
    required PaymentItem item,
    required BuildContext context,
  }) async {
    try {
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
              Navigator.of(context).pop({
                'status': 'success',
                'data': params
              });
            },
            onError: (error) {
              print("PayPal payment error: $error");
              Navigator.of(context).pop({
                'status': 'error',
                'error': error
              });
            },
            onCancel: (params) {
              print("PayPal payment cancelled: $params");
              Navigator.of(context).pop({
                'status': 'cancelled',
                'data': params
              });
            },
          ),
        ),
      );

      if (result != null && result['status'] == 'success') {
        final data = result['data'];
        return PaymentTransaction(
          transactionId: data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
          paymentId: data['id'] ?? '',
          payerId: data['payer']?['payer_info']?['payer_id'] ?? '',
          amount: item.price,
          currency: item.currency,
          status: 'completed',
          createdAt: DateTime.now(),
          additionalData: result,
        );
      }
      
      return null;
    } catch (e) {
      print('PayPal payment error: $e');
      return null;
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
