import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:tv/presentation/provider/tv_detail_notifier.dart';

import '../../dummy_data/dummy_tv_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tTvDetail = testTvDetail;
  final tTvList = testTvList;

  testWidgets('Page should display center progress bar when loading',
      (tester) async {
    // arrange
    when(mockNotifier.tvState).thenReturn(RequestState.loading);
    // act
    final centerFinder = find.byType(Center);
    final progressBarFinder = find.byType(CircularProgressIndicator);
    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
    // assert
    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  group('Tv Detail Loaded', () {
    setUp(() {
      // group arrange
      when(mockNotifier.tvState).thenReturn(RequestState.loaded);
      when(mockNotifier.tv).thenReturn(tTvDetail);
    });

    testWidgets('should display DetailContent when data is loaded',
        (tester) async {
      // arrange
      when(mockNotifier.recommendationState).thenReturn(RequestState.loading);
      when(mockNotifier.isTvAddedToWatchlist).thenAnswer((_) => false);
      when(mockNotifier.isSeasonExpanded(tTvDetail.seasons[0]))
          .thenAnswer((_) => false);
      // act
      final safeAreaFinder = find.byType(SafeArea);
      final detailContentFinder = find.byType(DetailTvContent);
      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      // assert
      expect(safeAreaFinder, findsOneWidget);
      expect(detailContentFinder, findsOneWidget);
    });

    testWidgets(
        'should display DetailContent with Recommendations ListView when loaded',
        (tester) async {
      // arrange
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvRecommendations).thenReturn(tTvList);
      when(mockNotifier.isTvAddedToWatchlist).thenAnswer((_) => false);
      when(mockNotifier.isSeasonExpanded(tTvDetail.seasons[0]))
          .thenAnswer((_) => false);
      // act
      final progressBarFinder = find.byType(ListView);
      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      // assert
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('should return episode info when season is expanded',
        (tester) async {
      // arrange
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvRecommendations).thenReturn(tTvList);
      when(mockNotifier.isTvAddedToWatchlist).thenAnswer((_) => false);
      when(mockNotifier.isSeasonExpanded(tTvDetail.seasons[0]))
          .thenAnswer((_) => true);
      // act
      final episodeInfoFinder = find.textContaining('Episodes:');
      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      // assert
      expect(episodeInfoFinder, findsOneWidget);
    });

    testWidgets(
        'should show checked watchlist button when tv is added to watchlist',
        (tester) async {
      // arrange
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvRecommendations).thenReturn(tTvList);
      when(mockNotifier.isTvAddedToWatchlist).thenAnswer((_) => true);
      when(mockNotifier.isSeasonExpanded(tTvDetail.seasons[0]))
          .thenAnswer((_) => false);
      // act
      final iconFinder = find.byIcon(Icons.check);
      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      // assert
      expect(iconFinder, findsOneWidget);
    });
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));

    expect(textFinder, findsOneWidget);
  });
}