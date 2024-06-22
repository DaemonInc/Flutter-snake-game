import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_snake_game/models/score.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreService {
  ScoreService._() {
    SharedPreferences.getInstance().then((prefs) => _prefs = prefs);
  }

  static ScoreService? _instance;
  static ScoreService get instance {
    _instance ??= ScoreService._();
    return _instance!;
  }

  SharedPreferences? _prefs;

  final _score = ValueNotifier(0);
  ValueListenable<int> get score => _score;

  void increment() {
    _score.value = _score.value + 1;
  }

  void reset() {
    _score.value = 0;
  }

  Future<void> save() async {
    final scores = getScores();
    scores.add(Score(
      date: DateTime.now(),
      score: _score.value,
      name: 'Player',
    ));

    await _prefs?.setStringList(
      'scores',
      scores.map((score) => jsonEncode(score.toJson())).toList(),
    );
  }

  List<Score> getScores() {
    final scores = (_prefs?.getStringList('scores') ?? [])
        .map((score) => Score.fromJson(jsonDecode(score)))
        .toList();
    scores.sort((a, b) => b.date.compareTo(a.date));
    return scores;
  }
}
