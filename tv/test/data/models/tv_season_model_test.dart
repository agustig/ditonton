import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/tv_season_model.dart';
import 'package:tv/domain/entities/tv_season.dart';

import '../../dummy_data/dummy_tv_objects.dart';
import '../../json_reader.dart';

void main() {
  final tTvSeasonModel = TvSeasonModel(
    id: 1,
    seasonNumber: 1,
    name: 'Season 1',
    overview: '',
    airDate: 'airDate',
    posterPath: '',
    episodes: const [],
  );

  const tTvSeason = TvSeason(
    id: 1,
    seasonNumber: 1,
    name: 'Season 1',
    overview: '',
    airDate: 'airDate',
    posterPath: '',
    episodes: [],
  );

  final t2TvSeasonModel = testTvSeasonModelWithEpisode;

  test('should be a subclass of TvSeason entity', () {
    final result = tTvSeasonModel.toEntity();
    expect(result, tTvSeason);
  });

  group('fromJson', () {
    test('should be valid TvSeasonModel', () {
      // arrange
      final episodeJson = json.decode(readJson('dummy_data/tv_season.json'));
      // act
      final result = TvSeasonModel.fromJson(episodeJson);
      // assert
      expect(result, t2TvSeasonModel);
    });
  });
}
