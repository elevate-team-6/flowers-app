import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/features/address/data/models/address_model.dart';
import 'package:flowers_app/features/address/data/models/address_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'address_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class AddressApiClient {
  @factoryMethod
  factory AddressApiClient(Dio dio) = _AddressApiClient;

  @GET(AppEndPoints.addresses)
  Future<AddressResponse> getAddresses();

  @PATCH(AppEndPoints.addresses)
  Future<AddressResponse> addAddress(@Body() AddressModel address);

  @PATCH(AppEndPoints.addressPath)
  Future<AddressResponse> updateAddress(
    @Path(AppEndPoints.addressIdParam) String id,
    @Body() AddressModel address,
  );

  @DELETE(AppEndPoints.addressPath)
  Future<AddressResponse> deleteAddress(
    @Path(AppEndPoints.addressIdParam) String id,
  );
}
