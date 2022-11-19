import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tvs.dart';
import 'package:flutter/foundation.dart';

class TvSearchNotifier extends ChangeNotifier {
  final SearchTvs searchTvs;

  TvSearchNotifier(this.searchTvs);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tv> _tvList = [];
  List<Tv> get searchResult => _tvList;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchTvs.execute(query);

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvListData) {
        _tvList = tvListData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
