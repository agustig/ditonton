import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tvs.dart';
import 'package:flutter/foundation.dart';

class OnTheAirTvsNotifier extends ChangeNotifier {
  final GetOnTheAirTvs getOnTheAirTvs;

  OnTheAirTvsNotifier(this.getOnTheAirTvs);

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  List<Tv> _tvList = [];
  List<Tv> get tvList => _tvList;

  String _message = '';
  String get message => _message;

  Future<void> fetchOnTheAir() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getOnTheAirTvs.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (tvListData) {
        _tvList = tvListData;
        _state = RequestState.loaded;
        notifyListeners();
      },
    );
  }
}
