import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskit/pages/signing_in.dart';
import 'package:taskit/services/objectbox/objectbox_manager.dart';
import 'package:credential_manager/credential_manager.dart' as cred;
import 'firebase_options.dart';


//    SHA1: 11:61:EE:C5:15:E8:1C:F9:8D:EC:C8:19:9C:61:0C:A1:15:E0:01:85
//    SHA256: 78:CF:34:30:35:3F:09:78:A8:6B:04:91:CE:BB:F2:9B:96:A9:F8:FE:A7:2D:1B:93:31:CD:0A:74:5D:6D:65:E3


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // 파이어베이스 초기화 및 화면 세로고정
    await Future.wait([
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]),
    ]);
    // Firebase 의존성이 있는 작업들은 파베 초기화 이후에 아래로 진행
    final credentialManager = cred.CredentialManager();
    if (credentialManager.isSupportedPlatform) {
      await credentialManager.init(
        preferImmediatelyAvailableCredentials: true,
        // google service.json에서 clientID3 이 clientID(web)
        googleClientId: '166132457414-utnf6c7mculp2rgsaq4e8q91vo9k7f4n.apps.googleusercontent.com'
      );
    }
    await ObjectBoxService.init();
  } catch (e, stackTrace) {
    // 에러 처리 로직 나중에 필요하면 넣기 굳이 필요 없음
  }
  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taskit',
      //앱 전체 글자 크기 고정
      builder: (context, child) {
        return MediaQuery.withClampedTextScaling(
          maxScaleFactor: 1.0,
          child: child!,
        );
      },
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Colors.white,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        splashFactory: InkRipple.splashFactory,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.black26,
        ),
        useMaterial3: true,
      ),
      home: const SigningInPage(),
    );
  }
}