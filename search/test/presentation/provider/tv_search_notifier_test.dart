import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/presentation/provider/tv_search_notifier.dart';
import 'package:tv/tv.dart' show Tv;

import '../../helpers/test_helpers.mocks.dart';

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

  const testTv = Tv(
    id: 31586,
    name: 'La Reina del Sur',
    overview:
        "After years of blood, sweat and tears, a woman of humble origin ends up becoming a drug trafficking legend, with all that that means...",
    posterPath: "/p11t8ckTC6EiuVw5FGFKdc2Z7GH.jpg",
  );

  final tTvList = [testTv];
  const tQuery = 'reina';

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
        .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchTvSearch(tQuery);
    // assert
    expect(notifier.state, RequestState.error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
