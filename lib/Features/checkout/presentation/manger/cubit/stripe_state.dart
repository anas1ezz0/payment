part of 'stripe_cubit.dart';

@immutable
sealed class StripeState {}

final class StripeInitial extends StripeState {}

final class StripeLoading extends StripeState {}

final class StripeSuccess extends StripeState {}

final class StripeError extends StripeState {
  final String errMessage;
  StripeError({required this.errMessage});
}
