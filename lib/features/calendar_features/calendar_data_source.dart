import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../models/event_model/event_model.dart';

class EventDataSource extends CalendarDataSource {
  // 생성자 이벤트모델 리스트를 받아서 appointments에 할당해줌
  EventDataSource(List<EventModel> source) {
    appointments = source;
  }

  @override
  // index는 날짜가 아니라, 이벤트 리스트(List)의 인덱스(순번, 번호)
  // 아래 ㅁ든 override 메소드는 _getMeetingData를 통해 데이터에 접근, 가져온다.
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }


  // note 찾으려고 에러나는거 방지하기 위해
  @override
  String getNotes(int index) {
    // EventModel에 notes 속성이 없으므로 빈 문자열 반환
    return '';
  }

  // 색상관련 override
  @override
  Color getColor(int index) {
    // 여기서 원하는 색상을 반환
    return Colors.black54; // 모든 일정의 색상(및 인디케이터)을 검은색으로 변경

    // 또는 일정 유형에 따라 다른 색상 반환
    // final event = appointments![index] as EventModel;
    // if (event.eventName.contains('회의')) {
    //   return Colors.red;
    // } else {
    //   return Colors.black;
    // }
  }

  EventModel _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    if (meeting is EventModel) {
      return meeting;
    }
    throw TypeError(); // 또는 기본값 반환 또는 다른 예외 처리
  }
}