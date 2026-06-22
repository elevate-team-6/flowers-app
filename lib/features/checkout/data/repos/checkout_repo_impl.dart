import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/checkout/data/data_sources/checkout_remote_data_source_contract.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_requests/checkout_request.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/card_response/card_checkout_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/cash_response/cash_checkout_response.dart';
import 'package:flowers_app/features/checkout/domain/entities/card_entity.dart';
import 'package:flowers_app/features/checkout/domain/entities/order_entity.dart';
import 'package:flowers_app/features/checkout/domain/repos/checkout_repo_contract.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CheckoutRepoContract)
class CheckoutRepoImpl implements CheckoutRepoContract {
  final CheckoutRemoteDataSourceContract _checkoutRemoteDataSource;
  final FirebaseFirestore _firestore;

  const CheckoutRepoImpl(this._checkoutRemoteDataSource, this._firestore);

  @override
  Future<BaseResponse<CardEntity>> cardCheckout(
    String cartId,
    CheckoutRequest request,
  ) async {
    final response = await _checkoutRemoteDataSource.cardCheckout(
      cartId,
      request,
    );
    switch (response) {
      case SuccessBaseResponse<CardCheckoutResponse>():
        return SuccessBaseResponse(response.data.session!.toDomain());
      case ErrorBaseResponse<CardCheckoutResponse>():
        return ErrorBaseResponse(response.errorMessage);
    }
  }

  @override
  Future<BaseResponse<OrderEntity>> cashCheckout(
    CheckoutRequest request,
  ) async {
    final response = await _checkoutRemoteDataSource.cashCheckout(request);
    switch (response) {
      case SuccessBaseResponse<CashCheckoutResponse>():
        final orderModel = response.data.order;
        if (orderModel != null) {
          try {
            // --- تخزين الأوردر في Firestore ---
            await _firestore
                .collection(AppConstants.ordersCollection)
                .doc(orderModel.id)
                .set({
                  AppConstants.orderIdField: orderModel.id,
                  AppConstants.orderNumberField: orderModel.orderNumber,
                  AppConstants.userIdField: orderModel.userId,
                  AppConstants.statusField: 'pending',
                  AppConstants.riderIdField: null,
                  AppConstants.riderNameField: null,
                  AppConstants.riderPhoneField: null,
                });
          } catch (e) {
            debugPrint("Error saving order to Firestore: $e");
          }
        }
        return SuccessBaseResponse(response.data.order!.toDomain());
      case ErrorBaseResponse<CashCheckoutResponse>():
        return ErrorBaseResponse(response.errorMessage);
    }
  }

  @override
  int getDeliveryDays() {
    return _checkoutRemoteDataSource.getDeliveryDays();
  }
}
