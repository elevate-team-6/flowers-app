import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/notifications/domain/entities/notifications_result_entity.dart';
import 'package:flowers_app/features/notifications/domain/use_cases/get_notifications_use_case.dart';
import 'package:flowers_app/features/notifications/domain/use_cases/mark_notifications_as_opened_use_case.dart';
import 'package:flowers_app/features/notifications/presentation/view_model/notifications_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationsAsOpenedUseCase _markNotificationsAsOpenedUseCase;

  NotificationsCubit(
    this._getNotificationsUseCase,
    this._markNotificationsAsOpenedUseCase,
  ) : super(const NotificationsState());

  Future<void> getNotifications() async {
    emit(
      state.copyWith(status: NotificationsStatus.loading, errorMessage: null),
    );

    final result = await _getNotificationsUseCase();

    switch (result) {
      case SuccessBaseResponse<NotificationsResultEntity>():
        emit(
          state.copyWith(
            status: NotificationsStatus.success,
            notifications: result.data.notifications,
            unreadCount: result.data.unreadCount,
          ),
        );

      case ErrorBaseResponse<NotificationsResultEntity>():
        emit(
          state.copyWith(
            status: NotificationsStatus.failure,
            errorMessage: result.errorMessage,
          ),
        );
    }
  }

  /// Call after the notifications list has been shown to the user.
  /// Saves "now" as the last-opened time and resets the badge to 0.
  Future<void> markNotificationsAsOpened() async {
    await _markNotificationsAsOpenedUseCase();
    emit(state.copyWith(unreadCount: 0));
  }
}
