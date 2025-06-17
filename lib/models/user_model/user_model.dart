import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../utils/time_stamp_converter.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';


// Model Class와(Waht), NotifierClass(How)는 구분되어야 함

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String email,
    required String displayName,
    required String photoUrl,
    @TimestampConverter() required DateTime createdTime,
    @TimestampConverter() required DateTime lastSignedIn,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}


