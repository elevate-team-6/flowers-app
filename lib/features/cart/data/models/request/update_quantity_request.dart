class UpdateQuantityRequest {
  final int quantity;

  const UpdateQuantityRequest({required this.quantity});

  Map<String, dynamic> toJson() => {'quantity': quantity};
}
