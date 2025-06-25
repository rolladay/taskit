import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskit/components/my_btn_container.dart';
import 'package:taskit/components/my_sized_box.dart';
import '../features/auth_features/auth_service.dart';
import '../features/user_service/user_service.dart';
import 'home_frame.dart';

class SigningInPage extends ConsumerStatefulWidget {
  const SigningInPage({super.key});

  @override
  ConsumerState<SigningInPage> createState() => _SigningInPageState();
}

class _SigningInPageState extends ConsumerState<SigningInPage> {
  Timer? _timer; // 로그인하고 2초 기다리고 홈으로 이동 위한 것
  bool _isLoading = false;
  bool _isSignedIn = false;


  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MyHome()),
    );
  }

  // currentUser가 없을때만 실행되는 구조. SignInwithGoogle함수 실행 코드 언제 하느냐?
  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await ref.read(authProvider.notifier).signInWithGoogle();
      // 네비게이션은 ref.listen에서 자동으로 처리됨
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong with sign-in : $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //ref.watch(프로바이더)는 해당 프로바이더가 제공하는 **현재 상태(값)**를 반환합니다.
    // authUser에는 로그인전에는 null, 로그인 후에는 firebaseUser가 들어간다.
    final authUser = ref.watch(authProvider);
    final userModel = ref.watch(userNotifierProvider);
    // 자동 로그인 중인지 확인: Firebase User는 있지만 UserModel이 아직 없어야함 (로그인 후에 UserModel이 들어오니까)
    final isAutoLoggingIn = authUser != null && userModel == null && !_isLoading;

    // UserModel이 설정되면 2초 후 홈으로 이동 - auth에서 UserModel을 업데이트해주는 동작이 있겠지?
    ref.listen(userNotifierProvider, (previous, next) {
      if (next != null && mounted) {
        setState(() {
          _isSignedIn = true; // 로그인 성공 상태로 설정
        });
        print('로그인 감지: ${next.email}');
        _timer = Timer(const Duration(seconds: 1), () {
          _navigateToHome();
        });
      }
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const Spacer(flex: 3),
              // 로고 영역
              SizedBox(
                width: 80,
                height: 80,
                child: Image.asset('assets/images/taskit_icon.png'),
              ),
              const MySizedBox(height: 16),
              Text(
                'Taskit',
                style: GoogleFonts.tiltWarp(
                  fontSize: 48,
                  color: Colors.black,
                ),
              ),
              const Text(
                'task it easy.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),

              const Spacer(flex: 4),

              GestureDetector(
                onTap: (isAutoLoggingIn || _isLoading || _isSignedIn)
                    ? null
                    : _handleGoogleSignIn,
                child: MyBtnContainer(
                  color: (isAutoLoggingIn || _isLoading || _isSignedIn)
                      ? Colors.grey.shade300
                      : Colors.white70,
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      if (_isLoading || isAutoLoggingIn || _isSignedIn)
                        const SizedBox(
                          width: 40,
                          height: 40,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black87,
                            ),
                          ),
                        )
                      else
                        Image.asset(
                          'assets/images/google_logo.png',
                          width: 40,
                        ),
                      Expanded(
                        child: Text(
                          isAutoLoggingIn
                              ? 'Signing in...'
                              : (_isLoading || _isSignedIn
                              ? 'Signing in...'
                              : 'Sign-in with google'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: (isAutoLoggingIn || _isLoading || _isSignedIn)
                                ? Colors.black54
                                : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
              const MySizedBox(height: 40),

              const Text(
                'Rolladay Inc.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
