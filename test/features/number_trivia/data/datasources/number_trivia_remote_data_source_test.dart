import 'dart:convert';

import 'package:estudo_clean_architecture/core/error/exceptions.dart';
import 'package:estudo_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:estudo_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoreDataSourceImpl dataSource;

  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoreDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSucess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should preform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        //arrange
        setUpMockHttpClientSucess200();
        //act
        dataSource.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/$tNumber',
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );

    test('should return NumberTrivia when the response code is 200(sucess)',
        () async {
      //arrange
      setUpMockHttpClientSucess200();
      //act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the repsonse code is 404 or ohter',
        () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = dataSource.getConcreteNumberTrivia;
      //assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should preform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        //arrange
        setUpMockHttpClientSucess200();
        //act
        dataSource.getRandomNumberTrivia();
        //assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );

    test('should return NumberTrivia when the response code is 200(sucess)',
        () async {
      //arrange
      setUpMockHttpClientSucess200();
      //act
      final result = await dataSource.getRandomNumberTrivia();
      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the repsonse code is 404 or ohter',
        () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = dataSource.getRandomNumberTrivia();
      //assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
