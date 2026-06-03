part of 'checkout_cubit.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();  

  @override
  List<Object> get props => [];
}
class CheckoutInitial extends CheckoutState {}
