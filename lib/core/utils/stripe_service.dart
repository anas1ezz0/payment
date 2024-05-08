import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment/Features/data/models/ephemeral_key/ephemeral_key.dart';
import 'package:payment/Features/data/models/init_payment_sheet_input_model.dart';
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
      contentType: Headers.formUrlEncodedContentType,
      body: paymentIntentInputModel.toJson(),
    );
    var paymentModel = PaymentIntentModel.fromJson(response.data);
    return paymentModel;
  }

  Future initPaymentSheet(
      {required InitPaymentSheetInputModel initPaymentSheetInputModel}) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret:
            initPaymentSheetInputModel.paymentIntentClientSecret,
        customerEphemeralKeySecret:
            initPaymentSheetInputModel.customerEphemeralKeySecret,
        customerId: initPaymentSheetInputModel.customerId,
        merchantDisplayName: "Anas",
      ),
    );
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    var paymentIntenModel = await createPaymentIntent(paymentIntentInputModel);
    var ephemeralKeymodel = await createEphemeralKey(
        customerId: paymentIntentInputModel.customerId);
    var initPaymentSheetInputModel = InitPaymentSheetInputModel(
      paymentIntentClientSecret: paymentIntenModel.clientSecret!,
      customerId: paymentIntentInputModel.customerId,
      customerEphemeralKeySecret: ephemeralKeymodel.secret!,
    );
    await initPaymentSheet(
        initPaymentSheetInputModel: initPaymentSheetInputModel);
    await displayPaymentSheet();
  }

  Future<EphemeralKey> createEphemeralKey({required String customerId}) async {
    var response = await apiService.post(
      url: "https://api.stripe.com/v1/ephemeral_keys",
      token: ApiKeys.secretKey,
      contentType: Headers.formUrlEncodedContentType,
      body: {'customer': customerId},
      headers: {
        'Authorization': 'Bearer ${ApiKeys.secretKey}',
        'Stripe-Version': '2023-10-16',
      },
    );
    var ephemeralKey = EphemeralKey.fromJson(response.data);
    return ephemeralKey;
  }
}
