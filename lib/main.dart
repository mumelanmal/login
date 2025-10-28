import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants.dart';

import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen_new.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/password_reset_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan theme gelap secara default
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: kDarkBackgroundColor,
      fontFamily: 'Inter', // Ganti dengan font pilihan Anda
      
      // Tema untuk Tombol
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56), // h-14
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // rounded-xl
          ),
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Tema untuk Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kInputBackgroundColor,
        hintStyle: const TextStyle(color: kSubtleTextColor),
        prefixIconColor: kSubtleTextColor,
        suffixIconColor: kSubtleTextColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // rounded-xl
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
        ),
      ),

      // Tema untuk TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryColor,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return MaterialApp(
      title: 'Flutter Auth App',
      theme: darkTheme,
      // Gunakan wrapper yang membaca provider untuk memilih halaman home secara dinamis
      home: const AuthWrapper(),
      // Definisikan semua rute di sini agar bisa diakses dari mana saja
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/password-reset': (context) => const PasswordResetScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // Jika provider masih mencoba auto-login, tunjukkan indikator loading
    if (auth.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Kembalikan halaman sesuai status login
    return auth.isLoggedIn ? const DashboardScreen() : const LoginScreen();
  }
}