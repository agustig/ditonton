import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_tv_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockSearchTvs mockSearchTvs;
  late TvSearchNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTvs = MockSearchTvs();
    notifier = TvSearchNotifier(mockSearchTvs)
      ..addListener(() => listenerCallCount++);
  });

  final tTvList = testTvList;
  final tQuery = 'reina';

  test('should change state to loading when usecase is called', () {
    // arrange
    when(mockSearchTvs.execute(tQuery)).thenAnswer((_) async => Right(tTvList));
    // act
    notifier.fetchTvSearch(tQuery);
    // assert
    expect(notifier.state, RequestState.loading);
    expect(listenerCallCount, 1);
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockSearchTvs.execute(tQuery)).thenAnswer((_) async => Right(tTvList));
    // act
    await notifier.fetchTvSearch(tQuery);
    // assert
    expect(notifier.state, RequestState.loaded);
    expect(notifier.searchResult, tTvList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockSearchTvs.execute(tQuery))
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchTvSearch(tQuery);
    // assert
    expect(notifier.state, RequestState.error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
