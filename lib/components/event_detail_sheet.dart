import 'package:flutter/material.dart';
import '../models/event_model/event_model.dart';
import 'badge_icon_list.dart';

class EventDetailSheet extends StatelessWidget {
  final EventModel event;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const EventDetailSheet({
    super.key,
    required this.event,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 40,
                child: Row(
                  children: [
                    Image.asset(
                      getBadgeAssetPath(event.badgeId),
                      width: 26,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      event.eventName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  print(1);
                },
                child: const SizedBox(
                  width: 50,
                  child: Text(
                    '편집',
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ),
            ],
          ),
          Container(
            color: Colors.black87,
            height: 1.5,
          ),
          const SizedBox(height: 8),
          Column(
            children: [

              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    const Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      event.isAllDay
                          ? '종일'
                          : '${event.from.hour}:${event.from.minute.toString().padLeft(2, '0')} - ${event.to.hour}:${event.to.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.black12,
                height: 1,
              ),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    const Text(
                      'Memo',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(
                      width: 16,
                    ),
                    // Expanded로 감싸주면 Row에서 가용 공간을 차지함
                    Flexible(
                      child: SizedBox(width: double.infinity,
                        child: Text(
                          event.notes,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis, // 이 옵션이 핵심!
                          maxLines: 1,
                          textAlign: TextAlign.end,// 한 줄만 표시
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.black12,
                height: 1,
              ),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    const Text(
                      'Shared with',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Spacer(),
                    // Expanded로 감싸주면 Row에서 가용 공간을 차지함
                    Container(
                      width: 30, // 크기
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.blue, // 색상
                        shape: BoxShape.circle, // 원형
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.black12,
                height: 1,
              ),
              const SizedBox(
                height: 60,
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('닫기'),
              ),
              ElevatedButton(
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('삭제'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
