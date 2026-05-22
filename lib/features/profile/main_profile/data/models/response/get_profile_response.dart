import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../user_profile_model.dart';

part 'get_profile_response.g.dart';

@JsonSerializable()
class GetProfileResponse extends Equatable {
  final String? message;
  final UserProfileModel? user;

  const GetProfileResponse({this.message, this.user});

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$GetProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetProfileResponseToJson(this);

  @override
  List<Object?> get props => [message, user];
}
