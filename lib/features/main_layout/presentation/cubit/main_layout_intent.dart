sealed class MainLayoutIntent {
  const MainLayoutIntent();
}

class ChangeIndexIntent extends MainLayoutIntent {
  final int index;
  const ChangeIndexIntent(this.index);
}
