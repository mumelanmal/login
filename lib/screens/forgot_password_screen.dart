import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:login/core/constants.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Latar Belakang Blur Gradien
          _buildAnimatedBackground(context),

          // 2. Konten Utama (Form)
          Center(
            child: SingleChildScrollView(
              // p-4
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 448), // max-w-md
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header
                    Text(
                      "Forgot Your Password?",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: kSubtleTextColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5, // tracking-light
                          ),
                    ),
                    const SizedBox(height: 8.0), // pt-1
                    
                    // Sub-header
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320), // max-w-xs
                      child: const Text(
                        "No problem. Enter your email below and we'll send you a link to reset it.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kSubtleTextColor,
                          fontSize: 16.0, // text-base
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32.0), // pb-8

                    // Form
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // px-4
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Label
                          const Text(
                            "Email Address",
                            style: TextStyle(
                              color: kSubtleTextColor,
                              fontSize: 16.0, // text-base
                              fontWeight: FontWeight.w500, // font-medium
                            ),
                          ),
                          const SizedBox(height: 8.0), // pb-2
                          
                          // Text Field
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: kSubtleTextColor),
                            decoration: const InputDecoration(
                              hintText: "Enter your email",
                              suffixIcon: Icon(Icons.mail_outline),
                            ),
                          ),
                          const SizedBox(height: 24.0), // gap-6
                          
                          // Tombol
                          ElevatedButton(
                            onPressed: () {
                              // Logika kirim reset link
                            },
                            child: const Text("Send Reset Link"),
                          ),
                        ],
                      ),
                    ),
                    
                    // Link "Back to Login"
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0), // pt-8
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                          // Navigasi kembali ke Login
                        },
                        child: const Text("Back to Login"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Opacity(
      opacity: 0.5, // opacity-50
      child: Stack(
        children: [
          // Lingkaran 1: -bottom-1/4 -left-1/4
          Positioned(
            bottom: -size.height * 0.25,
            left: -size.width * 0.25,
            child: _BlurGradientCircle(
              size: size.width * 0.5, // h-1/2 w-1/2
              gradient: const LinearGradient(
                colors: [Color(0xFF791E58), kPrimaryColor],
                begin: Alignment.centerLeft, // from-[]
                end: Alignment.centerRight, // to-[]
              ),
            ),
          ),
          // Lingkaran 2: -top-1/4 -right-1/4
          Positioned(
            top: -size.height * 0.25,
            right: -size.width * 0.25,
            child: _BlurGradientCircle(
              size: size.width * 0.5, // h-1/2 w-1/2
                gradient: LinearGradient(
                colors: [kAccentColor, kPrimaryColor.withOpacitySafe(0.5)],
                begin: Alignment.centerRight, // from-[]
                end: Alignment.centerLeft, // to-[]
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Widget Kustom untuk Latar Belakang Blur Gradien ---

class _BlurGradientCircle extends StatelessWidget {
  final double size;
  final Gradient gradient;

  const _BlurGradientCircle({
    required this.size,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 48.0, sigmaY: 48.0), // blur-3xl
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          gradient: gradient,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}