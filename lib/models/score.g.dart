// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Score _$ScoreFromJson(Map<String, dynamic> json) => Score(
      date: DateTime.parse(json['date'] as String),
      score: (json['score'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ScoreToJson(Score instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'score': instance.score,
      'name': instance.name,
    };
