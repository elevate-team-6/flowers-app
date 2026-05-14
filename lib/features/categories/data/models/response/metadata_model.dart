import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'metadata_model.g.dart';

@JsonSerializable()
class MetadataModel extends Equatable {
  final int? currentPage;
  final int? limit;
  final int? totalPages;
  final int? totalItems;

  const MetadataModel({
    this.currentPage,
    this.limit,
    this.totalPages,
    this.totalItems,
  });

  factory MetadataModel.fromJson(Map<String, dynamic> json) =>
      _$MetadataModelFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataModelToJson(this);

  @override
  List<Object?> get props => [currentPage, limit, totalPages, totalItems];
}
