import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart' show Movie;
import 'package:rxdart/rxdart.dart';
import 'package:search/domain/usecase/search_movies.dart';
import 'package:search/domain/usecase/search_tvs.dart';
import 'package:tv/tv.dart' show Tv;

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies _searchMovies;
  final SearchTvs _searchTvs;
  SearchBloc({
    required SearchMovies searchMovies,
    required SearchTvs searchTvs,
  })  : _searchMovies = searchMovies,
        _searchTvs = searchTvs,
        super(SearchEmpty()) {
    on<SearchStart>(_onSearchStart);
    on<QueryChange>(
      _onQueryChanged,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 500))
          .flatMap(mapper),
    );
  }

  _onSearchStart(SearchStart event, Emitter<SearchState> emit) {
    emit(SearchEmpty());
  }

  _onQueryChanged(QueryChange event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    final query = event.query;
    if (query.isEmpty) {
      emit(SearchEmpty());
    } else {
      try {
        final movieSearch = await _searchMovies.execute(query);
        final tvSearch = await _searchTvs.execute(query);

        late List<Movie> movieResult;
        late List<Tv> tvResult;

        movieSearch.fold((failure) {
          throw failure;
        }, (data) {
          movieResult = data;
        });
        tvSearch.fold((failure) {
          throw failure;
        }, (data) {
          tvResult = data;
        });
        emit(SearchHasData(movies: movieResult, tvs: tvResult));
      } on Failure catch (failure) {
        emit(SearchError(failure.message));
      }
    }
  }
}
