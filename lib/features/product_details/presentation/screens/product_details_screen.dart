import 'package:flowers_app/config/services/snack_bar_services.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:flowers_app/features/product_details/presentation/cubit/product_details_state.dart';
import 'package:flowers_app/features/product_details/presentation/widgets/product_details_section.dart';
import 'package:flowers_app/features/product_details/presentation/widgets/product_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductDetailsCubit, ProductDetailsState>(
      listenWhen: (previous, current) {
        return previous.productDetailsState.errorMessage !=
            current.productDetailsState.errorMessage;
      },
      listener: (context, state) {
        if (state.productDetailsState.errorMessage != null) {
          SnackBarServices.showErrorMessage(
            state.productDetailsState.errorMessage!,
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
            if (state.productDetailsState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.productDetailsState.errorMessage != null) {
              return const SizedBox();
            }
            final productDetails = state.productDetailsState.data;
            if (productDetails == null) {
              return const Center(
                child: Text(AppStrings.noProductDetailsFound),
              );
            }
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                  ),
                  child: Column(
                    children: [
                      ProductImageSlider(
                        productImageSlider: 
                          productDetails.images
                        ,
                      ),
                      SizedBox(height: 6.h,),
                      ProductDetailsSection(
                        price: productDetails.price,
                        inStock: productDetails.quantity>0 ,
                        descreption: productDetails.description,
                        title: productDetails.title,
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 16.w),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(AppStrings.addToCart),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
