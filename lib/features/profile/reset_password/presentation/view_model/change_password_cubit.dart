import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/profile/reset_password/domain/use_cases/change_password_use_case.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/view_model/change_password_event.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/view_model/change_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordCubit(this._changePasswordUseCase)
    : super(const ChangePasswordState());

  Future<void> doEvent(ChangePasswordEvents event) async {
    switch (event) {
      case ChangePasswordEvent():
        await _changePassword(event.currentPassword, event.newPassword);
        break;
    }
  }

  Future<void> _changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    emit(state.copyWith(status: ChangePasswordStatus.loading));

    final result = await _changePasswordUseCase(currentPassword, newPassword);

    switch (result) {
      case SuccessBaseResponse():
        emit(state.copyWith(status: ChangePasswordStatus.success));
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            status: ChangePasswordStatus.failure,
            errorMessage: result.errorMessage,
          ),
        );
    }
  }
}
