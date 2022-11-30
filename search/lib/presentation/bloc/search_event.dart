part of 'search_bloc.dart';

abstract class SearchEvent {}

class QueryChange extends SearchEvent {
  final String query;

  QueryChange(this.query);
}

class SearchStart extends SearchEvent {}
