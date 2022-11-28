import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie/data/models/movie_model.dart';
import 'package:movie/data/models/movie_response.dart';

import '../../json_reader.dart';

void main() {
  const tMovieModel = MovieModel(
    id: 1,
    overview: "Overview",
    posterPath: "/path.jpg",
    title: "Title",
  );
  const tMovieResponseModel =
      MovieResponse(movieList: <MovieModel>[tMovieModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/now_playing.json'));
      // act
      final result = MovieResponse.fromJson(jsonMap);
      // assert
      expect(result, tMovieResponseModel);
    });
  });
}
