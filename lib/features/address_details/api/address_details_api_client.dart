import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/features/address_details/data/models/address_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'address_details_api_client.g.dart';

@injectable
@RestApi()
abstract class AddressDetailsApiClient {
  @factoryMethod
  factory AddressDetailsApiClient(Dio dio) = _AddressDetailsApiClient;
    @GET(AppEndPoints.addresses)
  Future<AddressResponse> getAddresses();
}
