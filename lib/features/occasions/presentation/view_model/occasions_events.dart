import 'package:equatable/equatable.dart';

sealed class OccasionsEvents extends Equatable {
  const OccasionsEvents();
}

class GetOccasionsEvent extends OccasionsEvents {
  const GetOccasionsEvent();

  @override
  List<Object?> get props => [];
}

class GetProductsEvent extends OccasionsEvents {
  final String occasionName;
  const GetProductsEvent(this.occasionName);

  @override
  List<Object?> get props => [occasionName];
}
