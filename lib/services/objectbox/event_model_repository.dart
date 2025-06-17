import '../../models/event_model/event_model.dart';
import '../../objectbox.g.dart';
import 'objectbox_manager.dart';


class EventRepository {
  static Box<EventModel> get _box => ObjectBoxService.store.box<EventModel>();

  // Create
  static Future<int> addEvent(EventModel event) async {
    return await _box.putAsync(event);
  }

  // Read - 전체 일정
  static Future<List<EventModel>> getAllEvents() async {
    return await _box.getAllAsync();
  }

  // Read - 단일 일정
  static Future<EventModel?> getEvent(int id) async {
    return await _box.getAsync(id);
  }

  // Update
  static Future<int> updateEvent(EventModel event) async {
    return await _box.putAsync(event);
  }

  // Delete
  static Future<bool> deleteEvent(int id) async {
    return await _box.removeAsync(id);
  }

  // 날짜 범위로 일정 조회
  static Future<List<EventModel>> getEventsByDateRange(DateTime start, DateTime end) async {
    final query = _box.query(
        EventModel_.from.greaterOrEqual(start.millisecondsSinceEpoch) &
        EventModel_.to.lessOrEqual(end.millisecondsSinceEpoch)
    ).build();

    final events = await query.findAsync();
    query.close();
    return events;
  }

  // 전체 삭제
  static Future<void> deleteAllEvents() async {
    await _box.removeAllAsync();
  }
}