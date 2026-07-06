import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';

enum TrackingStatusUi { initial, loading, success, failure }

class TrackingState extends Equatable {
  final TrackingStatusUi status;
  final TrackingEntity? tracking;
  final String? errorMessage;

  const TrackingState({
    this.status = TrackingStatusUi.initial,
    this.tracking,
    this.errorMessage,
  });

  TrackingState copyWith({
    TrackingStatusUi? status,
    TrackingEntity? tracking,
    String? errorMessage,
  }) {
    return TrackingState(
      status: status ?? this.status,
      tracking: tracking ?? this.tracking,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, tracking, errorMessage];
}
