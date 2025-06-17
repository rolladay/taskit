import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';


// 1) Firebase는 TimeStamp, OBJBox는 DateTime을 받기 때문에 전환해주는 기능 필요.
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();
  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }
  @override
  Timestamp toJson(DateTime date) {
    return Timestamp.fromDate(date);
  }
}
