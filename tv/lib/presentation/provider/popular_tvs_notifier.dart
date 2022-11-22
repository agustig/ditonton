import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';

class PopularTvsNotifier extends ChangeNotifier {
  final GetPopularTvs getPopularTvs;

  PopularTvsNotifier(this.getPopularTvs);

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  List<Tv> _tvList = [];
  List<Tv> get tvList => _tvList;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTvs() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getPopularTvs.execute();

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
