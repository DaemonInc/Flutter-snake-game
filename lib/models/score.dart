import 'package:json_annotation/json_annotation.dart';

part 'score.g.dart';

@JsonSerializable()
class Score {
  Score({
    required this.date,
    required this.score,
    required this.name,
  });

  final DateTime date;
  final int score;
  final String name;

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);
  Map<String, dynamic> toJson() => _$ScoreToJson(this);
}
