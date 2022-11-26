import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';

part 'top_rated_tvs_state.dart';

class TopRatedTvsCubit extends Cubit<TopRatedTvsState> {
  final GetTopRatedTvs _getTopRatedTvs;
  TopRatedTvsCubit(this._getTopRatedTvs) : super(TopRatedTvsEmpty());

  void fetch() async {
    emit(TopRatedTvsLoading());
    try {
      final result = await _getTopRatedTvs.execute();

      result.fold(
        (failure) => throw failure,
        (tvs) => emit(TopRatedTvsHasData(tvs)),
      );
    } on Failure catch (failure) {
      emit(TopRatedTvsError(failure.message));
    }
  }
}
