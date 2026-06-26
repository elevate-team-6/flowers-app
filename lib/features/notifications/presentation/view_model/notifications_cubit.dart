import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:flowers_app/features/notifications/domain/use_cases/get_notifications_use_case.dart';
import 'package:flowers_app/features/notifications/presentation/view_model/notifications_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  //
  NotificationsCubit(this._getNotificationsUseCase)
    : super(const NotificationsState());

  Future<void> getNotifications() async {
    emit(
      state.copyWith(status: NotificationsStatus.loading, errorMessage: null),
    );

    final result = await _getNotificationsUseCase();

    switch (result) {
      case SuccessBaseResponse<List<NotificationEntity>>():
        emit(
          state.copyWith(
            status: NotificationsStatus.success,
            notifications: result.data,
          ),
        );

      case ErrorBaseResponse<List<NotificationEntity>>():
        emit(
          state.copyWith(
            status: NotificationsStatus.failure,
            errorMessage: result.errorMessage,
          ),
        );
    }
  }
}
