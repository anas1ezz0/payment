import 'package:flutter/material.dart';
import 'package:payment/Features/checkout/presentation/views/widgets/my_cart_view_body.dart';
import 'package:payment/core/utils/styles.dart';

class MyCartView extends StatelessWidget {
  const MyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: Styles.style25,
        ),
        leading: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        centerTitle: true,
      ),
      body: const MyCartViewBody(),
    );
  }
}
