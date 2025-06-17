import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_date_provider.g.dart';


// 단순 값제공은 함수형provider써도 되는데, 이건 updateDate가 있어서 class프로바이더 필요
@Riverpod(keepAlive: true)
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() {
    return DateTime.now(); // 기본값은 현재 날짜
  }

  void updateDate(DateTime newDate) {
    state = newDate;
  }
}