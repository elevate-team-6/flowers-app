import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';

/// موديل رد OSRM. بيطلّع نقاط الـ polyline من geojson geometry.
/// شكل الرد: { "routes": [ { "geometry": { "coordinates": [[lon,lat], ...] } } ] }
class RouteResponse {
  final List<GeoPoint> points;

  const RouteResponse(this.points);

  factory RouteResponse.fromJson(Map<String, dynamic> json) {
    final routes = json['routes'] as List<dynamic>?;
    if (routes == null || routes.isEmpty) return const RouteResponse([]);

    final geometry = routes.first['geometry'] as Map<String, dynamic>?;
    final coordinates = geometry?['coordinates'] as List<dynamic>?;
    if (coordinates == null) return const RouteResponse([]);

    // GeoJSON بيرجّع الإحداثيات بترتيب [lon, lat].
    final points = coordinates
        .whereType<List<dynamic>>()
        .where((c) => c.length >= 2 && c[0] is num && c[1] is num)
        .map(
          (c) => GeoPoint(
            lat: (c[1] as num).toDouble(),
            long: (c[0] as num).toDouble(),
          ),
        )
        .toList();

    return RouteResponse(points);
  }

  RouteEntity toEntity() => RouteEntity(points);
}
