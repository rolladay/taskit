import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/user_model/user_model.dart';

part 'user_service.g.dart';


//AuthService: 인증만 담당  &  UserNotifier: 사용자 정보 관리만 담당

@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  @override
  UserModel? build() {
    return null;
  }


  Future<void> fetchUser(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      final user = UserModel.fromJson(doc.data()!);
      state = user;
    }
  }


  Future<void> updateUser(UserModel updatedUser) async {
    try {
      // UserModel의 데이터를 직렬화해서 JSON 객체로 data변수에 저장, 이우에 이 data를 Firestore에 저장/업데이트
      final data = updatedUser.toJson();
      // Firestore에 데이터 업데이트 시도
      await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedUser.uid)
          .update(data);
      // Firestore에 저장된 후, 상태 업데이트
      state = updatedUser;
    } catch (e) {
      print('파이어스토어에 데이터 저장 중 오류 발생: $e');
    }
  }

  // 로그인 시에만 lastSignedIn 설정
  void signIn(UserModel user) {
    state = user.copyWith(lastSignedIn: DateTime.now());
  }

  Future<void> updateDisplayName(String newDisplayName) async {
    if (state != null) {
      final updated = state!.copyWith(displayName: newDisplayName);
      await updateUser(updated); // Firestore와 state 모두 업데이트
    }
  }

  Future<void> updatePhotoUrl(String newPhotoUrl) async {
    if (state != null) {
      final updatedUser = state!.copyWith(photoUrl: newPhotoUrl);
      await updateUser(updatedUser); // Firestore와 state 모두 업데이트
    }
  }

  void signOut() {
    state = null;
  }
// updateLastSignedIn 메소드 제거
}