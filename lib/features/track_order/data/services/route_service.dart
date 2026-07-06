import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:latlong2/latlong.dart';

/// بيجيب المسار الحقيقي على الشوارع بين نقطتين من خدمة OSRM المجانية.
/// بيرجّع لستة نقاط الـ polyline، ولو حصل أي خطأ بيرجّع الخط المستقيم (نقطتين بس).
class RouteService {
  // Dio مستقل من غير الـ interceptors بتاعة الـ REST API (مفيش auth headers على OSRM).
  final Dio _dio;

  RouteService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<LatLng>> getRoute({
    required LatLng from,
    required LatLng to,
  }) async {
    final url =
        '${AppEndPoints.osrmRouteBase}/'
        '${from.longitude},${from.latitude};${to.longitude},${to.latitude}';

    try {
      final response = await _dio.get(
        url,
        queryParameters: const {
          'overview': 'full',
          'geometries': 'geojson',
        },
      );

      final routes = response.data['routes'] as List<dynamic>?;
      if (routes == null || routes.isEmpty) return [from, to];

      // GeoJSON coordinates بترجع [lon, lat].
      final coords =
          routes.first['geometry']['coordinates'] as List<dynamic>;
      final points = coords
          .map((c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
          .toList();

      return points.isNotEmpty ? points : [from, to];
    } catch (_) {
      // أي فشل (نت/سيرفر) → نرجع للخط المستقيم كـ fallback.
      return [from, to];
    }
  }
}
