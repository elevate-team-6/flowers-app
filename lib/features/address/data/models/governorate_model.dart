import 'package:flowers_app/features/address/domain/entities/governorate_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'governorate_model.g.dart';

@JsonSerializable()
class GovernorateModel {
  final String id;
  @JsonKey(name: 'governorate_name_ar')
  final String nameAr;
  @JsonKey(name: 'governorate_name_en')
  final String nameEn;

  const GovernorateModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) =>
      _$GovernorateModelFromJson(json);

  Map<String, dynamic> toJson() => _$GovernorateModelToJson(this);

  GovernorateEntity toEntity() =>
      GovernorateEntity(id: id, nameAr: nameAr, nameEn: nameEn);
}
