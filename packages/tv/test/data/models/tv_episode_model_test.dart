import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/tv_episode_model.dart';
import 'package:tv/domain/entities/tv_episode.dart';

import '../../dummy_data/dummy_tv_objects.dart';
import '../../json_reader.dart';

void main() {
  const tTvEpisodeModel = TvEpisodeModel(
    id: 1,
    episodeNumber: 1,
    name: 'name',
    overview: 'overview',
    seasonNumber: 1,
    showId: 1,
    runtime: 24,
    stillPath: 'stillPath',
  );

  const tTvEpisode = TvEpisode(
    id: 1,
    episodeNumber: 1,
    name: 'name',
    overview: 'overview',
    seasonNumber: 1,
    showId: 1,
    runtime: 24,
    stillPath: 'stillPath',
  );

  const t2TvEpisodeModel = testTvEpisodeModel;

  test('should be a subclass of TvEpisode entity', () {
    final result = tTvEpisodeModel.toEntity();
    expect(result, tTvEpisode);
  });

  group('fromJson', () {
    test('should be valid TvEpisodeModel', () {
      // arrange
      final episodeJson = json.decode(readJson('dummy_data/tv_episode.json'));
      // act
      final result = TvEpisodeModel.fromJson(episodeJson);
      // assert
      expect(result, t2TvEpisodeModel);
    });
  });
}
