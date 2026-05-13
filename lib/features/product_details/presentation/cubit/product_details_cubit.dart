import 'package:bloc/bloc.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/entities/product_entity.dart';
import 'package:flowers_app/features/product_details/domain/use_cases/product_details_use_case.dart';
import 'package:flowers_app/features/product_details/presentation/cubit/product_details_event.dart';
import 'package:flowers_app/features/product_details/presentation/cubit/product_details_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(this._productDetailsUseCase)
    : super(const ProductDetailsState());

  final ProductDetailsUseCase _productDetailsUseCase;

  void doEvent(ProductDetailsEvent event) async {
    switch (event) {
      case GetProductDetailsEvent():
        await _getProductDetails(event.productId);
    }
  }

  Future<void> _getProductDetails(String productId) async {
    emit(
      state.copyWith(
        productDetailsState: state.productDetailsState.copyWith(
          isLoading: true,
        ),
      ),
    );
    final response = await _productDetailsUseCase.call(productId);
    switch (response) {
      case SuccessBaseResponse<ProductEntity>():
        emit(
          state.copyWith(
            productDetailsState: state.productDetailsState.copyWith(
              isLoading: false,
              data: response.data,
            ),
          ),
        );
      case ErrorBaseResponse<ProductEntity>():
        emit(
          state.copyWith(
            productDetailsState: state.productDetailsState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }
}
