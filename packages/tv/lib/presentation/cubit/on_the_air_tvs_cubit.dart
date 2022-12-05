import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';

part 'on_the_air_tvs_state.dart';

class OnTheAirTvsCubit extends Cubit<OnTheAirTvsState> {
  final GetOnTheAirTvs _getOnTheAirTvs;
  OnTheAirTvsCubit(this._getOnTheAirTvs) : super(OnTheAirTvsEmpty());

  void fetch() async {
    emit(OnTheAirTvsLoading());
    try {
      final result = await _getOnTheAirTvs.execute();

      result.fold(
        (failure) => throw failure,
        (tvs) => emit(OnTheAirTvsHasData(tvs)),
      );
    } on Failure catch (failure) {
      emit(OnTheAirTvsError(failure.message));
    }
  }
}
