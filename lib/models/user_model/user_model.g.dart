// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String,
      createdTime:
          const TimestampConverter().fromJson(json['createdTime'] as Timestamp),
      lastSignedIn: const TimestampConverter()
          .fromJson(json['lastSignedIn'] as Timestamp),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'createdTime': const TimestampConverter().toJson(instance.createdTime),
      'lastSignedIn': const TimestampConverter().toJson(instance.lastSignedIn),
    };
