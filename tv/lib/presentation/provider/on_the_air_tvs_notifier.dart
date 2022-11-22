import 'package:core/utils/state_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';

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
