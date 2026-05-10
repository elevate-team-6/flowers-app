class VerifyResetCodeRequest {
  final String resetCode;

  const VerifyResetCodeRequest({required this.resetCode});

  Map<String, dynamic> toJson() => {'resetCode': resetCode};
}
