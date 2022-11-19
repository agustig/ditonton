import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_tv_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetTopRatedTvs mockGetTopRatedTvs;
  late TopRatedTvsNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    notifier = TopRatedTvsNotifier(mockGetTopRatedTvs)
      ..addListener(() => listenerCallCount++);
  });

  final tTvList = testTvList;

  test('should change state to loading when usecase is called', () {
    // arrange
    when(mockGetTopRatedTvs.execute()).thenAnswer((_) async => Right(tTvList));
    // act
    notifier.fetchTopRatedTvs();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetTopRatedTvs.execute()).thenAnswer((_) async => Right(tTvList));
    // act
    await notifier.fetchTopRatedTvs();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvList, tTvList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTopRatedTvs.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchTopRatedTvs();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
