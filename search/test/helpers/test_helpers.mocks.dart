// Mocks generated by Mockito 5.3.2 from annotations
// in search/test/helpers/test_helpers.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:core/core.dart' as _i6;
import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:movie/domain/entities/movie.dart' as _i7;
import 'package:movie/domain/entities/movie_detail.dart' as _i8;
import 'package:movie/movie.dart' as _i3;
import 'package:search/domain/usecase/search_movies.dart' as _i11;
import 'package:search/domain/usecase/search_tvs.dart' as _i12;
import 'package:tv/domain/entities/tv.dart' as _i9;
import 'package:tv/domain/entities/tv_detail.dart' as _i10;
import 'package:tv/tv.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeMovieRepository_1 extends _i1.SmartFake
    implements _i3.MovieRepository {
  _FakeMovieRepository_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeTvRepository_2 extends _i1.SmartFake implements _i4.TvRepository {
  _FakeTvRepository_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MovieRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockMovieRepository extends _i1.Mock implements _i3.MovieRepository {
  MockMovieRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>> getNowPlayingMovies() =>
      (super.noSuchMethod(
        Invocation.method(
          #getNowPlayingMovies,
          [],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>>.value(
            _FakeEither_0<_i6.Failure, List<_i7.Movie>>(
          this,
          Invocation.method(
            #getNowPlayingMovies,
            [],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>> getPopularMovies() =>
      (super.noSuchMethod(
        Invocation.method(
          #getPopularMovies,
          [],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>>.value(
            _FakeEither_0<_i6.Failure, List<_i7.Movie>>(
          this,
          Invocation.method(
            #getPopularMovies,
            [],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>> getTopRatedMovies() =>
      (super.noSuchMethod(
        Invocation.method(
          #getTopRatedMovies,
          [],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>>.value(
            _FakeEither_0<_i6.Failure, List<_i7.Movie>>(
          this,
          Invocation.method(
            #getTopRatedMovies,
            [],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, _i8.MovieDetail>> getMovieDetail(
          int? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMovieDetail,
          [id],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, _i8.MovieDetail>>.value(
            _FakeEither_0<_i6.Failure, _i8.MovieDetail>(
          this,
          Invocation.method(
            #getMovieDetail,
            [id],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, _i8.MovieDetail>>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>> getMovieRecommendations(
          int? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMovieRecommendations,
          [id],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>>.value(
            _FakeEither_0<_i6.Failure, List<_i7.Movie>>(
          this,
          Invocation.method(
            #getMovieRecommendations,
            [id],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>> searchMovies(
          String? query) =>
      (super.noSuchMethod(
        Invocation.method(
          #searchMovies,
          [query],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>>.value(
            _FakeEither_0<_i6.Failure, List<_i7.Movie>>(
          this,
          Invocation.method(
            #searchMovies,
            [query],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, String>> saveWatchlist(
          _i8.MovieDetail? movie) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveWatchlist,
          [movie],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, String>>.value(
            _FakeEither_0<_i6.Failure, String>(
          this,
          Invocation.method(
            #saveWatchlist,
            [movie],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, String>>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, String>> removeWatchlist(
          _i8.MovieDetail? movie) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeWatchlist,
          [movie],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, String>>.value(
            _FakeEither_0<_i6.Failure, String>(
          this,
          Invocation.method(
            #removeWatchlist,
            [movie],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, String>>);
  @override
  _i5.Future<bool> isAddedToWatchlist(int? id) => (super.noSuchMethod(
        Invocation.method(
          #isAddedToWatchlist,
          [id],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>> getWatchlistMovies() =>
      (super.noSuchMethod(
        Invocation.method(
          #getWatchlistMovies,
          [],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>>.value(
            _FakeEither_0<_i6.Failure, List<_i7.Movie>>(
          this,
          Invocation.method(
            #getWatchlistMovies,
            [],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>>);
}

/// A class which mocks [TvRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockTvRepository extends _i1.Mock implements _i4.TvRepository {
  MockTvRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>> getOnTheAirTvs() =>
      (super.noSuchMethod(
        Invocation.method(
          #getOnTheAirTvs,
          [],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>>.value(
            _FakeEither_0<_i6.Failure, List<_i9.Tv>>(
          this,
          Invocation.method(
            #getOnTheAirTvs,
            [],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>> getPopularTvs() =>
      (super.noSuchMethod(
        Invocation.method(
          #getPopularTvs,
          [],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>>.value(
            _FakeEither_0<_i6.Failure, List<_i9.Tv>>(
          this,
          Invocation.method(
            #getPopularTvs,
            [],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>> getTopRatedTvs() =>
      (super.noSuchMethod(
        Invocation.method(
          #getTopRatedTvs,
          [],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>>.value(
            _FakeEither_0<_i6.Failure, List<_i9.Tv>>(
          this,
          Invocation.method(
            #getTopRatedTvs,
            [],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, _i10.TvDetail>> getTvDetail(int? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTvDetail,
          [id],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, _i10.TvDetail>>.value(
            _FakeEither_0<_i6.Failure, _i10.TvDetail>(
          this,
          Invocation.method(
            #getTvDetail,
            [id],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, _i10.TvDetail>>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>> getTvRecommendations(
          int? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTvRecommendations,
          [id],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>>.value(
            _FakeEither_0<_i6.Failure, List<_i9.Tv>>(
          this,
          Invocation.method(
            #getTvRecommendations,
            [id],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>> searchTvs(String? query) =>
      (super.noSuchMethod(
        Invocation.method(
          #searchTvs,
          [query],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>>.value(
            _FakeEither_0<_i6.Failure, List<_i9.Tv>>(
          this,
          Invocation.method(
            #searchTvs,
            [query],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, String>> saveWatchlist(
          _i10.TvDetail? movie) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveWatchlist,
          [movie],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, String>>.value(
            _FakeEither_0<_i6.Failure, String>(
          this,
          Invocation.method(
            #saveWatchlist,
            [movie],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, String>>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, String>> removeTvWatchlist(
          _i10.TvDetail? movie) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeTvWatchlist,
          [movie],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, String>>.value(
            _FakeEither_0<_i6.Failure, String>(
          this,
          Invocation.method(
            #removeTvWatchlist,
            [movie],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, String>>);
  @override
  _i5.Future<bool> isAddedTvToWatchlist(int? id) => (super.noSuchMethod(
        Invocation.method(
          #isAddedTvToWatchlist,
          [id],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>> getWatchlistTvs() =>
      (super.noSuchMethod(
        Invocation.method(
          #getWatchlistTvs,
          [],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>>.value(
            _FakeEither_0<_i6.Failure, List<_i9.Tv>>(
          this,
          Invocation.method(
            #getWatchlistTvs,
            [],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>>);
}

/// A class which mocks [SearchMovies].
///
/// See the documentation for Mockito's code generation for more information.
class MockSearchMovies extends _i1.Mock implements _i11.SearchMovies {
  MockSearchMovies() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.MovieRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeMovieRepository_1(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i3.MovieRepository);
  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>> execute(String? query) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [query],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>>.value(
            _FakeEither_0<_i6.Failure, List<_i7.Movie>>(
          this,
          Invocation.method(
            #execute,
            [query],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, List<_i7.Movie>>>);
}

/// A class which mocks [SearchTvs].
///
/// See the documentation for Mockito's code generation for more information.
class MockSearchTvs extends _i1.Mock implements _i12.SearchTvs {
  MockSearchTvs() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.TvRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeTvRepository_2(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i4.TvRepository);
  @override
  _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>> execute(String? query) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [query],
        ),
        returnValue: _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>>.value(
            _FakeEither_0<_i6.Failure, List<_i9.Tv>>(
          this,
          Invocation.method(
            #execute,
            [query],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i6.Failure, List<_i9.Tv>>>);
}
