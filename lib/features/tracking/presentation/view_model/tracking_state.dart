import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';

enum TrackingStatusUi { initial, loading, success, failure }

class TrackingState extends Equatable {
  final TrackingStatusUi status;
  final TrackingEntity? tracking;
  final String? errorMessage;
  final bool isTrackingLastStep;
  final bool deliveryConfirmed;

  const TrackingState({
    this.status = TrackingStatusUi.initial,
    this.tracking,
    this.errorMessage,
    this.isTrackingLastStep = false,
    this.deliveryConfirmed = false,
  });

  TrackingState copyWith({
    TrackingStatusUi? status,
    TrackingEntity? tracking,
    String? errorMessage,
    bool? isTrackingLastStep,
    bool? deliveryConfirmed,
  }) {
    return TrackingState(
      status: status ?? this.status,
      tracking: tracking ?? this.tracking,
      errorMessage: errorMessage ?? this.errorMessage,
      isTrackingLastStep: isTrackingLastStep ?? this.isTrackingLastStep,
      deliveryConfirmed: deliveryConfirmed ?? this.deliveryConfirmed,
    );
  }

  @override
  List<Object?> get props => [
        status,
        tracking,
        errorMessage,
        isTrackingLastStep,
        deliveryConfirmed,
      ];
}
