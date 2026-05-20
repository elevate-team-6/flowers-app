import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/categories/domain/entities/category_entity.dart';

import '../../../../../config/base_state/base_state.dart';
import '../../../../../core/entities/product_entity.dart';
import '../../../../occasions/domain/entities/occasion_entity.dart';

class HomeStates extends Equatable {
  final BaseState<List<OccasionEntity>> occasionsState;
  final BaseState<List<ProductEntity>> bestSellerState;
  final BaseState<List<CategoryEntity>> categoryState;

  const HomeStates({
    this.occasionsState = const BaseState(),
    this.bestSellerState = const BaseState(),
    this.categoryState = const BaseState(),
  });
  HomeStates copyWith({
    BaseState<List<OccasionEntity>>? occasionsStateParam,
    BaseState<List<ProductEntity>>? bestSellerStateParam,
    BaseState<List<CategoryEntity>>? categoryStateParam,
  }) => HomeStates(
    occasionsState: occasionsStateParam ?? occasionsState,
    bestSellerState: bestSellerStateParam ?? bestSellerState,
    categoryState: categoryStateParam ?? categoryState,
  );

  @override
  List<Object?> get props => [occasionsState, bestSellerState, categoryState];
}
