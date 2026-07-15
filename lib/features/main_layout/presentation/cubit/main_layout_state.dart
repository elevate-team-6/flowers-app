import 'package:equatable/equatable.dart';

class MainLayoutState extends Equatable {
  final int currentIndex;

  const MainLayoutState({this.currentIndex = 0});

  MainLayoutState copyWith({int? currentIndex}) {
    return MainLayoutState(currentIndex: currentIndex ?? this.currentIndex);
  }

  @override
  List<Object?> get props => [currentIndex];
}
