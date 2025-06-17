import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/event_model/event_model.dart';
import '../../services/objectbox/event_model_repository.dart';

part 'event_service.g.dart';

// Provider로 관리하는 EventService222
@riverpod
class EventService extends _$EventService {

  // 초기 state는 빈 리스트 (null 불가)
  @override
  List<EventModel> build() => [];


  // Read - 전체 일정 불러오기 & state 초기화
  Future<void> loadAllEvents() async {
    // Repository가 null을 반환하지 않도록 구현하는 게 가장 좋음!
    // 혹시라도 null 반환 가능성이 있다면 ?? []로 안전하게 처리
    final events = await EventRepository.getAllEvents();
    state = events;
  }

  // Create - 일정 생성
  Future<void> createEvent({
    required String eventName,
    required DateTime from,
    required DateTime to,
    required bool isAllDay,
    required bool isCompleted,
  }) async {
    final newEvent = EventModel(
      eventName: eventName.isNotEmpty ? eventName : '새 일정',
      from: from,
      to: to,
      isAllDay: isAllDay,
      isCompleted: isCompleted,
    );
    // DB에 저장
    final savedEventId = await EventRepository.addEvent(newEvent);
    final eventWithId = newEvent.copyWith(id: savedEventId);

    // state에 추가 (state는 무조건 non-null)
    state = [...state, eventWithId];
  }

  // Modify - 일정 수정
  Future<void> modifyEvent({
    required int id,
    required String eventName,
    required DateTime from,
    required DateTime to,
    required bool isAllDay,
    required bool isCompleted,
  }) async {
    final updatedEvent = EventModel(
      id: id,
      eventName: eventName.isNotEmpty ? eventName : '수정된 일정',
      from: from,
      to: to,
      isAllDay: isAllDay,
      isCompleted: isCompleted,
    );
    // DB에 반영
    await EventRepository.updateEvent(updatedEvent);

    // state에서 해당 이벤트만 교체
    state = [
      for (final event in state)
        if (event.id == id) updatedEvent else event
    ];
  }

  // Delete - 일정 삭제
  Future<void> deleteEvent(int id) async {
    await EventRepository.deleteEvent(id);

    // state에서 해당 이벤트만 제거
    state = state.where((event) => event.id != id).toList();
  }



  // Read - 특정 기간 일정 불러오기 (state는 변경하지 않음)
  Future<List<EventModel>> getEventsByDateRange(DateTime start, DateTime end) async {
    // 마찬가지로 null 반환 가능성 대비
    return await EventRepository.getEventsByDateRange(start, end);
  }
}

