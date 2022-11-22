import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:tv/domain/entities/tv_detail.dart';

import '../../dummy_data/dummy_tv_objects.dart';
import '../../json_reader.dart';

void main() {
  const tTvDetailModel = TvDetailModel(
      id: 1,
      name: 'name',
      overview: 'overview',
      genres: [],
      numberOfEpisodes: 24,
      numberOfSeasons: 1,
      seasons: [],
      posterPath: 'posterPath',
      voteAverage: 8.8);

  final tTvDetail = TvDetail(
    id: 1,
    name: 'name',
    overview: 'overview',
    genres: const [],
    numberOfEpisodes: 24,
    numberOfSeasons: 1,
    seasons: const [],
    posterPath: 'posterPath',
    voteAverage: 8.8,
  );

  final t2TvDetailModel = testTvDetailModel;

  test('should be a subclass of TvDetail entity', () {
    final result = tTvDetailModel.toEntity();
    expect(result, tTvDetail);
  });

  group('fromJson', () {
    test('should be valid TvDetail', () {
      // arrange
      final episodeJson = json.decode(readJson('dummy_data/tv_detail.json'));
      // act
      final result = TvDetailModel.fromJson(episodeJson);
      // assert
      expect(result, t2TvDetailModel);
    });
  });
}
