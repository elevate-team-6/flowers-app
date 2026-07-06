import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/features/tracking/data/models/route_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'tracking_api_client.g.dart';

/// بيكلّم خدمة OSRM المجانية على شبكة OpenStreetMap لجلب المسار الحقيقي بين نقطتين.
/// بيستخدم Dio مخصّص (@Named('tracking')) من غير الـ auth interceptor عشان ما نبعتش
/// توكن المستخدم لسيرفر طرف تالت.
@lazySingleton
@RestApi()
abstract class TrackingApiClient {
  @factoryMethod
  factory TrackingApiClient(@Named('tracking') Dio dio) = _TrackingApiClient;

  @GET(AppEndPoints.osrmRoutePath)
  Future<RouteResponse> getRoute(
    @Path(AppEndPoints.osrmCoordinatesParam) String coordinates, {
    @Query(AppEndPoints.osrmOverviewParam)
    String overview = AppEndPoints.osrmOverviewFull,
    @Query(AppEndPoints.osrmGeometriesParam)
    String geometries = AppEndPoints.osrmGeometriesGeoJson,
  });
}
