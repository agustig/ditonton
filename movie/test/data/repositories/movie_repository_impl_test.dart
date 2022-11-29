import 'dart:io';

import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/data/datasources/movie_local_data_source.dart';
import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:movie/data/models/movie_detail_model.dart';
import 'package:movie/data/models/movie_model.dart';
import 'package:movie/data/repositories/movie_repository_impl.dart';
import 'package:movie/domain/entities/movie.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieRemoteDataSource extends Mock implements MovieRemoteDataSource {}

class MockMovieLocalDataSource extends Mock implements MovieLocalDataSource {}

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();
    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tMovieModel = MovieModel(
    id: 557,
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    title: 'Spider-Man',
  );

  const tMovie = Movie(
    id: 557,
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    title: 'Spider-Man',
  );

  final tMovieModelList = <MovieModel>[tMovieModel];
  final tMovieList = <Movie>[tMovie];

  group('Now Playing Movies', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getNowPlayingMovies())
            .thenAnswer((_) async => tMovieModelList);
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(() => mockRemoteDataSource.getNowPlayingMovies());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return Tls failure when the the apiServer certificate is not valid',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getNowPlayingMovies())
            .thenThrow(const TlsException());
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(() => mockRemoteDataSource.getNowPlayingMovies());
        expect(result, equals(const Left(TlsFailure('Certificate error'))));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getNowPlayingMovies())
            .thenThrow(ServerException());
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(() => mockRemoteDataSource.getNowPlayingMovies());
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getNowPlayingMovies()).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getNowPlayingMovies();
        // assert
        verify(() => mockRemoteDataSource.getNowPlayingMovies());
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Popular Movies', () {
    test(
      'should return movie list when call to data source is success',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getPopularMovies())
            .thenAnswer((_) async => tMovieModelList);
        // act
        final result = await repository.getPopularMovies();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return Tls failure when the the apiServer certificate is not valid',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getPopularMovies())
            .thenThrow(const TlsException());
        // act
        final result = await repository.getPopularMovies();
        // assert
        verify(() => mockRemoteDataSource.getPopularMovies());
        expect(result, equals(const Left(TlsFailure('Certificate error'))));
      },
    );

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getPopularMovies())
            .thenThrow(ServerException());
        // act
        final result = await repository.getPopularMovies();
        // assert
        expect(result, const Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when device is not connected to the internet',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getPopularMovies()).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getPopularMovies();
        // assert
        expect(result,
            const Left(ConnectionFailure('Failed to connect to the network')));
      },
    );
  });

  group('Top Rated Movies', () {
    test(
      'should return movie list when call to data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTopRatedMovies())
            .thenAnswer((_) async => tMovieModelList);
        // act
        final result = await repository.getTopRatedMovies();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return Tls failure when the the apiServer certificate is not valid',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTopRatedMovies())
            .thenThrow(const TlsException());
        // act
        final result = await repository.getTopRatedMovies();
        // assert
        verify(() => mockRemoteDataSource.getTopRatedMovies());
        expect(result, equals(const Left(TlsFailure('Certificate error'))));
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTopRatedMovies())
            .thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedMovies();
        // assert
        expect(result, const Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTopRatedMovies()).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTopRatedMovies();
        // assert
        expect(result,
            const Left(ConnectionFailure('Failed to connect to the network')));
      },
    );
  });

  group('Get Movie Detail', () {
    const tId = 1;
    const tMovieResponse = MovieDetailModel(
      genres: [GenreModel(id: 1, name: 'Action')],
      id: 1,
      overview: 'overview',
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      runtime: 120,
      title: 'title',
      voteAverage: 1,
    );

    test(
      'should return Movie data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getMovieDetail(tId))
            .thenAnswer((_) async => tMovieResponse);
        // act
        final result = await repository.getMovieDetail(tId);
        // assert
        verify(() => mockRemoteDataSource.getMovieDetail(tId));
        expect(result, equals(const Right(testMovieDetail)));
      },
    );

    test(
      'should return Tls failure when the the apiServer certificate is not valid',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getMovieDetail(tId))
            .thenThrow(const TlsException());
        // act
        final result = await repository.getMovieDetail(tId);
        // assert
        verify(() => mockRemoteDataSource.getMovieDetail(tId));
        expect(result, equals(const Left(TlsFailure('Certificate error'))));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getMovieDetail(tId))
            .thenThrow(ServerException());
        // act
        final result = await repository.getMovieDetail(tId);
        // assert
        verify(() => mockRemoteDataSource.getMovieDetail(tId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getMovieDetail(tId)).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getMovieDetail(tId);
        // assert
        verify(() => mockRemoteDataSource.getMovieDetail(tId));
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Get Movie Recommendations', () {
    final tMovieList = <MovieModel>[];
    const tId = 1;

    test(
      'should return data (movie list) when the call is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getMovieRecommendations(tId))
            .thenAnswer((_) async => tMovieList);
        // act
        final result = await repository.getMovieRecommendations(tId);
        // assert
        verify(() => mockRemoteDataSource.getMovieRecommendations(tId));
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tMovieList));
      },
    );

    test(
      'should return Tls failure when the the apiServer certificate is not valid',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getMovieRecommendations(tId))
            .thenThrow(const TlsException());
        // act
        final result = await repository.getMovieRecommendations(tId);
        // assert
        verify(() => mockRemoteDataSource.getMovieRecommendations(tId));
        expect(result, equals(const Left(TlsFailure('Certificate error'))));
      },
    );

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getMovieRecommendations(tId))
            .thenThrow(ServerException());
        // act
        final result = await repository.getMovieRecommendations(tId);
        // assert
        verify(() => mockRemoteDataSource.getMovieRecommendations(tId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to the internet',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getMovieRecommendations(tId)).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getMovieRecommendations(tId);
        // assert
        verify(() => mockRemoteDataSource.getMovieRecommendations(tId));
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Seach Movies', () {
    const tQuery = 'spiderman';

    test(
      'should return movie list when call to data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.searchMovies(tQuery))
            .thenAnswer((_) async => tMovieModelList);
        // act
        final result = await repository.searchMovies(tQuery);
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
      'should return Tls failure when the the apiServer certificate is not valid',
      () async {
        // arrange
        when(() => mockRemoteDataSource.searchMovies(tQuery))
            .thenThrow(const TlsException());
        // act
        final result = await repository.searchMovies(tQuery);
        // assert
        verify(() => mockRemoteDataSource.searchMovies(tQuery));
        expect(result, equals(const Left(TlsFailure('Certificate error'))));
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.searchMovies(tQuery))
            .thenThrow(ServerException());
        // act
        final result = await repository.searchMovies(tQuery);
        // assert
        expect(result, const Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(() => mockRemoteDataSource.searchMovies(tQuery)).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.searchMovies(tQuery);
        // assert
        expect(result,
            const Left(ConnectionFailure('Failed to connect to the network')));
      },
    );
  });

  group('save watchlist', () {
    test(
      'should return success message when saving successful',
      () async {
        // arrange
        when(() => mockLocalDataSource.insertWatchlist(testMovieTable))
            .thenAnswer((_) async => 'Added to Watchlist');
        // act
        final result = await repository.saveWatchlist(testMovieDetail);
        // assert
        expect(result, const Right('Added to Watchlist'));
      },
    );

    test(
      'should return DatabaseFailure when saving unsuccessful',
      () async {
        // arrange
        when(() => mockLocalDataSource.insertWatchlist(testMovieTable))
            .thenThrow(DatabaseException('Failed to add watchlist'));
        // act
        final result = await repository.saveWatchlist(testMovieDetail);
        // assert
        expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
      },
    );
  });

  group('remove watchlist', () {
    test(
      'should return success message when remove successful',
      () async {
        // arrange
        when(() => mockLocalDataSource.removeWatchlist(testMovieTable))
            .thenAnswer((_) async => 'Removed from watchlist');
        // act
        final result = await repository.removeWatchlist(testMovieDetail);
        // assert
        expect(result, const Right('Removed from watchlist'));
      },
    );

    test(
      'should return DatabaseFailure when remove unsuccessful',
      () async {
        // arrange
        when(() => mockLocalDataSource.removeWatchlist(testMovieTable))
            .thenThrow(DatabaseException('Failed to remove watchlist'));
        // act
        final result = await repository.removeWatchlist(testMovieDetail);
        // assert
        expect(
            result, const Left(DatabaseFailure('Failed to remove watchlist')));
      },
    );
  });

  group('get watchlist status', () {
    test(
      'should return watch status whether data is found',
      () async {
        // arrange
        const tId = 1;
        when(() => mockLocalDataSource.getMovieById(tId))
            .thenAnswer((_) async => null);
        // act
        final result = await repository.isAddedToWatchlist(tId);
        // assert
        expect(result, false);
      },
    );
  });

  group('get watchlist movies', () {
    test(
      'should return list of Movies',
      () async {
        // arrange
        when(() => mockLocalDataSource.getWatchlistMovies())
            .thenAnswer((_) async => [testMovieTable]);
        // act
        final result = await repository.getWatchlistMovies();
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testWatchlistMovie]);
      },
    );
  });
}
