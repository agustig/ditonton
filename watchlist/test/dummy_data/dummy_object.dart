import 'package:movie/movie.dart';
import 'package:tv/tv.dart' show Tv;

const testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testWatchlistMovieList = [testWatchlistMovie];

const testWatchlistTv = Tv(
  id: 31586,
  name: 'La Reina del Sur',
  overview:
      'After years of blood, sweat and tears, a woman of humble origin ends up becoming a drug trafficking legend, with all that that means...',
  posterPath: '/uBTlJDdPpRxYTfUnKw4wbuIGSEK.jpg',
);

final testWatchlistTvList = [testWatchlistTv];
