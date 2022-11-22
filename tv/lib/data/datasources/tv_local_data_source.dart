import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/utils/exception.dart';
import 'package:tv/data/models/tv_table.dart';

abstract class TvLocalDataSource {
  Future<String> insertTvWatchlist(TvTable tv);
  Future<String> removeTvWatchlist(TvTable tv);
  Future<TvTable?> getTvById(int id);
  Future<List<TvTable>> getWatchlistTvs();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertTvWatchlist(TvTable tv) async {
    try {
      await databaseHelper.insertTvToWatchlist(tv.toJson());

      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeTvWatchlist(TvTable tv) async {
    try {
      await databaseHelper.removeTvFromWatchlist(tv.id);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvTable?> getTvById(int id) async {
    final result = await databaseHelper.getTvById(id);
    if (result != null) {
      return TvTable.fromJson(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvTable>> getWatchlistTvs() async {
    final result = await databaseHelper.getWatchlistTvs();
    return result.map((data) => TvTable.fromJson(data)).toList();
  }
}
