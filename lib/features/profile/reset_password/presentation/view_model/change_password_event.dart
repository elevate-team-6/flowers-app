abstract class ChangePasswordEvents {}

class ChangePasswordEvent extends ChangePasswordEvents {
  final String currentPassword;
  final String newPassword;

  ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
  });
}
