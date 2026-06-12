import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final String id;
  final String governorateId;
  final String nameAr;
  final String nameEn;

  const CityEntity({
    required this.id,
    required this.governorateId,
    required this.nameAr,
    required this.nameEn,
  });

  @override
  List<Object?> get props => [id, governorateId, nameAr, nameEn];
}
