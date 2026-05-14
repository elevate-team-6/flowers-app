import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String? id;
  final String? name;

  const CategoryEntity({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}

class CategoriesEntity extends Equatable {
  final List<CategoryEntity>? categories;

  const CategoriesEntity({this.categories});

  @override
  List<Object?> get props => [categories];
}
