import 'dart:async';

import 'package:flowers_app/features/track_order/domain/entities/tracked_order_entity.dart';
import 'package:flowers_app/features/track_order/domain/repos/track_order_repo_contract.dart';
import 'package:flowers_app/features/track_order/presentation/view_model/track_order_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackOrderCubit extends Cubit<TrackOrderStates> {
  final TrackOrderRepoContract _repo;

  TrackOrderCubit(this._repo) : super(const TrackOrderStates());

  static const Duration _riderPollInterval = Duration(seconds: 5);

  String? _orderId;
  StreamSubscription<dynamic>? _subscription;
  Timer? _riderLocationTimer;

  /// يبدأ الاستماع اللحظي لدوكيومنت الأوردر.
  void watch(String orderId) {
    _orderId = orderId;
    emit(state.copyWith(status: TrackOrderStatus.loading));
    _subscription?.cancel();
    _subscription = _repo.watchOrder(orderId).listen(
      (order) {
        emit(
          state.copyWith(status: TrackOrderStatus.success, order: order),
        );
        _manageRiderPolling(order.status);
      },
      onError: (error) {
        emit(
          state.copyWith(
            status: TrackOrderStatus.error,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  /// أثناء "خرج للتوصيل" بنجيب موقع الرايدر (lat/long) كل 5 ثواني ونحدّث الماركر.
  /// في أي حالة تانية بنوقف الـ polling.
  void _manageRiderPolling(TrackingStatus status) {
    if (status == TrackingStatus.onWay) {
      if (_riderLocationTimer == null) {
        _riderLocationTimer = Timer.periodic(
          _riderPollInterval,
          (_) => _refreshRiderLocation(),
        );
        // قراءة فورية من غير ما نستنى أول 5 ثواني.
        _refreshRiderLocation();
      }
    } else {
      _riderLocationTimer?.cancel();
      _riderLocationTimer = null;
    }
  }

  Future<void> _refreshRiderLocation() async {
    final orderId = _orderId;
    final current = state.order;
    if (orderId == null || current == null) return;
    try {
      final location = await _repo.getRiderLocation(orderId);
      if (location == null || isClosed) return;
      emit(state.copyWith(order: current.copyWith(riderLocation: location)));
    } catch (_) {
      // فشل مؤقت في القراءة — هنعيد المحاولة في الدورة الجاية.
    }
  }

  @override
  Future<void> close() {
    _riderLocationTimer?.cancel();
    _subscription?.cancel();
    return super.close();
  }
}
