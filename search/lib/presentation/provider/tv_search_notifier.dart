import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:search/domain/usecase/search_tvs.dart';
import 'package:tv/tv.dart' show Tv;

class TvSearchNotifier extends ChangeNotifier {
  final SearchTvs searchTvs;

  TvSearchNotifier(this.searchTvs);

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  List<Tv> _tvList = [];
  List<Tv> get searchResult => _tvList;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvSearch(String query) async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await searchTvs.execute(query);

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
