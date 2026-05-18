sealed class MainLayoutEvent {
  const MainLayoutEvent();
}

class ChangeIndexEvent extends MainLayoutEvent {
  final int index;
  final String? categoryId;
  const ChangeIndexEvent(this.index, {this.categoryId});
}
