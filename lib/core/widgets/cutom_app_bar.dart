import 'package:flutter/material.dart';
import 'package:payment/Features/checkout/presentation/views/my_cart_view.dart';
import 'package:payment/core/utils/styles.dart';

AppBar buildAppBar({final String? title, context}) {
  return AppBar(
    leading: Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MyCartView();
          }));
        },
        child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
      ),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    centerTitle: true,
    title: Text(
      title ?? '',
      textAlign: TextAlign.center,
      style: Styles.style25,
    ),
  );
}
