import 'package:dartz/dartz.dart';
import 'package:payment/Features/data/models/payment_intent_input_model.dart';
import 'package:payment/Features/data/repos/check_out_repo.dart';
import 'package:payment/core/errors/failure.dart';
import 'package:payment/core/utils/stripe_service.dart';

class CheckOutRepoImpl extends CheckOutRepo {
  final StripeService stripeService = StripeService();

  @override
  Future<Either<Failure, void>> makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    try {
      await stripeService.makePayment(
          paymentIntentInputModel: paymentIntentInputModel);
      return right(null);
    } catch (e) {
      print(e.toString());
      return left(ServerFailure(errMessage: e.toString()));
    }
  }
}
