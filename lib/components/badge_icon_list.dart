import '../models/badge_model/badge_model.dart';

final List<BadgeIcon> badgeIcons = [
  BadgeIcon(id: 'basic01', assetPath: 'assets/images/minor_event.png'),
  BadgeIcon(id: 'timed01', assetPath: 'assets/images/timed_event.png'),
  BadgeIcon(id: 'major01', assetPath: 'assets/images/major_event.png'),
  BadgeIcon(id: 'urgent01', assetPath: 'assets/images/urgent_event.png'),
  BadgeIcon(id: 'special01', assetPath: 'assets/images/special_event.png'),
  // ... 유저가 구매한 아이콘만 이 리스트에 추가
];

String getBadgeAssetPath(String badgeId) {
  final badge = badgeIcons.firstWhere(
        (b) => b.id == badgeId,
    orElse: () => BadgeIcon(id: 'default', assetPath: 'assets/images/clock.png'),
  );
  return badge.assetPath;
}