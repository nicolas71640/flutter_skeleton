import 'dart:convert';
import 'package:avecpaulette/core/error/exceptions.dart';
import 'package:avecpaulette/features/departmentsViewer/data/datasources/number_trivia_remote_data_source.dart';
import 'package:avecpaulette/features/departmentsViewer/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'package:http/http.dart' as http;
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient httpClient;

  setUp(() {
    httpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(httpClient);
  });

  group("getConcreteNumberTrivia", () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''shoud perform a GET request on URL with number being the endpoint
     and with application/json hearder''', () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      dataSource.getConcreteNumberTrivia(tNumber);
      verify(httpClient.get(Uri.parse("http://numbersapi.com/$tNumber"),
          headers: {'Content-Type': 'application/json'}));
    });

    test('''shoud return Number trivia when the response code is 200''',
        () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      expect(result, equals(tNumberTriviaModel));
    });

    test('shoud throw a ServerException when the response code is 404 or other',
        () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 404));
      final call = dataSource.getConcreteNumberTrivia;
      expect(call(tNumber), throwsA(ServerException));
    });
  });

  group("getRandomNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''shoud perform a GET request on URL with number being the endpoint
     and with application/json hearder''', () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      dataSource.getRandomNumberTrivia();
      verify(httpClient.get(Uri.parse("http://numbersapi.com/random"),
          headers: {'Content-Type': 'application/json'}));
    });

    test('''shoud return Number trivia when the response code is 200''',
        () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      final result = await dataSource.getRandomNumberTrivia();
      expect(result, equals(tNumberTriviaModel));
    });

    test('shoud throw a ServerException when the response code is 404 or other',
        () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 404));
      final call = dataSource.getRandomNumberTrivia;
      expect(call(), throwsA(ServerException));
    });
  });
}
