// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'governorate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GovernorateModel _$GovernorateModelFromJson(Map<String, dynamic> json) =>
    GovernorateModel(
      id: json['id'] as String,
      nameAr: json['governorate_name_ar'] as String,
      nameEn: json['governorate_name_en'] as String,
    );

Map<String, dynamic> _$GovernorateModelToJson(GovernorateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'governorate_name_ar': instance.nameAr,
      'governorate_name_en': instance.nameEn,
    };
