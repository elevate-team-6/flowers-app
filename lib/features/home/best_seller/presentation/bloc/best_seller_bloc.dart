import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'best_seller_event.dart';
part 'best_seller_state.dart';

class BestSellerBloc extends Bloc<BestSellerEvent, BestSellerState> {
  BestSellerBloc() : super(BestSellerInitial()) {
    on<BestSellerEvent>((event, emit) {
    });
  }
}
