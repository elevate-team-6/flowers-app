import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/track_order/domain/entities/tracked_order_entity.dart';

enum TrackOrderStatus { initial, loading, success, error }

class TrackOrderStates extends Equatable {
  final TrackOrderStatus status;
  final TrackedOrderEntity? order;
  final String? errorMessage;

  const TrackOrderStates({
    this.status = TrackOrderStatus.initial,
    this.order,
    this.errorMessage,
  });

  TrackOrderStates copyWith({
    TrackOrderStatus? status,
    TrackedOrderEntity? order,
    String? errorMessage,
  }) {
    return TrackOrderStates(
      status: status ?? this.status,
      order: order ?? this.order,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, order, errorMessage];
}
