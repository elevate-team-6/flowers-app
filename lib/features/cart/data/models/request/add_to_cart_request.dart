class AddToCartRequest {
  final String product;
  final int quantity;

  const AddToCartRequest({required this.product, required this.quantity});

  Map<String, dynamic> toJson() => {'product': product, 'quantity': quantity};
}
