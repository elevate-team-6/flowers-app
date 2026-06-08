import 'package:equatable/equatable.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChangedEvent extends SearchEvent {
  final String query;
  const SearchQueryChangedEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class GetSearchHistoryEvent extends SearchEvent {
  const GetSearchHistoryEvent();
}

class RemoveSearchQueryEvent extends SearchEvent {
  final String query;
  const RemoveSearchQueryEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearchHistoryEvent extends SearchEvent {
  const ClearSearchHistoryEvent();
}
