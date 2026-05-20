class EditProfileRequest {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? gender;

  EditProfileRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
  });
  Map<String, dynamic> toJson() {
    return {"firstName": firstName, "lastName": lastName, "phone": phone};
  }
}
