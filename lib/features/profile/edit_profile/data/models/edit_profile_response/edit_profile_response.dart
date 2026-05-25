import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_response/user_model.dart';

class EditProfileResponse {
  final String? message;
  final UserModel? user;

  EditProfileResponse({required this.message, required this.user});

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) {
    return EditProfileResponse(
      message: json['message'],
      user: UserModel.fromJson(json['user']),
    );
  }
}
