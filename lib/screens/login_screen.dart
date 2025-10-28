import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login/core/constants.dart';
import 'package:provider/provider.dart';
import 'package:login/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Kita butuh TickerProviderStateMixin untuk animasi
class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  // Kontroler untuk animasi
  late final AnimationController _spinController1;
  late final AnimationController _spinController2;
  late final AnimationController _pulseController;

  // State untuk form
  bool _obscureText = true;
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  Color _usernameBg = kInputBackgroundColor;
  Color _passwordBg = kInputBackgroundColor;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi Kontroler Animasi
    _spinController1 = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
    _spinController2 = AnimationController(vsync: this, duration: const Duration(seconds: 25))..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
      lowerBound: 0.8,
      upperBound: 1.0,
    )..repeat(reverse: true);

    // Listener untuk mengubah warna latar belakang input saat fokus
    _usernameFocus.addListener(() {
      setState(() {
        _usernameBg = _usernameFocus.hasFocus ? kInputFocusedBackgroundColor : kInputBackgroundColor;
      });
    });
    _passwordFocus.addListener(() {
      setState(() {
        _passwordBg = _passwordFocus.hasFocus ? kInputFocusedBackgroundColor : kInputBackgroundColor;
      });
    });
  }

  @override
  void dispose() {
    // Selalu dispose kontroler Anda
    _spinController1.dispose();
    _spinController2.dispose();
    _pulseController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Latar Belakang Animasi
          _buildAnimatedBackground(context),

          // 2. Konten Utama (Form)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                // setara dengan max-w-md (28rem * 16 = 448px)
                constraints: const BoxConstraints(maxWidth: 448),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32.0), // mb-8
                    _buildLoginForm(),
                    _buildDivider(),
                    _buildSocialLogins(),
                    _buildSignUpLink(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Pembangun (Helpers) ---

  Widget _buildAnimatedBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Lingkaran berputar 1
        Positioned(
          top: -size.height * 0.25,
          left: -size.width * 0.25,
            child: RotationTransition(
            turns: _spinController1,
            child: _AnimatedBlurCircle(
              color: kPrimaryColor.withOpacitySafe(0.2),
              size: size.width * 0.5,
            ),
          ),
        ),
        // Lingkaran berputar 2
        Positioned(
          bottom: -size.height * 0.25,
          right: -size.width * 0.25,
            child: RotationTransition(
            turns: _spinController2,
            child: _AnimatedBlurCircle(
              color: Colors.cyan.withOpacitySafe(0.2),
              size: size.width * 0.5,
            ),
          ),
        ),
        // Lingkaran berdenyut (pulse)
        Align(
          alignment: Alignment.center,
            child: ScaleTransition(
            scale: _pulseController,
            child: _AnimatedBlurCircle(
              color: kPrimaryColor.withOpacitySafe(0.1),
              size: 256, // h-64 w-64
              sigma: 32.0, // blur-2xl
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          height: 64, // h-16
          width: 64, // w-16
          margin: const EdgeInsets.only(bottom: 16.0), // mb-4
            decoration: BoxDecoration(
            color: kPrimaryColor.withOpacitySafe(0.1),
            borderRadius: BorderRadius.circular(16), // rounded-2xl
            border: Border.all(color: kPrimaryColor.withOpacitySafe(0.2)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // backdrop-blur-sm
              child: const Icon(
                Icons.hub_outlined, // 'hub' icon
                color: kPrimaryColor,
                size: 40.0,
              ),
            ),
          ),
        ),
        const Text(
          "Welcome Back",
          style: TextStyle(
            fontSize: 30.0, // text-3xl
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5, // tracking-light
          ),
        ),
        const SizedBox(height: 4.0), // pt-1
        const Text(
          "Log in to continue to your account.",
          style: TextStyle(
            color: kSubtleTextColor,
            fontSize: 16.0, // text-base
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Username ---
          const Text("Username or Email", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8.0), // pb-2
          TextFormField(
            focusNode: _usernameFocus,
            decoration: InputDecoration(
              fillColor: _usernameBg,
              filled: true,
              hintText: "Enter your username or email",
              prefixIcon: const Icon(Icons.person_outline),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16.0), // space-y-4

          // --- Password ---
          const Text("Password", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8.0),
          TextFormField(
            focusNode: _passwordFocus,
            obscureText: _obscureText,
            decoration: InputDecoration(
              fillColor: _passwordBg,
              filled: true,
              hintText: "Enter your password",
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: kSubtleTextColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 8.0),

          // --- Forgot Password ---
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgot-password');
              },
              child: const Text("Forgot Password?"),
            ),
          ),
          const SizedBox(height: 16.0), // pt-4

          // --- Login Button ---
          ElevatedButton(
            onPressed: () {
              // Panggil provider untuk login
              Provider.of<AuthProvider>(context, listen: false).login();
              
              // Navigasi ke dashboard dan hapus halaman login dari tumpukan
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
            child: const Text("LOGIN"),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0), // my-8
      child: Row(
        children: [
          const Expanded(child: Divider(color: kDividerColor, thickness: 1.0)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Or continue with", style: TextStyle(color: kSubtleTextColor, fontSize: 14.0)),
          ),
          const Expanded(child: Divider(color: kDividerColor, thickness: 1.0)),
        ],
      ),
    );
  }

  Widget _buildSocialLogins() {
    return Row(
      children: [
        Expanded(
          child: _SocialLoginButton(
            svgIconData: _googleIconSvg,
            label: "Continue with Google",
          ),
        ),
        const SizedBox(width: 16.0), // gap-4
        Expanded(
          child: _SocialLoginButton(
            svgIconData: _appleIconSvg,
            label: "Continue with Apple",
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0), // mt-8
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "Don't have an account? ",
          style: const TextStyle(
            color: kSubtleTextColor,
            fontSize: 14.0,
          ),
          children: [
            TextSpan(
              text: "Sign Up",
              style: const TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Navigasi ke halaman Sign Up
                  Navigator.pushNamed(context, '/register');
                },
            ),
          ],
        ),
      ),
    );
  }
}

// --- Widget Kustom untuk Efek Blur ---

class _AnimatedBlurCircle extends StatelessWidget {
  final Color color;
  final double size;
  final double sigma;

  const _AnimatedBlurCircle({
    required this.color,
    required this.size,
    this.sigma = 48.0, // blur-3xl
  });

  @override
  Widget build(BuildContext context) {
    // ImageFiltered adalah cara Flutter untuk menerapkan blur pada widget
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// --- Widget Kustom untuk Tombol Social ---

class _SocialLoginButton extends StatelessWidget {
  final String svgIconData;
  final String label;

  const _SocialLoginButton({required this.svgIconData, required this.label});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: kInputBackgroundColor,
        side: const BorderSide(color: kDividerColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // rounded-xl
        ),
        minimumSize: const Size(0, 48.0), // h-12
        padding: const EdgeInsets.symmetric(vertical: 12.0),
      ),
      child: SvgPicture.string(
        svgIconData,
        height: 24.0, // h-6
        width: 24.0, // w-6
        color: Colors.white,
      ),
    );
  }
}

// --- Data SVG untuk Ikon ---
// (Disertakan di sini agar file bisa langsung dijalankan)

const String _googleIconSvg =
    '''<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M21.35,11.1H12.18V13.83H18.69C18.36,17.64 15.19,19.27 12.19,19.27C8.36,19.27 5,16.25 5,12C5,7.9 8.2,4.73 12.19,4.73C15.29,4.73 17.1,6.7 17.1,6.7L19,4.72C19,4.72 16.56,2.1 12.19,2.1C6.42,2.1 2.03,6.8 2.03,12C2.03,17.05 6.16,21.89 12.19,21.89C18.22,21.89 21.5,18.33 21.5,11.33C21.5,11.2 21.35,11.1 21.35,11.1Z" /></svg>''';

const String _appleIconSvg =
    '''<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M18.665 15.343C18.665 12.633 20.386 10.7 22.75 10.7C22.64 10.605 21.32 9.29 21.32 7.12C21.32 4.6 19.43 3 17.26 3C15.91 3 14.73 3.8 13.92 3.8C13.11 3.8 11.76 3 10.41 3C7.8 3 5.8 4.98 5.8 7.6C5.8 9.32 6.57 10.85 7.6 11.83C7.6 11.83 6.09 12.35 6.09 14.83C6.09 17.98 8.61 19.06 10.08 19.06C11.55 19.06 12.18 18.23 13.92 18.23C15.66 18.23 16.18 19.06 17.65 19.06C19.23 19.06 21.37 18.16 21.37 14.83C21.37 14.83 21.35 14.83 21.33 14.83C21.33 14.83 18.665 14.473 18.665 15.343ZM12.9 8.01C13.53 7.18 13.92 6.13 13.92 5.01C13.92 4.99 13.92 4.97 13.92 4.96C13.9 6.08 13.41 7.1 12.78 7.92C12.26 8.59 11.74 9.68 11.74 10.79C11.74 10.81 11.74 10.83 11.74 10.84C11.76 9.72 12.28 8.71 12.9 8.01Z" /></svg>''';