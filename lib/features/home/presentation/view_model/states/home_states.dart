import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flowers_app/features/occasions/domain/entities/product_entity.dart';
import 'package:flutter/foundation.dart';

class HomeStates extends Equatable {
  final BaseState<List<OccasionEntity>> occasionsState;
  final BaseState<List<ProductEntity>> bsetSelerState;
  final BaseState<List<CategoryEntity>> categoreyState;

  const HomeStates({
    this.occasionsState = const BaseState(),
    this.bsetSelerState = const BaseState(),
    this.categoreyState = const BaseState(),
  });
  HomeStates copyWith({
    BaseState<List<OccasionEntity>>? occasionsStateParam,
    BaseState<List<ProductEntity>>? bsetSelerStateParam,
    BaseState<List<CategoryEntity>>? categoreyStateParam,
  }) => HomeStates(
    occasionsState: occasionsStateParam ?? occasionsState,
    bsetSelerState: bsetSelerStateParam ?? bsetSelerState,
    categoreyState: categoreyStateParam ?? categoreyState,
  );

  @override
  List<Object?> get props => [occasionsState, bsetSelerState, categoreyState];
}
