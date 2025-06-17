import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credential_manager/credential_manager.dart' as cred;
import '../../models/user_model/user_model.dart';
import '../user_service/user_service.dart';

part 'auth_service.g.dart';


//현재 구조에서는 fetchUser를 별도 호출 필요 없음. Auth Provider가 이미 그 역할을 수행하고 있기 때문

@riverpod
class Auth extends _$Auth {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final cred.CredentialManager _credentialManager = cred.CredentialManager();

  @override
  User? build() {
    // currentUser가 있는 경우에만 실행
    _checkAutoLogin();
    return _auth.currentUser;
  }

  // 자동 로그인 체크 및 UserNotifier 업데이트 - currentUser가 있을때만 실행되는 코드가 있음
  Future<void> _checkAutoLogin() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        // Firestore에서 사용자 정보 가져오기 ($FB-READ1)
        final userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          final userModel = UserModel.fromJson(userData);
          // lastSignedIn 업데이트 (자동 로그인 시에도)
          final updatedUser = userModel.copyWith(lastSignedIn: DateTime.now());
          // Firestore 업데이트  ($FB-WRITE1)
          await _firestore
              .collection('users')
              .doc(currentUser.uid)
              .update({'lastSignedIn': DateTime.now()});
          // UserNotifier에 사용자 정보 설정
          ref.read(userNotifierProvider.notifier).signIn(updatedUser);
        }
      } catch (e) {
        print('Auto login check failed: $e');
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      // Google 자격증명 요청
      final cred.GoogleIdTokenCredential? credential =
      await _credentialManager.saveGoogleCredential(
        useButtonFlow: true,
      );

      if (credential == null) return;

      final authCredential = GoogleAuthProvider.credential(
        idToken: credential.idToken,
      );

      final UserCredential userCredential =
      await _auth.signInWithCredential(authCredential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        UserModel userModel;

        if (!userDoc.exists) {
          // 새 사용자 생성
          userModel = UserModel(
            uid: firebaseUser.uid,
            displayName: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '',
            photoUrl: firebaseUser.photoURL ?? '',
            createdTime: DateTime.now(),
            lastSignedIn: DateTime.now(),
          );

          await _firestore
              .collection('users')
              .doc(firebaseUser.uid)
              .set(userModel.toJson());
        } else {
          // 기존 사용자 lastSignedIn 업데이트
          final userData = userDoc.data()!;
          userModel = UserModel.fromJson(userData)
              .copyWith(lastSignedIn: DateTime.now());

          await _firestore
              .collection('users')
              .doc(firebaseUser.uid)
              .update({'lastSignedIn': DateTime.now()});
        }

        // UserNotifier에 사용자 정보 설정
        ref.read(userNotifierProvider.notifier).signIn(userModel);

        state = firebaseUser;
      }
    } catch (e) {
      print('Google SignIn Failed : $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();

      // UserNotifier도 함께 로그아웃
      ref.read(userNotifierProvider.notifier).signOut();

      state = null;
    } catch (e) {
      print('Sign Out Failed : $e');
      rethrow;
    }
  }
  // 편의성 getter
  User? get currentUser => state;
  bool get isAuthenticated => state != null;
}