import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';

class HomeStates extends Equatable {
  final BaseState<List<OccasionEntity>> occasionsState;
  final BaseState<BestSellerEntity> bsetSelerState;

  const HomeStates({
    this.occasionsState = const BaseState(),
    this.bsetSelerState = const BaseState(),
  });
  HomeStates copyWith({
    BaseState<List<OccasionEntity>>? occasionsStateParam,
    BaseState<BestSellerEntity>? bsetSelerStateParam,
  }) => HomeStates(
    occasionsState: occasionsStateParam ?? occasionsState,
    bsetSelerState: bsetSelerStateParam ?? bsetSelerState,
  );

  @override
  List<Object?> get props => [occasionsState, bsetSelerState];
}
