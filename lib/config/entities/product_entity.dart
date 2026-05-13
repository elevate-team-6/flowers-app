import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final String description;

  final List<String> images;

  final int price;
  final int quantity;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.price,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, title, description, images, price, quantity];
}
