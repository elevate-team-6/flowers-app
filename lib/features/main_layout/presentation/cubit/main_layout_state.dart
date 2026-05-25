import 'package:equatable/equatable.dart';

class MainLayoutState extends Equatable {
  final int currentIndex;
  final String? categoryId;

  const MainLayoutState({this.currentIndex = 0, this.categoryId});

  MainLayoutState copyWith({int? currentIndex, String? categoryId}) {
    return MainLayoutState(
      currentIndex: currentIndex ?? this.currentIndex,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  List<Object?> get props => [currentIndex, categoryId];
}
