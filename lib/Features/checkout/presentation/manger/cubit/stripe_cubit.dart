import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:payment/Features/data/models/payment_intent_input_model.dart';
import 'package:payment/Features/data/repos/check_out_repo.dart';

part 'stripe_state.dart';

class StripeCubit extends Cubit<StripeState> {
  StripeCubit(this.checkOutRepo) : super(StripeInitial());

  final CheckOutRepo checkOutRepo;

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    emit(StripeLoading());

    var data = await checkOutRepo.makePayment(
        paymentIntentInputModel: paymentIntentInputModel);
    data.fold(
      (l) => emit(
        StripeError(errMessage: l.errMessage),
      ),
      (r) => emit(
        StripeSuccess(),
      ),
    );
  }

  @override
  void onChange(Change<StripeState> change) {
    print(change.toString());
    super.onChange(change);
  }
}
