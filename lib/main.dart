import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gerador_de_senha/core/auth_guard.dart';
import 'package:gerador_de_senha/routes.dart';
import 'package:gerador_de_senha/screens/HomeScreen.dart';
import 'package:gerador_de_senha/screens/SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Carrega o .env da raiz do projeto
  await dotenv.load(fileName: ".env");

  // Monte as opções por plataforma usando as variáveis do .env
  final FirebaseOptions options = _firebaseOptionsFromEnv();

  await Firebase.initializeApp(options: options);
  runApp(const MyApp());
}

FirebaseOptions _firebaseOptionsFromEnv() {
  if(Platform.isAndroid){
    return FirebaseOptions(
    apiKey: dotenv.env['API_KEY_AND']!,
    appId: dotenv.env['APP_ID_AND']!,
    messagingSenderId: '1054039258694',
    projectId: 'checkpoint6-e87bd',
    storageBucket: 'checkpoint6-e87bd.firebasestorage.app',
    );
  }
  else if (Platform.isIOS){
    return FirebaseOptions(
    apiKey: dotenv.env['API_KEY_IOS']!,
    appId: dotenv.env['APP_ID_IOS']!,
    messagingSenderId: '1054039258694',
    projectId: 'checkpoint6-e87bd',
    storageBucket: 'checkpoint6-e87bd.firebasestorage.app',
    iosBundleId: 'br.com.guiengel.geradorDeSenha',
    );
  }
    else if (Platform.isWindows){
    return FirebaseOptions(
    apiKey: dotenv.env['API_KEY_WIN']!,
    appId: dotenv.env['APP_ID_WIN']!,
    messagingSenderId: '1054039258694',
    projectId: 'checkpoint6-e87bd',
    authDomain: 'checkpoint6-e87bd.firebaseapp.com',
    storageBucket: 'checkpoint6-e87bd.firebasestorage.app',
    );
  }
  throw UnsupportedError(
    'Plataforma não suportada para configuração do Firebase',
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gerador de senhas",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196F3),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2196F3),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF2196F3),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2196F3),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: Routes.splash,
      onGenerateRoute: Routes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
