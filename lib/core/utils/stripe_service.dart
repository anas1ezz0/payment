import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment/Features/data/models/payment_intent_input_model.dart';
import 'package:payment/Features/data/models/payment_model/payment_model.dart';
import 'package:payment/core/utils/api_keys.dart';
import 'package:payment/core/utils/api_service.dart';

class StripeService {
  final ApiService apiService = ApiService();
  Future<PaymentIntentModel> createPaymentIntent(
      PaymentIntentInputModel paymentIntentInputModel) async {
    var response = await apiService.post(
      url: "https://api.stripe.com/v1/payment_intents",
      token: ApiKeys.secretKey,
      body: paymentIntentInputModel.toJson(),
    );
    var paymentModel = PaymentIntentModel.fromJson(response.data);
    return paymentModel;
  }

  Future initPaymentSheet({required String paymentIntentClientSecret}) async {
    Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: "Anas",
      ),
    );
  }

  Future displayPaymentSheet() async {
    Stripe.instance.presentPaymentSheet();
  }

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    var paymentIntenModel = await createPaymentIntent(paymentIntentInputModel);
    await initPaymentSheet(
        paymentIntentClientSecret: paymentIntenModel.clientSecret!);
    await displayPaymentSheet();
  }
}
