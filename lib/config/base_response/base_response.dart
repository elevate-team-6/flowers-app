sealed class BaseResponse<T> {}

class SuccessBaseResponse<T> extends BaseResponse<T> {
  final T data;
  SuccessBaseResponse(this.data);
}

class ErrorBaseResponse<T> extends BaseResponse<T> {
  final String errorMessage;
  ErrorBaseResponse(this.errorMessage);
}
