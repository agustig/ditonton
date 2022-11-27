import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';

part 'top_rated_movies_state.dart';

class TopRatedMoviesCubit extends Cubit<TopRatedMoviesState> {
  final GetTopRatedMovies _getTopRatedMovies;
  TopRatedMoviesCubit(this._getTopRatedMovies) : super(TopRatedMoviesEmpty());

  void fetch() async {
    emit(TopRatedMoviesLoading());
    try {
      final result = await _getTopRatedMovies.execute();

      result.fold(
        (failure) => throw failure,
        (movies) => emit(TopRatedMoviesHasData(movies)),
      );
    } on Failure catch (failure) {
      emit(TopRatedMoviesError(failure.message));
    }
  }
}
