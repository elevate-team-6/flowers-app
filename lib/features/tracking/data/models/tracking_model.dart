import 'package:equatable/equatable.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_status.dart';

class TrackingModel extends Equatable {
  final String? riderId;
  final String? riderName;
  final String? riderPhone;
  final TrackingStatus status;

  const TrackingModel({
    required this.riderId,
    required this.riderName,
    required this.riderPhone,
    required this.status,
  });

  factory TrackingModel.fromJson(Map<String, dynamic> json) {
    return TrackingModel(
      riderId: json[AppConstants.riderIdField] as String?,
      riderName: json[AppConstants.riderNameField] as String?,
      riderPhone: json[AppConstants.riderPhoneField] as String?,
      status: _parseStatus(json[AppConstants.statusField] as String?),
    );
  }

  TrackingEntity toEntity() {
    return TrackingEntity(
      riderId: riderId,
      riderName: riderName,
      riderPhone: riderPhone,
      status: status,
    );
  }

  static TrackingStatus _parseStatus(String? status) {
    return switch (status) {
      'accepted' => TrackingStatus.accepted,
      'preparing' => TrackingStatus.preparing,
      'outForDelivery' => TrackingStatus.outForDelivery,
      'delivered' => TrackingStatus.delivered,
      _ => TrackingStatus.pending,
    };
  }

  @override
  List<Object?> get props => [riderId, riderName, riderPhone, status];
}
