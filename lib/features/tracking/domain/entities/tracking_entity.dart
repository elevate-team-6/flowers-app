import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_status.dart';

class TrackingEntity extends Equatable {
  final String? riderId;
  final String? riderName;
  final String? riderPhone;
  final TrackingStatus status;

  const TrackingEntity({
    required this.riderId,
    required this.riderName,
    required this.riderPhone,
    required this.status,
  });

  @override
  List<Object?> get props => [riderId, riderName, riderPhone, status];
}
