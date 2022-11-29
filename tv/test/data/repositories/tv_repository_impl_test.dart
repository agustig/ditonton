import 'dart:io';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/data/repositories/tv_repository_impl.dart';

import '../../dummy_data/dummy_tv_objects.dart';

class MockTvLocalDataSource extends Mock implements TvLocalDataSource {}

class MockTvRemoteDataSource extends Mock implements TvRemoteDataSource {}

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;
  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvModelList = testTvModelList;
  final tTvList = testTvList;

  group('On The Air Tvs', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getOnTheAirTvs())
            .thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getOnTheAirTvs();
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return Tls failure when the the apiServer certificate is not valid',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getOnTheAirTvs())
            .thenThrow(const TlsException());
        // act
        final result = await repository.getOnTheAirTvs();
        // assert
        verify(() => mockRemoteDataSource.getOnTheAirTvs());
        expect(result, equals(const Left(TlsFailure('Certificate error'))));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getOnTheAirTvs())
            .thenThrow(ServerException());
        // act
        final result = await repository.getOnTheAirTvs();
        // assert
        verify(() => mockRemoteDataSource.getOnTheAirTvs());
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getOnTheAirTvs()).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getOnTheAirTvs();
        // assert
        verify(() => mockRemoteDataSource.getOnTheAirTvs());
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Popular Tvs', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getPopularTvs())
            .thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getPopularTvs();
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return Tls failure when the the apiServer certificate is not valid',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getPopularTvs())
            .thenThrow(const TlsException());
        // act
        final result = await repository.getPopularTvs();
        // assert
        verify(() => mockRemoteDataSource.getPopularTvs());
        expect(result, equals(const Left(TlsFailure('Certificate error'))));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getPopularTvs())
            .thenThrow(ServerException());
        // act
        final result = await repository.getPopularTvs();
        // assert
        verify(() => mockRemoteDataSource.getPopularTvs());
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getPopularTvs()).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getPopularTvs();
        // assert
        verify(() => mockRemoteDataSource.getPopularTvs());
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Top Rated Tvs', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTopRatedTvs())
            .thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getTopRatedTvs();
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return Tls failure when the the apiServer certificate is not valid',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTopRatedTvs())
            .thenThrow(const TlsException());
        // act
        final result = await repository.getTopRatedTvs();
        // assert
        verify(() => mockRemoteDataSource.getTopRatedTvs());
        expect(result, equals(const Left(TlsFailure('Certificate error'))));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTopRatedTvs())
            .thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedTvs();
        // assert
        verify(() => mockRemoteDataSource.getTopRatedTvs());
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTopRatedTvs()).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTopRatedTvs();
        // assert
        verify(() => mockRemoteDataSource.getTopRatedTvs());
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Get Tv Detail', () {
    const tId = 1;
    final tTvDetailModel = testTvDetailModel;
    final tTvDetail = testTvDetail;

    test(
      'should return Tv data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTvDetail(tId))
            .thenAnswer((_) async => tTvDetailModel);
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(() => mockRemoteDataSource.getTvDetail(tId));
        expect(result, equals(Right(tTvDetail)));
      },
    );

    test(
      'should return Tls failure when the the apiServer certificate is not valid',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTvDetail(tId))
            .thenThrow(const TlsException());
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(() => mockRemoteDataSource.getTvDetail(tId));
        expect(result, equals(const Left(TlsFailure('Certificate error'))));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTvDetail(tId))
            .thenThrow(ServerException());
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(() => mockRemoteDataSource.getTvDetail(tId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTvDetail(tId)).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(() => mockRemoteDataSource.getTvDetail(tId));
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Tv Recommendations', () {
    const tId = 1;
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTvRecommendations(tId))
            .thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getTvRecommendations(tId);
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return Tls failure when the the apiServer certificate is not valid',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTvRecommendations(tId))
            .thenThrow(const TlsException());
        // act
        final result = await repository.getTvRecommendations(tId);
        // assert
        verify(() => mockRemoteDataSource.getTvRecommendations(tId));
        expect(result, equals(const Left(TlsFailure('Certificate error'))));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTvRecommendations(tId))
            .thenThrow(ServerException());
        // act
        final result = await repository.getTvRecommendations(tId);
        // assert
        verify(() => mockRemoteDataSource.getTvRecommendations(tId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTvRecommendations(tId)).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvRecommendations(tId);
        // assert
        verify(() => mockRemoteDataSource.getTvRecommendations(tId));
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Search Tvs', () {
    const tQuery = 'reina';
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.searchTvs(tQuery))
            .thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.searchTvs(tQuery);
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return Tls failure when the the apiServer certificate is not valid',
      () async {
        // arrange
        when(() => mockRemoteDataSource.searchTvs(tQuery))
            .thenThrow(const TlsException());
        // act
        final result = await repository.searchTvs(tQuery);
        // assert
        verify(() => mockRemoteDataSource.searchTvs(tQuery));
        expect(result, equals(const Left(TlsFailure('Certificate error'))));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.searchTvs(tQuery))
            .thenThrow(ServerException());
        // act
        final result = await repository.searchTvs(tQuery);
        // assert
        verify(() => mockRemoteDataSource.searchTvs(tQuery));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(() => mockRemoteDataSource.searchTvs(tQuery)).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.searchTvs(tQuery);
        // assert
        verify(() => mockRemoteDataSource.searchTvs(tQuery));
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('save watchlist', () {
    test(
      'should return success message when saving successful',
      () async {
        // arrange
        when(() => mockLocalDataSource.insertTvWatchlist(testTvTable))
            .thenAnswer((_) async => 'Added to Watchlist');
        // act
        final result = await repository.saveWatchlist(testTvWatchlist);
        // assert
        expect(result, const Right('Added to Watchlist'));
      },
    );

    test(
      'should return DatabaseFailure when saving unsuccessful',
      () async {
        // arrange
        when(() => mockLocalDataSource.insertTvWatchlist(testTvTable))
            .thenThrow(DatabaseException('Failed to add watchlist'));
        // act
        final result = await repository.saveWatchlist(testTvWatchlist);
        // assert
        expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
      },
    );
  });

  group('remove watchlist', () {
    test(
      'should return success message when removing is successful',
      () async {
        // arrange
        when(() => mockLocalDataSource.removeTvWatchlist(testTvTable))
            .thenAnswer((_) async => 'Removed from Watchlist');
        // act
        final result = await repository.removeTvWatchlist(testTvWatchlist);
        // assert
        expect(result, const Right('Removed from Watchlist'));
      },
    );

    test(
      'should return DatabaseFailure when removing in unsuccessful',
      () async {
        // arrange
        when(() => mockLocalDataSource.removeTvWatchlist(testTvTable))
            .thenThrow(DatabaseException('Failed to remove watchlist'));
        // act
        final result = await repository.removeTvWatchlist(testTvWatchlist);
        // assert
        expect(
            result, const Left(DatabaseFailure('Failed to remove watchlist')));
      },
    );
  });

  group('get Tv watchlist status', () {
    test(
      'should return watch status whether data is found',
      () async {
        // arrange
        const tId = 1;
        when(() => mockLocalDataSource.getTvById(tId))
            .thenAnswer((_) async => null);
        // act
        final result = await repository.isAddedTvToWatchlist(tId);
        // assert
        expect(result, false);
      },
    );

    test(
      'should return watch status whether data is true',
      () async {
        // arrange
        const tId = 1;
        when(() => mockLocalDataSource.getTvById(tId))
            .thenAnswer((_) async => testTvTable);
        // act
        final result = await repository.isAddedTvToWatchlist(tId);
        // assert
        expect(result, true);
      },
    );
  });

  group('get watchlist tvs', () {
    test(
      'should return list of Tvs',
      () async {
        // arrange
        when(() => mockLocalDataSource.getWatchlistTvs())
            .thenAnswer((_) async => [testTvTable]);
        // act
        final result = await repository.getWatchlistTvs();
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testTvWatchlistResult]);
      },
    );
  });
}
