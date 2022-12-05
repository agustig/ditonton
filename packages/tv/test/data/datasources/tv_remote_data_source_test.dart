import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:tv/data/models/tv_response.dart';
import 'package:tv/data/models/tv_season_model.dart';

import '../../json_reader.dart';

class MockApiHelper extends Mock implements ApiHelper {}

void main() {
  late TvRemoteDataSourceImpl dataSource;
  late MockApiHelper mockApiHelper;

  setUp(() {
    mockApiHelper = MockApiHelper();
    dataSource = TvRemoteDataSourceImpl(apiHelper: mockApiHelper);
  });

  group('get on The Air Tvs', () {
    final tTvList = TvResponse.fromJson(json.decode(
      readJson('dummy_data/on_the_air_tv.json'),
    )).tvList;

    const onTheAirTvsUrl = '$baseUrl/tv/on_the_air?$apiKey';
    const onTheAirTvsJson = 'dummy_data/on_the_air_tv.json';

    test(
      'should return list of TvModel when the response code is 200',
      () async {
        // arrange
        when(() => mockApiHelper.get(Uri.parse(onTheAirTvsUrl))).thenAnswer(
            (_) async => http.Response(readJson(onTheAirTvsJson), 200));
        // act
        final result = await dataSource.getOnTheAirTvs();
        // assert
        expect(result, tTvList);
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(() => mockApiHelper.get(Uri.parse(onTheAirTvsUrl)))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getOnTheAirTvs();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular Tvs', () {
    final tTvList = TvResponse.fromJson(json.decode(
      readJson('dummy_data/popular_tv.json'),
    )).tvList;

    const popularTvsUrl = '$baseUrl/tv/popular?$apiKey';
    const popularTvsJson = 'dummy_data/popular_tv.json';

    test(
      'should return list of tvs when response is success (200)',
      () async {
        // arrange
        when(() => mockApiHelper.get(Uri.parse(popularTvsUrl))).thenAnswer(
            (_) async => http.Response(readJson(popularTvsJson), 200));
        // act
        final result = await dataSource.getPopularTvs();
        // assert
        expect(result, tTvList);
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(() => mockApiHelper.get(Uri.parse(popularTvsUrl)))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getPopularTvs();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated Tvs', () {
    final tTvList = TvResponse.fromJson(json.decode(
      readJson('dummy_data/top_rated_tv.json'),
    )).tvList;

    const topRatedTvsUrl = '$baseUrl/tv/top_rated?$apiKey';
    const topRatedTvsJson = 'dummy_data/top_rated_tv.json';

    test(
      'should return list of tvs when response code is 200 ',
      () async {
        // arrange
        when(() => mockApiHelper.get(Uri.parse(topRatedTvsUrl))).thenAnswer(
            (_) async => http.Response(readJson(topRatedTvsJson), 200));
        // act
        final result = await dataSource.getTopRatedTvs();
        // assert
        expect(result, tTvList);
      },
    );

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(() => mockApiHelper.get(Uri.parse(topRatedTvsUrl)))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTopRatedTvs();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv detail', () {
    const tId = 1;
    const tSeasonNumber = 1;

    const tvDetailUrl = '$baseUrl/tv/$tId?$apiKey';
    const tvDetailJson = 'dummy_data/tv_detail.json';
    const tvSeasonUrl = '$baseUrl/tv/$tId/season/$tSeasonNumber?$apiKey';
    const tvSeasonJson = 'dummy_data/tv_season.json';

    final tTvDetail = TvDetailModel.fromJson(
      json.decode(readJson(tvDetailJson)),
    );
    final tTvSeason = TvSeasonModel.fromJson(
      json.decode(readJson(tvSeasonJson)),
    );
    tTvDetail.seasons.removeAt(0);
    tTvDetail.seasons.add(tTvSeason);

    test(
      'should return tv detail when the response code is 200',
      () async {
        // arrange
        when(() => mockApiHelper.get(Uri.parse(tvDetailUrl))).thenAnswer(
            (_) async => http.Response(readJson(tvDetailJson), 200));
        when(() => mockApiHelper.get(Uri.parse(tvSeasonUrl))).thenAnswer(
          (_) async => http.Response(readJson(tvSeasonJson), 200),
        );
        // act
        final result = await dataSource.getTvDetail(tId);
        // assert
        expect(result, equals(tTvDetail));
      },
    );

    test(
      'should throw Server Exception when the detail response code is 404 or other',
      () async {
        // arrange
        when(() => mockApiHelper.get(Uri.parse(tvDetailUrl)))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvDetail(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );

    test(
      'should throw Server Exception when the season response code is 404 or other',
      () async {
        // arrange
        when(() => mockApiHelper.get(Uri.parse(tvDetailUrl))).thenAnswer(
            (_) async => http.Response(readJson(tvDetailJson), 200));
        when(() => mockApiHelper.get(Uri.parse(tvSeasonUrl)))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvDetail(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv recommendations', () {
    final tTvList = TvResponse.fromJson(
            json.decode(readJson('dummy_data/tv_recommendations.json')))
        .tvList;
    const tId = 1;

    const tvRecommendationsUrl = '$baseUrl/tv/$tId/recommendations?$apiKey';
    const tvRecommendationsJson = 'dummy_data/tv_recommendations.json';

    test(
      'should return list of Tv Model when the response code is 200',
      () async {
        // arrange
        when(() => mockApiHelper.get(Uri.parse(tvRecommendationsUrl)))
            .thenAnswer((_) async =>
                http.Response(readJson(tvRecommendationsJson), 200));
        // act
        final result = await dataSource.getTvRecommendations(tId);
        // assert
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(() => mockApiHelper.get(Uri.parse(tvRecommendationsUrl)))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvRecommendations(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search tvs', () {
    final tSearchResult = TvResponse.fromJson(
            json.decode(readJson('dummy_data/search_reina_tv.json')))
        .tvList;
    const tQuery = 'Reina';

    const searchTvUrl = '$baseUrl/search/tv?$apiKey&query=$tQuery';
    const searchTvJson = 'dummy_data/search_reina_tv.json';

    test(
      'should return list of tvs when response code is 200',
      () async {
        // arrange
        when(() => mockApiHelper.get(Uri.parse(searchTvUrl))).thenAnswer(
            (_) async => http.Response(readJson(searchTvJson), 200));
        // act
        final result = await dataSource.searchTvs(tQuery);
        // assert
        expect(result, tSearchResult);
      },
    );

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(() => mockApiHelper.get(Uri.parse(searchTvUrl)))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.searchTvs(tQuery);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
