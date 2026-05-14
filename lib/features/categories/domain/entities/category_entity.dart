import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String? id;
  final String? name;
  final String? image;

  const CategoryEntity({this.id, this.name, this.image});

  @override
  List<Object?> get props => [id, name, image];
}

class CategoriesEntity extends Equatable {
  final List<CategoryEntity>? categories;

  const CategoriesEntity({this.categories});

  @override
  List<Object?> get props => [categories];
}
