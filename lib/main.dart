import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAZ82cwRpR4FhNvoE8AVFJtfCbvzJ2tO_8",
        appId: "1:828625792901:web:d6d6ba8b8f1e15157a1eec",
        messagingSenderId: "828625792901",
        projectId: "instagram-flutter-3254d",
        storageBucket: "instagram-flutter-3254d.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram Clone',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error}',
                    ),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }

              return const LoginScreen();
            },
          )),
    );
  }
}
