import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';

class OccasionsState extends Equatable {
  final BaseState<List<OccasionEntity>> occasionsState;
  final BaseState<List<ProductEntity>> productsState;

  OccasionsState({
    BaseState<List<OccasionEntity>>? occasionsState,
    BaseState<List<ProductEntity>>? productsState,
  }) : occasionsState =
           occasionsState ?? BaseState<List<OccasionEntity>>(isLoading: false),
       productsState =
           productsState ?? BaseState<List<ProductEntity>>(isLoading: true);

  OccasionsState copyWith({
    BaseState<List<OccasionEntity>>? occasionsStateParam,
    BaseState<List<ProductEntity>>? productsStateParam,
  }) {
    return OccasionsState(
      occasionsState: occasionsStateParam ?? occasionsState,
      productsState: productsStateParam ?? productsState,
    );
  }

  @override
  List<Object?> get props => [occasionsState, productsState];
}
