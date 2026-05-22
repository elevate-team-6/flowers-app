import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_request/edit_profile_request.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_response/edit_profile_response.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_response/upload_photo_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'edit_profile_api_client.g.dart';

@injectable
@RestApi()
abstract class EditProfileApiClient {
  @factoryMethod
  factory EditProfileApiClient(Dio dio) => _EditProfileApiClient(dio);
  @PUT(AppEndPoints.editProfile)
  Future<EditProfileResponse> editProfile(@Body() EditProfileRequest request);
  @MultiPart()
  @PUT(AppEndPoints.uploadPhoto)
  Future<UploadPhotoResponse> uploadPhoto(
    @Part(name: 'photo') MultipartFile image,
  );
}
