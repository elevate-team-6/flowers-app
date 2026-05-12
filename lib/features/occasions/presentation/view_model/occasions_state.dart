import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flowers_app/features/occasions/domain/entities/product_entity.dart';

class OccasionsState {
  BaseState<List<OccasionEntity>> occasionsState =
      BaseState<List<OccasionEntity>>(isLoading: false);
  BaseState<List<ProductEntity>> productsState = BaseState<List<ProductEntity>>(
    isLoading: false,
  );

  OccasionsState({
    BaseState<List<OccasionEntity>>? occasionsState,
    BaseState<List<ProductEntity>>? productsState,
  }) {
    this.occasionsState =
        occasionsState ?? BaseState<List<OccasionEntity>>(isLoading: false);
    this.productsState =
        productsState ?? BaseState<List<ProductEntity>>(isLoading: true);
  }

  OccasionsState copyWith({
    BaseState<List<OccasionEntity>>? occasionsStateParam,
    BaseState<List<ProductEntity>>? productsStateParam,
  }) {
    return OccasionsState(
      occasionsState: occasionsStateParam ?? occasionsState,
      productsState: productsStateParam ?? productsState,
    );
  }
}
