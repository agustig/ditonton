import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_tv_objects.dart';
import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    name: 'title',
  );

  final tTv = Tv(
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    name: 'title',
  );

  test('should be a subclass of Tv entity', () {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });

  group('fromJson', () {
    test('should be a TvModel', () async {
      // arrange
      final jsonRaw = json.decode(readJson('dummy_data/on_the_air_tv.json'));
      final jsonData = jsonRaw['results'][0];
      // act
      final result = TvModel.fromJson(jsonData);
      // assert
      expect(result, testTvModel);
    });
  });
}
