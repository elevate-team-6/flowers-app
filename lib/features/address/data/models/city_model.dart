import 'package:flowers_app/features/address/domain/entities/city_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'city_model.g.dart';

@JsonSerializable()
class CityModel extends CityEntity {
  const CityModel({
    required super.id,
    @JsonKey(name: 'governorate_id') required super.governorateId,
    @JsonKey(name: 'city_name_ar') required super.nameAr,
    @JsonKey(name: 'city_name_en') required super.nameEn,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityModelToJson(this);
}
