import 'dart:convert';

import 'package:estudo_clean_architecture/core/error/exceptions.dart';
import 'package:estudo_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  ///Gets the cached [NumberTriviaModel] wich was gotten the last time
  ///the user had an internet connection
  ///
  ///Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const CACHED_NUMBER_TRIVIA = "CACHED_NUMBER_TRIVIA";

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({
    @required this.sharedPreferences,
  });

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString('CACHED_NUMBER_TRIVIA');
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA,
      json.encode(triviaToCache.toJson()),
    );
  }
}
