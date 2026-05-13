import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/home/best_seller/domain/entities/product_entity.dart';

class BestSellerState extends Equatable {
  final BaseState<List<ProductEntity>> bestSellerState;
  const BestSellerState({this.bestSellerState = const BaseState()});
  BestSellerState copyWith({BaseState<List<ProductEntity>>? bestSellerState}) {
    return BestSellerState(
      bestSellerState: bestSellerState ?? this.bestSellerState,
    );
  }

  @override
  List<Object?> get props => [bestSellerState];
}
