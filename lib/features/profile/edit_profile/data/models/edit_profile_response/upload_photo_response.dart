class UploadPhotoResponse {
  final String message;
  final String? imageUrl;

  UploadPhotoResponse({required this.message, this.imageUrl});

  factory UploadPhotoResponse.fromJson(Map<String, dynamic> json) {
    return UploadPhotoResponse(
      message: json['message'] ?? '',
      imageUrl: json['user']?['photo'],
    );
  }
}
