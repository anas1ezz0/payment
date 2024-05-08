import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:payment/Features/checkout/presentation/manger/cubit/stripe_cubit.dart';
import 'package:payment/Features/checkout/presentation/views/thank_you_view.dart';
import 'package:payment/Features/data/models/amount_model/amount_model.dart';
import 'package:payment/Features/data/models/amount_model/details.dart';
import 'package:payment/Features/data/models/items_list_model/item.dart';
import 'package:payment/Features/data/models/items_list_model/items_list_model.dart';
import 'package:payment/core/utils/api_keys.dart';
import 'package:payment/core/widgets/custom_button.dart';

class CustomBottonBlocConsumer extends StatelessWidget {
  const CustomBottonBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StripeCubit, StripeState>(
      listener: (context, state) {
        if (state is StripeSuccess) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return const ThankYouView();
          }));
        }
        if (state is StripeError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errMessage),
          ));
        }
      },
      builder: (context, state) {
        return CustomButton(
          onTap: () {
            // PaymentIntentInputModel paymentIntentInputModel =
            //     PaymentIntentInputModel(
            //   amount: '100',
            //   currency: 'USD',
            //   customerId: 'cus_Q3V416diL6SRym',
            // );
            // BlocProvider.of<StripeCubit>(context)
            //     .makePayment(paymentIntentInputModel: paymentIntentInputModel);
            var transaction = getTransaction();
            exceutePaypal(context, transaction);
          },
          isLoading: state is StripeLoading ? true : false,
          text: 'Continue',
        );
      },
    );
  }

  void exceutePaypal(BuildContext context,
      ({AmountModel amount, ItemsListModel itemsList}) transaction) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: true,
          clientId: ApiKeys.clientId,
          secretKey: ApiKeys.secretKeyPaypal,
          transactions: [
            {
              "amount": transaction.amount.toJson(),
              "description": "The payment transaction description.",
              "item_list": transaction.itemsList.toJson()
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            log("onSuccess: $params");
            Navigator.pop(context);
          },
          onError: (error) {
            log("onError: $error");
            Navigator.pop(context);
          },
          onCancel: () {
            log('cancelled:');
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

({AmountModel amount, ItemsListModel itemsList}) getTransaction() {
  var amount = AmountModel(
    total: "100",
    currency: "USD",
    details: Details(
      subtotal: "100",
      shipping: "0",
      shippingDiscount: 0,
    ),
  );
  List<Item> items = [
    Item(name: "Apple", quantity: 10, price: "4", currency: "USD"),
    Item(name: "Pineapple", quantity: 12, price: "5", currency: "USD"),
  ];

  var itemsList = ItemsListModel(items: items);

  return (amount: amount, itemsList: itemsList);
}
