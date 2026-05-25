import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/occasions/data/models/responses/occasion_model.dart';

class OccasionsResponse extends Equatable {
  final String? message;
  final List<OccasionModel>? occasions;

  const OccasionsResponse({this.message, this.occasions});

  factory OccasionsResponse.fromJson(Map<String, dynamic> json) =>
      OccasionsResponse(
        message: json['message'] as String?,
        occasions: (json['occasions'] as List<dynamic>?)
            ?.map((e) => OccasionModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [message, occasions];
}
