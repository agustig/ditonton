import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:tv/presentation/widgets/season_tile.dart';
import 'package:tv/presentation/widgets/tv_episode_list_tile.dart';

import '../../dummy_data/dummy_tv_objects.dart';

class MockTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

void main() {
  late MockTvDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockTvDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  final tTvDetail = testTvDetail;
  final tTvList = testTvList;

  testWidgets(
    'Page should display center progress bar when loading',
    (tester) async {
      // arrange
      when(() => mockBloc.state).thenAnswer((_) => TvDetailLoading());
      // act
      final centerFinder = find.byType(Center);
      final progressBarFinder = find.byType(CircularProgressIndicator);
      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      // assert
      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    },
  );

  group('Tv Detail Loaded', () {
    final tTvDetailDataState = TvDetailHasData(
      detail: tTvDetail,
      tvRecommendations: tTvList,
      isOnWatchlist: false,
    );

    testWidgets(
      'should display DetailContent when data is loaded',
      (tester) async {
        // arrange
        when(() => mockBloc.state).thenAnswer((_) => tTvDetailDataState);
        // act
        final detailContentFinder = find.byType(DetailTvContent);
        final draggableSheetFinder = find.byType(DraggableScrollableSheet);
        final findWatchlistIcon = find.byIcon(Icons.add);
        final seasonSelectedFinder = find.byKey(const Key('Selected: -1'));
        final seasonTileFinder = find.byType(SeasonTile);
        final recommendationSectionFinder = find.text('Recommendations');
        await tester
            .pumpWidget(makeTestableWidget(TvDetailPage(id: testTv.id)));
        verifyNever(() => mockBloc.add(FetchDetail(testTv.id)));
        // assert
        expect(detailContentFinder, findsOneWidget);
        expect(draggableSheetFinder, findsOneWidget);
        expect(findWatchlistIcon, findsOneWidget);
        expect(seasonSelectedFinder, findsOneWidget);
        expect(seasonTileFinder, findsOneWidget);
        expect(recommendationSectionFinder, findsOneWidget);
      },
    );

    testWidgets(
      'should display DetailContent with check watchlist icon when tv is added on watchlist',
      (tester) async {
        // arrange
        when(() => mockBloc.state).thenAnswer(
          (_) => tTvDetailDataState.changeAttr(isOnWatchlist: true),
        );
        // act
        final findWatchlistIcon = find.byIcon(Icons.check);
        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
        // assert
        expect(findWatchlistIcon, findsOneWidget);
      },
    );

    testWidgets(
      'should display DetailContent with Episode list when tvSeason is selected',
      (tester) async {
        // arrange
        when(() => mockBloc.state).thenAnswer(
          (_) => tTvDetailDataState.changeAttr(expandedSeason: testTvSeason),
        );
        // act
        final seasonSelectedFinder = find.byKey(Key(
          'Selected: ${testTvSeason.id}',
        ));
        final episodeSectionFinder = find.text('Episodes:');
        final episodeListTileFinder = find.byType(TvEpisodeListTile);
        await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
        // assert
        expect(seasonSelectedFinder, findsOneWidget);
        expect(episodeSectionFinder, findsOneWidget);
        expect(episodeListTileFinder, findsOneWidget);
      },
    );
  });

  testWidgets(
    'Page should display text with message when Error',
    (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(TvDetailError('Error message'));
      // act
      final keyFinder = find.byKey(const Key('error_message'));
      final textFinder = find.text('Error message');
      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      // assert
      expect(keyFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display SizedBox with key when state is empty',
    (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(TvDetailEmpty());
      // act
      final keyFinder = find.byKey(const Key('empty_state'));
      final sizedBoxFinder = find.byType(SizedBox);
      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      // assert
      expect(keyFinder, findsOneWidget);
      expect(sizedBoxFinder, findsOneWidget);
    },
  );
}
