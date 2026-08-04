import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/helpers/date_time_extension.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_status.dart';
import 'package:flowers_app/features/tracking/presentation/view_model/tracking_cubit.dart';
import 'package:flowers_app/features/tracking/presentation/view_model/tracking_state.dart';
import 'package:flowers_app/features/tracking/presentation/widgets/rider_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class TrackingMapScreen extends StatelessWidget {
  const TrackingMapScreen({super.key});

  static const LatLng _storeLocation = LatLng(
    AppConstants.storeLatitude,
    AppConstants.storeLongitude,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TrackingCubit, TrackingState>(
        builder: (context, state) {
          if (state.status != TrackingStatusUi.success ||
              state.tracking == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final tracking = state.tracking!;
          final customer = _customerLocation(tracking);
          if (customer == null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Text(
                  AppStrings.deliveryAddress.tr(),
                  style: AppTextStyles.gray14400,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return _MapContent(
            tracking: tracking,
            customer: customer,
            // المسارات بتيجي جاهزة من الـ cubit (عبر use case → OSRM).
            routePoints: _toLatLngList(state.routePoints),
            riderRoutePoints: _toLatLngList(state.riderRoutePoints),
          );
        },
      ),
    );
  }

  static LatLng? _customerLocation(TrackingEntity tracking) {
    final loc = tracking.customerLocation;
    return loc != null ? LatLng(loc.lat, loc.long) : null;
  }

  static List<LatLng>? _toLatLngList(List<GeoPoint>? points) {
    if (points == null) return null;
    return points.map((p) => LatLng(p.lat, p.long)).toList();
  }
}

class _MapContent extends StatefulWidget {
  final TrackingEntity tracking;
  final LatLng customer;

  /// مسار المتجر → العميل. null = لسه بيتحمّل.
  final List<LatLng>? routePoints;

  /// مسار الرايدر الحي → العميل. null = مفيش (مش خارج للتوصيل).
  final List<LatLng>? riderRoutePoints;

  const _MapContent({
    required this.tracking,
    required this.customer,
    required this.routePoints,
    required this.riderRoutePoints,
  });

  @override
  State<_MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<_MapContent> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // لو المسار وصل قبل ما نفتح الماب، نظبّط الكاميرا عليه بعد أول فريم.
    if (widget.routePoints != null) {
      final points = widget.routePoints!;
      WidgetsBinding.instance.addPostFrameCallback((_) => _fitToRoute(points));
    }
  }

  @override
  void didUpdateWidget(covariant _MapContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // أول ما مسار المتجر→العميل يجهز، نظبّط الكاميرا تبان المسار كله.
    if (oldWidget.routePoints == null && widget.routePoints != null) {
      _fitToRoute(widget.routePoints!);
    }
  }

  void _fitToRoute(List<LatLng> points) {
    if (points.length < 2) return;
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
    final loc = widget.tracking.riderLocation;
    return loc != null ? LatLng(loc.lat, loc.long) : null;
  }

  @override
  Widget build(BuildContext context) {
    final customer = widget.customer;
    final tracking = widget.tracking;
    const store = TrackingMapScreen._storeLocation;

    // موقع الرايدر الحي (بيتحدّث لحظياً من الستريم).
    final LatLng? rider = _riderLatLng;
    final route = widget.routePoints;

    // نحسب موقع الموتوسيكل والخط حسب الحالة.
    LatLng? motorbike;
    List<LatLng> line = route ?? const [];

    if (route != null) {
      if (tracking.status == TrackingStatus.outForDelivery) {
        // خرج للتوصيل: الموتوسيكل عند موقع الرايدر الحقيقي والخط بينه وبين العميل بس.
        if (rider != null) {
          motorbike = rider;
          line = widget.riderRoutePoints ?? [rider, customer];
        } else {
          // الرايدر لسه مبعتش موقعه — نسيبه عند المتجر لحد أول تحديث.
          motorbike = store;
          line = route;
        }
      } else if (tracking.status == TrackingStatus.delivered) {
        // اتوصل: الموتوسيكل عند العميل.
        motorbike = customer;
        line = route;
      } else {
        // استلمنا طلبك / بنجهّز طلبك: الموتوسيكل واقف عند المتجر والخط كامل.
        motorbike = store;
        line = route;
      }
    }

    final center = LatLng(
      (store.latitude + customer.latitude) / 2,
      (store.longitude + customer.longitude) / 2,
    );

    return Column(
      children: [
        // ── الخريطة ────────────────────────────────────────────
        Expanded(
          child: Stack(
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
                  if (route != null && line.length >= 2)
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
              if (route == null)
                Positioned(
                  top: 16.h,
                  left: 16.w,
                  right: 16.w,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
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
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
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
            ],
          ),
        ),
        // ── اللوحة السفلية (زي الديزاين) ───────────────────────
        _bottomPanel(context, tracking),
      ],
    );
  }

  /// اللوحة السفلية: الوصول المتوقع + التاريخ، فاصل، بيانات الرايدر، وزرار
  /// تفاصيل الطلب — بنفس ترتيب الديزاين.
  Widget _bottomPanel(BuildContext context, TrackingEntity tracking) {
    return Material(
      color: AppColors.white,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Estimated arrival ──────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.estimatedArrival.tr(),
                    style: AppTextStyles.gray12400,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    tracking.estimatedArrival?.formatEstimatedArrival(
                          context.locale.languageCode,
                        ) ??
                        '—',
                    style: AppTextStyles.black16600,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Divider(height: 1, thickness: 1, color: AppColors.gray10),
            // ── بيانات الرايدر (RiderInfoCard ببادينج داخلي 16) ──
            RiderInfoCard(
              riderName: tracking.riderName,
              riderPhone: tracking.riderPhone,
            ),
            // ── زرار تفاصيل الطلب ──────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 16.h),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    AppStrings.orderDetails.tr(),
                    style: AppTextStyles.white16600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
