import 'package:sans_mobile/models/AgvModel.dart';
import 'package:sans_mobile/models/StationModel.dart';

class Task {
  final AGV agv;
  final Station stationFrom;
  final Station stationTo;
  final DateTime timeStart;
  final DateTime timeEnd;

  Task({
    required this.agv,
    required this.stationFrom,
    required this.stationTo,
    required this.timeStart,
    required this.timeEnd,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        agv: AGV.fromJson(json['agv'] as Map<String, dynamic>),
        stationFrom: Station.fromJson(json['station_from'] as Map<String, dynamic>),
        stationTo: Station.fromJson(json['station_to'] as Map<String, dynamic>),
        timeStart: DateTime.parse(json['time_start'] as String),
        timeEnd: DateTime.parse(json['time_end'] as String),
      );

  Map<String, dynamic> toJson() => {
        'agv': agv.toJson(),
        'station_from': stationFrom.toJson(),
        'station_to': stationTo.toJson(),
        'time_start': timeStart.toIso8601String(),
        'time_end': timeEnd.toIso8601String(),
      };
}
