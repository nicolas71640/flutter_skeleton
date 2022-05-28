import 'dart:convert';

import 'package:departments/core/error/exceptions.dart';
import 'package:departments/features/departmentsViewer/data/datasources/number_trivia_local_data_source.dart';
import 'package:departments/features/departmentsViewer/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;
  const tNumberTriviaModel = NumberTriviaModel(text: "Test Text", number: 1);

  group("getLastNumberTrivia", () {
    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      dataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
    });

    test(
        "should return NumberTrivia from shared preference when there is one in the cache",
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture("trivia_cached.json"));
      final lastNumberTrivia = await dataSource.getLastNumberTrivia();
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(lastNumberTrivia, tNumberTriviaModel);
    });

    test(
        "should throw CachedEception when there is no NumberTrivia in the shared preferences",
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      final call = dataSource.getLastNumberTrivia;
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
    });
  });

  group("cacheNumberTrivia", () {
    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      dataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
    });

    test("should cache NumberTrivia in SharedPreferences", () async {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      final expectedString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedString));
    });
  });
}
