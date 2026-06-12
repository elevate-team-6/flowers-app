import 'package:flowers_app/features/address/domain/entities/city_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'city_model.g.dart';

@JsonSerializable()
class CityModel {
  final String id;
  @JsonKey(name: 'governorate_id')
  final String governorateId;
  @JsonKey(name: 'city_name_ar')
  final String nameAr;
  @JsonKey(name: 'city_name_en')
  final String nameEn;

  const CityModel({
    required this.id,
    required this.governorateId,
    required this.nameAr,
    required this.nameEn,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityModelToJson(this);

  CityEntity toEntity() => CityEntity(
    id: id,
    governorateId: governorateId,
    nameAr: nameAr,
    nameEn: nameEn,
  );
}
