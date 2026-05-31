import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/best_seller/domain/use_cases/best_seller_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'best_seller_event.dart';
import 'best_seller_state.dart';

@injectable
class BestSellerCubit extends Cubit<BestSellerState> {
  BestSellerCubit(this._bestSellerUseCase) : super(const BestSellerState());
  final BestSellerUseCase _bestSellerUseCase;
  Future<void> doEvent(BestSellerEvent event) async {
    switch (event) {
      case GetBestSellerProductsEvent():
        await _bestSeller();
    }
  }

  Future<void> _bestSeller() async {
    if (state.bestSellerState.data == null) {
      emit(
        state.copyWith(
          bestSellerState: state.bestSellerState.copyWith(
            isLoading: true,
            errorMessage: null,
          ),
        ),
      );
    }

    final response = await _bestSellerUseCase.call();

    switch (response) {
      case SuccessBaseResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            bestSellerState: state.bestSellerState.copyWith(
              isLoading: false,
              errorMessage: null,
              data: response.data,
            ),
          ),
        );

      case ErrorBaseResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            bestSellerState: state.bestSellerState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }
}
