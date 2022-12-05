import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';

part 'popular_tvs_state.dart';

class PopularTvsCubit extends Cubit<PopularTvsState> {
  final GetPopularTvs _getPopularTvs;
  PopularTvsCubit(this._getPopularTvs) : super(PopularTvsEmpty());

  void fetch() async {
    emit(PopularTvsLoading());
    try {
      final result = await _getPopularTvs.execute();

      result.fold(
        (failure) => throw failure,
        (tvs) => emit(PopularTvsHasData(tvs)),
      );
    } on Failure catch (failure) {
      emit(PopularTvsError(failure.message));
    }
  }
}
