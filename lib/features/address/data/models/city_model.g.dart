// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityModel _$CityModelFromJson(Map<String, dynamic> json) => CityModel(
  id: json['id'] as String,
  governorateId: json['governorate_id'] as String,
  nameAr: json['city_name_ar'] as String,
  nameEn: json['city_name_en'] as String,
);

Map<String, dynamic> _$CityModelToJson(CityModel instance) => <String, dynamic>{
  'id': instance.id,
  'governorate_id': instance.governorateId,
  'city_name_ar': instance.nameAr,
  'city_name_en': instance.nameEn,
};
