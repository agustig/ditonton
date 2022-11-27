import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';

part 'popular_movies_state.dart';

class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  final GetPopularMovies _getPopularMovies;
  PopularMoviesCubit(this._getPopularMovies) : super(PopularMoviesEmpty());

  void fetch() async {
    emit(PopularMoviesLoading());
    try {
      final result = await _getPopularMovies.execute();

      result.fold(
        (failure) => throw failure,
        (movies) => emit(PopularMoviesHasData(movies)),
      );
    } on Failure catch (failure) {
      emit(PopularMoviesError(failure.message));
    }
  }
}
