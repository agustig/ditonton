import 'package:movie/movie.dart' show Movie;
import 'package:tv/tv.dart' show Tv;

const tTv = Tv(
  id: 31586,
  name: 'La Reina del Sur',
  overview:
      "After years of blood, sweat and tears, a woman of humble origin ends up becoming a drug trafficking legend, with all that that means...",
  posterPath: "/p11t8ckTC6EiuVw5FGFKdc2Z7GH.jpg",
);

const tMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final tTvList = [tTv];
final tMovieList = [tMovie];
const tQuery = 'la';
