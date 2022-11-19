import 'dart:convert';

import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_tv_objects.dart';
import '../../json_reader.dart';

void main() {
  final tTvResponseModel = TvResponse(tvList: testTvModelList);

  group('fromJson', () {
    test('should return a valid TvModel from Json', () async {
      // arrange
      final jsonData = json.decode(readJson('dummy_data/on_the_air_tv.json'));
      // act
      final result = TvResponse.fromJson(jsonData);
      // assert
      expect(result, tTvResponseModel);
    });
  });
}
