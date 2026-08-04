sealed class MainLayoutEvent {
  const MainLayoutEvent();
}

class ChangeIndexEvent extends MainLayoutEvent {
  final int index;

  const ChangeIndexEvent(this.index);
}
