import 'package:core/data/models/genre_model.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:tv/data/models/tv_episode_model.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/models/tv_season_model.dart';
import 'package:tv/data/models/tv_table.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';

const testTvModel = TvModel(
  id: 31586,
  name: 'La Reina del Sur',
  overview:
      "After years of blood, sweat and tears, a woman of humble origin ends up becoming a drug trafficking legend, with all that that means...",
  posterPath: "/p11t8ckTC6EiuVw5FGFKdc2Z7GH.jpg",
);

const testTvTable = TvTable(
  id: 31586,
  name: 'La Reina del Sur',
  overview:
      'After years of blood, sweat and tears, a woman of humble origin ends up becoming a drug trafficking legend, with all that that means...',
  posterPath: '/uBTlJDdPpRxYTfUnKw4wbuIGSEK.jpg',
);

const testTvWatchlistResult = Tv(
  id: 31586,
  name: 'La Reina del Sur',
  overview:
      'After years of blood, sweat and tears, a woman of humble origin ends up becoming a drug trafficking legend, with all that that means...',
  posterPath: '/uBTlJDdPpRxYTfUnKw4wbuIGSEK.jpg',
);

final testTvWatchlist = TvDetail(
    id: 31586,
    name: 'La Reina del Sur',
    overview:
        'After years of blood, sweat and tears, a woman of humble origin ends up becoming a drug trafficking legend, with all that that means...',
    posterPath: '/uBTlJDdPpRxYTfUnKw4wbuIGSEK.jpg',
    seasons: const []);

final testTvMap = {
  'id': 31586,
  'name': 'La Reina del Sur',
  'overview':
      'After years of blood, sweat and tears, a woman of humble origin ends up becoming a drug trafficking legend, with all that that means...',
  'poster_path': '/uBTlJDdPpRxYTfUnKw4wbuIGSEK.jpg',
};

const testTvEpisodeModel = TvEpisodeModel(
  id: 757251,
  episodeNumber: 1,
  name: 'Episode 1',
  overview:
      'Teresa is a humble woman who gets caught up in the underworld for the inheritance of a risky love.',
  seasonNumber: 1,
  showId: 31586,
  runtime: 42,
  stillPath: '/2uDeyXAUQAo21kVVJmG6yRq0ddn.jpg',
);

final testTvEpisodeMap = {
  'id': 757251,
  'episode_number': 1,
  'name': 'Episode 1',
  'overview':
      'Teresa is a humble woman who gets caught up in the underworld for the inheritance of a risky love.',
  'season_number': 1,
  'show_id': 31586,
  'season_id': 43098,
  'runtime': 42,
  'still_path': '/2uDeyXAUQAo21kVVJmG6yRq0ddn.jpg',
};

final testTvSeasonModel = TvSeasonModel(
  id: 43098,
  seasonNumber: 1,
  name: 'Season 1',
  overview:
      'A sudden turn of events forces a young Sinaloan money-changer into the dangerous world of drug trafficking, where she gradually rises in the ranks.',
  airDate: '2011-02-28',
  posterPath: '/uBTlJDdPpRxYTfUnKw4wbuIGSEK.jpg',
  episodes: const [testTvEpisodeModel],
);

final testTvSeasonModelWithOutEpisode = TvSeasonModel(
  id: 43098,
  seasonNumber: 1,
  name: 'Season 1',
  overview:
      'A sudden turn of events forces a young Sinaloan money-changer into the dangerous world of drug trafficking, where she gradually rises in the ranks.',
  airDate: '2011-02-28',
  posterPath: '/uBTlJDdPpRxYTfUnKw4wbuIGSEK.jpg',
  episodes: const [],
);

const testTvGenre = GenreModel(id: 18, name: 'Drama');

final testTvDetailModel = TvDetailModel(
  id: 31586,
  name: 'La Reina del Sur',
  overview:
      'After years of blood, sweat and tears, a woman of humble origin ends up becoming a drug trafficking legend, with all that that means...',
  genres: const [testTvGenre],
  numberOfEpisodes: 143,
  numberOfSeasons: 3,
  seasons: [testTvSeasonModel],
  posterPath: '/uBTlJDdPpRxYTfUnKw4wbuIGSEK.jpg',
  voteAverage: 7.8,
);

final testTvDetailModelWithOutEpisodes = TvDetailModel(
  id: 31586,
  name: 'La Reina del Sur',
  overview:
      'After years of blood, sweat and tears, a woman of humble origin ends up becoming a drug trafficking legend, with all that that means...',
  genres: const [testTvGenre],
  numberOfEpisodes: 143,
  numberOfSeasons: 3,
  seasons: [testTvSeasonModelWithOutEpisode],
  posterPath: '/uBTlJDdPpRxYTfUnKw4wbuIGSEK.jpg',
  voteAverage: 7.8,
);

final testTvModelList = [testTvModel];
final testTv = testTvModel.toEntity();
final testTvList = [testTv];
final testTvDetail = testTvDetailModel.toEntity();
final testTvSeason = testTvSeasonModel.toEntity();
final testTvDetailWithoutEpisodes = testTvDetailModelWithOutEpisodes.toEntity();
