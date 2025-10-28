import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login/core/constants.dart';
import 'package:login/widgets/blur_circle.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -size.height * 0.2,
            right: -size.width * 0.3,
            child: const BlurCircle(size: 384, color: kPrimaryColor, opacity: 0.2),
          ),
          Positioned(
            bottom: -size.height * 0.15,
            left: -size.width * 0.25,
            child: const BlurCircle(size: 320, color: kPrimaryColor, opacity: 0.1),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 448),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.string(
                      _logoSvg,
                      height: 48,
                      width: 48,
                      color: kPrimaryColor,
                    ),
                    const SizedBox(height: 12),
                    Text('Create Account', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(decoration: const InputDecoration(hintText: 'Email'), keyboardType: TextInputType.emailAddress),
                          const SizedBox(height: 12),
                          TextFormField(
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Create account')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(onPressed: () => Navigator.pushNamed(context, '/login'), child: const Text('Already have an account? Log in')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const String _logoSvg = '''<svg fill="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12 2L2 7L12 12L22 7L12 2Z"/><path d="M2 17L12 22L22 17L12 12L2 17Z"/><path d="M2 12L12 17L22 12L12 7L2 12Z"/></svg>''';
