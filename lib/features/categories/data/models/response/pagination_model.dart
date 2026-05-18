import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pagination_model.g.dart';

@JsonSerializable()
class PaginationModel extends Equatable {
  final int? currentPage;
  final int? limit;
  final int? totalPages;
  final int? totalItems;

  const PaginationModel({
    this.currentPage,
    this.limit,
    this.totalPages,
    this.totalItems,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);

  @override
  List<Object?> get props => [currentPage, limit, totalPages, totalItems];
}
