import 'package:flowers_app/features/auth/login/data/models/login_response/user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
    @JsonKey(name: "message")
    String? message;
    @JsonKey(name: "user")
    User? user;
    @JsonKey(name: "token")
    String? token;

    LoginResponse({
        this.message,
        this.user,
        this.token,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

    Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

