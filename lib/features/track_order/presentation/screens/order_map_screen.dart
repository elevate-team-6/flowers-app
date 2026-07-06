import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/track_order/data/services/route_service.dart';
import 'package:flowers_app/features/track_order/domain/entities/tracked_order_entity.dart';
import 'package:flowers_app/features/track_order/presentation/view_model/track_order_cubit.dart';
import 'package:flowers_app/features/track_order/presentation/view_model/track_order_states.dart';
import 'package:flowers_app/features/track_order/presentation/widgets/rider_contact_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class OrderMapScreen extends StatelessWidget {
  const OrderMapScreen({super.key});

  static const LatLng _storeLocation = LatLng(
    AppConstants.storeLatitude,
    AppConstants.storeLongitude,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.trackOrder.tr()),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: BlocBuilder<TrackOrderCubit, TrackOrderStates>(
        builder: (context, state) {
          if (state.status != TrackOrderStatus.success || state.order == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final order = state.order!;
          final customer = _customerLocation(order);
          if (customer == null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Text(
                  AppStrings.deliveryAddress.tr(),
                  style: AppTextStyles.gray14400,
                ),
              ),
            );
          }
          return _MapContent(order: order, customer: customer);
        },
      ),
    );
  }

  static LatLng? _customerLocation(TrackedOrderEntity order) {
    final lat = order.shippingAddress?.latitude;
    final long = order.shippingAddress?.longitude;
    if (lat == null || long == null) return null;
    return LatLng(lat, long);
  }
}

class _MapContent extends StatefulWidget {
  final TrackedOrderEntity order;
  final LatLng customer;

  const _MapContent({required this.order, required this.customer});

  @override
  State<_MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<_MapContent> {
  final MapController _mapController = MapController();
  final RouteService _routeService = RouteService();

  // مسار المتجر → العميل (للحالات: استلمنا/بنجهّز/اتوصل).
  // null = لسه بيتحمّل (بنعرض تحميل بدل أي خط).
  List<LatLng>? _routePoints;

  // مسار الرايدر (موقعه الحي) → العميل، بيتحدّث كل ما موقع الرايدر يتغيّر.
  List<LatLng>? _riderRoutePoints;
  String? _lastRiderKey;

  @override
  void initState() {
    super.initState();
    _loadRoute();
    _maybeFetchRiderRoute();
  }

  @override
  void didUpdateWidget(covariant _MapContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // موقع الرايدر اتحدّث (من الـ polling كل 5 ثواني) → نعيد رسم مساره للعميل.
    if (oldWidget.order.riderLocation != widget.order.riderLocation ||
        oldWidget.order.status != widget.order.status) {
      _maybeFetchRiderRoute();
    }
  }

  Future<void> _loadRoute() async {
    final points = await _routeService.getRoute(
      from: OrderMapScreen._storeLocation,
      to: widget.customer,
    );
    if (!mounted) return;
    setState(() => _routePoints = points);
    // نظبّط الكاميرا تبان المسار كله.
    try {
      _mapController.fitCamera(
        CameraFit.coordinates(
          coordinates: points,
          padding: EdgeInsets.all(60.r),
        ),
      );
    } catch (_) {
      // لو الماب لسه مش جاهزة نتجاهل.
    }
  }

  LatLng? get _riderLatLng {
    final loc = widget.order.riderLocation;
    return loc != null ? LatLng(loc.lat, loc.long) : null;
  }

  /// بيجيب مسار الرايدر الحالي → العميل على الشوارع (بس لما يتغيّر موقعه فعلياً).
  Future<void> _maybeFetchRiderRoute() async {
    final rider = _riderLatLng;
    if (widget.order.status != TrackingStatus.onWay || rider == null) {
      if (_riderRoutePoints != null || _lastRiderKey != null) {
        setState(() {
          _riderRoutePoints = null;
          _lastRiderKey = null;
        });
      }
      return;
    }

    final key = '${rider.latitude},${rider.longitude}';
    if (key == _lastRiderKey) return; // نفس الموقع، مفيش داعي لإعادة الجلب.
    _lastRiderKey = key;

    final points = await _routeService.getRoute(
      from: rider,
      to: widget.customer,
    );
    if (!mounted) return;
    setState(() => _riderRoutePoints = points);
  }

  @override
  Widget build(BuildContext context) {
    final customer = widget.customer;
    final order = widget.order;
    const store = OrderMapScreen._storeLocation;

    // موقع الرايدر الحي (بيتحدّث كل 5 ثواني من الكيوبت).
    final LatLng? rider = _riderLatLng;

    // نحسب موقع الموتوسيكل والخط حسب الحالة.
    LatLng? motorbike;
    List<LatLng> line = _routePoints ?? const [];

    if (_routePoints != null) {
      final route = _routePoints!;
      if (order.status == TrackingStatus.onWay) {
        // خرج للتوصيل: الموتوسيكل عند موقع الرايدر الحقيقي والخط بينه وبين العميل بس.
        if (rider != null) {
          motorbike = rider;
          line = _riderRoutePoints ?? [rider, customer];
        } else {
          // الرايدر لسه مبعتش موقعه — نسيبه عند المتجر لحد أول تحديث.
          motorbike = store;
          line = route;
        }
      } else if (order.status == TrackingStatus.delivered) {
        // اتوصل: الموتوسيكل عند العميل.
        motorbike = customer;
        line = route;
      } else if (!order.status.isCanceled) {
        // استلمنا طلبك / بنجهّز طلبك: الموتوسيكل واقف عند المتجر والخط كامل.
        motorbike = store;
        line = route;
      }
    }

    final center = LatLng(
      (store.latitude + customer.latitude) / 2,
      (store.longitude + customer.longitude) / 2,
    );

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(initialCenter: center, initialZoom: 13),
          children: [
            TileLayer(
              urlTemplate: AppConstants.mapUrlTemplate,
              userAgentPackageName: AppConstants.mapUserAgent,
            ),
            // المسار على الشوارع الفعلية — ما بيترسمش إلا بعد ما يجهز.
            if (_routePoints != null && line.length >= 2)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: line,
                    color: AppColors.primary,
                    strokeWidth: 5,
                    strokeCap: StrokeCap.round,
                    strokeJoin: StrokeJoin.round,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                _labeledMarker(
                  point: store,
                  label: AppStrings.storeLabel.tr(),
                  icon: Icons.local_florist,
                ),
                _labeledMarker(
                  point: customer,
                  label: AppStrings.apartmentLabel.tr(),
                  icon: Icons.home_rounded,
                ),
                if (motorbike != null) _scooterMarker(motorbike),
              ],
            ),
          ],
        ),
        // تحميل المسار: بيظهر بدل الخط لحد ما الطريق الحقيقي يجهز.
        if (_routePoints == null)
          Positioned(
            top: 16.h,
            left: 16.w,
            right: 16.w,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16.r,
                      height: 16.r,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      AppStrings.loadingRoute.tr(),
                      style: AppTextStyles.black14400,
                    ),
                  ],
                ),
              ),
            ),
          ),
        Positioned(
          left: 16.w,
          right: 16.w,
          bottom: 16.h,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RiderContactCard(order: order),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppStrings.orderDetails.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// ماركر بـ label (pill) وأيقونة + دبّوس تحته — زي ديزاين "Flowery" / "Apartment".
  Marker _labeledMarker({
    required LatLng point,
    required String label,
    required IconData icon,
  }) {
    return Marker(
      point: point,
      width: 160.w,
      height: 70.h,
      // topCenter => الماركر فوق النقطة وطرف الدبّوس السفلي عند الموقع بالظبط.
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20.r,
                  height: 20.r,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 13.r),
                ),
                SizedBox(width: 6.w),
                Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: Text(
                    label,
                    style: AppTextStyles.white12600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // الدبّوس (طرفه السفلي = الموقع الفعلي).
          Icon(Icons.location_on, color: AppColors.primary, size: 26.r),
        ],
      ),
    );
  }

  /// سكوتر التوصيل — بأبيض حوّاليه للوضوح فوق الخريطة.
  Marker _scooterMarker(LatLng point) {
    return Marker(
      point: point,
      width: 56.r,
      height: 56.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.delivery_dining, color: AppColors.white, size: 52.r),
          Icon(Icons.delivery_dining, color: AppColors.primary, size: 44.r),
        ],
      ),
    );
  }
}
