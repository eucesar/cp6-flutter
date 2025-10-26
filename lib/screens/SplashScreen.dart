import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gerador_de_senha/routes.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _nextScreen();
  }

  Future<void> _nextScreen() async {
    // Aguarda a animação do splash
    await Future.delayed(const Duration(milliseconds: 2000));
    
    if (!mounted) return;

    // Verifica se o usuário está logado (sem validação complexa)
    final user = FirebaseAuth.instance.currentUser;
    print('Splash: currentUser = ${user?.uid}');

    // Verifica se deve mostrar a introdução
    final prefs = await SharedPreferences.getInstance();
    final showIntro = prefs.getBool('show_intro') ?? true;

    if (!mounted) return;

    // Navega para a tela apropriada
    if (user != null) {
      Navigator.pushReplacementNamed(context, Routes.home);
    } else if (showIntro) {
      Navigator.pushReplacementNamed(context, Routes.intro);
    } else {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Lottie.asset(
          'assets/lottie/splash.json',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
