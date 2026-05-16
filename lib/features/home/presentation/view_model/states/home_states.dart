import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/core/enities/product_entity.dart';
import 'package:flowers_app/features/categories/domain/entities/category_entity.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';

class HomeStates extends Equatable {
  final BaseState<List<OccasionEntity>> occasionsState;
  final BaseState<List<ProductEntity>> bsetSelerState;
  final BaseState<CategoriesEntity> categoreyState;

  const HomeStates({
    this.occasionsState = const BaseState(),
    this.bsetSelerState = const BaseState(),
    this.categoreyState = const BaseState(),
  });
  HomeStates copyWith({
    BaseState<List<OccasionEntity>>? occasionsStateParam,
    BaseState<List<ProductEntity>>? bsetSelerStateParam,
    BaseState<CategoriesEntity>? categoreyStateParam,
  }) => HomeStates(
    occasionsState: occasionsStateParam ?? occasionsState,
    bsetSelerState: bsetSelerStateParam ?? bsetSelerState,
    categoreyState: categoreyStateParam ?? categoreyState,
  );

  @override
  List<Object?> get props => [occasionsState, bsetSelerState, categoreyState];
}
