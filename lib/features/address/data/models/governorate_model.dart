import 'package:flowers_app/features/address/domain/entities/governorate_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'governorate_model.g.dart';

@JsonSerializable()
class GovernorateModel extends GovernorateEntity {
  const GovernorateModel({
    required super.id,
    @JsonKey(name: 'governorate_name_ar') required super.nameAr,
    @JsonKey(name: 'governorate_name_en') required super.nameEn,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) =>
      _$GovernorateModelFromJson(json);

  Map<String, dynamic> toJson() => _$GovernorateModelToJson(this);
}
