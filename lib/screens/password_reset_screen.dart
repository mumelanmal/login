import 'package:flutter/material.dart';
import 'package:login/core/constants.dart';
import 'package:login/widgets/blur_circle.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen>
    with TickerProviderStateMixin {
      
  // Kontroler untuk animasi latar belakang
  late final AnimationController _spinController1;
  late final AnimationController _spinController2;
  late final AnimationController _spinController3;
  
  // Kontroler untuk ikon (pulse)
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi Kontroler Animasi Latar
    _spinController1 = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
    
    // 'infinite_reverse' berarti berputar ke arah sebaliknya
    _spinController2 = AnimationController(vsync: this, duration: const Duration(seconds: 25));
  // Kita buat animasi dari 1.0 ke 0.0 untuk membalik arah
  _spinController2.repeat();

    _spinController3 = AnimationController(vsync: this, duration: const Duration(seconds: 30))..repeat();

    // Inisialisasi Kontroler Denyut (Pulse)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Durasi standar pulse
      lowerBound: 0.7, // Skala minimum
      upperBound: 1.0, // Skala maksimum
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    // Selalu dispose kontroler Anda
    _spinController1.dispose();
    _spinController2.dispose();
    _spinController3.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cek apakah mode gelap sedang aktif
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Layout justify-between dicapai dengan Column + Expanded
    return Scaffold(
      body: Stack(
        children: [
          // 1. Latar Belakang Animasi
          _buildAnimatedBackground(context, isDark),
          
          // 2. Konten Utama
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // p-4
              child: Column(
                children: [
                  // Konten di tengah (flex-grow)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSuccessIcon(isDark),
                        const SizedBox(height: 32.0), // mb-8
                        
                        // Headline
                        Text(
                          "Password Reset Successful!",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5, // tracking-tight
                              ),
                        ),
                        const SizedBox(height: 12.0), // pb-3
                        
                        // Body Text
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 320), // max-w-xs
                          child: Text(
                            "Your password has been updated. You can now log in with your new credentials.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: isDark ? kDarkSubtleTextColor : kLightSubtleTextColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Tombol di bawah (py-4)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigasi kembali ke Login
                      },
                      child: const Text("Back to Login"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Pembangun (Helpers) ---

  Widget _buildAnimatedBackground(BuildContext context, bool isDark) {
    final size = MediaQuery.of(context).size;
  final blurColor = kPrimaryColor.withOpacitySafe(isDark ? 0.05 : 0.1);
    
    return Stack(
      children: [
        // Elemen blur 1: top-left
        Positioned(
          top: -size.height * 0.25,
          left: -size.width * 0.25,
          child: RotationTransition(
            turns: _spinController1,
            child: BlurCircle(
              size: size.width * 0.5,
              color: blurColor,
            ),
          ),
        ),
        // Elemen blur 2: bottom-right
        Positioned(
          bottom: -size.height * 0.25,
          right: -size.width * 0.25,
          child: RotationTransition(
            // Gunakan animasi terbalik
            turns: Tween(begin: 1.0, end: 0.0).animate(_spinController2),
            child: BlurCircle(
              size: size.width * 0.5,
              color: blurColor,
            ),
          ),
        ),
        // Elemen border 3: center
        Align(
          alignment: Alignment.center,
          child: RotationTransition(
            turns: _spinController3,
            child: Container(
              height: 128, // w-32
              width: 128, // h-32
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: kPrimaryColor.withOpacitySafe(isDark ? 0.1 : 0.2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessIcon(bool isDark) {
    // Replikasi dari `animate-pulse` menggunakan ScaleTransition
    return ScaleTransition(
      scale: _pulseController,
      child: Container(
        height: 96, // h-24
        width: 96, // w-24
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacitySafe(isDark ? 0.3 : 0.2),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            height: 80, // h-20
            width: 80, // w-20
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacitySafe(isDark ? 0.5 : 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.task_alt, // material-symbols: task_alt
              color: kPrimaryColor,
              size: 50.0, // text-5xl
            ),
          ),
        ),
      ),
    );
  }
}