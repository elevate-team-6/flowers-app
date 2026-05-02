import 'package:equatable/equatable.dart';

class BaseState<T> extends Equatable {
  final bool isLoading;
  final T? data;
  final String? errorMessage;

  const BaseState({this.isLoading = false, this.data, this.errorMessage});

  BaseState<T> copyWith({bool? isLoading, T? data, String? errorMessage}) {
    return BaseState<T>(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, data, errorMessage];
}
