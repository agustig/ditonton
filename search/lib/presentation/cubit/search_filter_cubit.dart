import 'package:flutter_bloc/flutter_bloc.dart';

enum SearchFilterOption { all, movie, tv }

class SearchFilterCubit extends Cubit<SearchFilterOption> {
  SearchFilterCubit() : super(SearchFilterOption.all);

  void filterBy(SearchFilterOption? filterOption) {
    if (filterOption != null) {
      emit(filterOption);
    }
  }
}
