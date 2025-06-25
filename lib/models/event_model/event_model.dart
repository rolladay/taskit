import 'package:objectbox/objectbox.dart';

//@Entity(): 클래스를 ObjectBox 엔티티로 정의, 나중에 firebase 연동할때는 좀 복잡해질 수 있음
// user안에 연도를 두고 그 안에 event객체를 하나하나 두는게 좋을 것
@Entity()
class EventModel {
  @Id()
  int id = 0;

  final String eventName;
  final DateTime from;
  final DateTime to;
  final bool isAllDay;
  final bool isCompleted;
  final String badgeId;
  String notes;


  EventModel({
    this.id = 0,
    required this.eventName,
    required this.from,
    required this.to,
    required this.isAllDay,
    required this.isCompleted,
    required this.badgeId,
    this.notes = '',
  });

  // 직접 구현한 copyWith 메서드
  EventModel copyWith({
    int? id,
    String? eventName,
    DateTime? from,
    DateTime? to,
    bool? isAllDay,
    bool? isCompleted,
    String? notes,
    String? badgeId,
  }) {
    return EventModel(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      from: from ?? this.from,
      to: to ?? this.to,
      isAllDay: isAllDay ?? this.isAllDay,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
      badgeId : badgeId ?? this.badgeId,
    );
  }
}