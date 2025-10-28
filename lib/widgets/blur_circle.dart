import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:login/core/constants.dart';

class BlurCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double sigma;
  final bool isCircle;
  final double opacity;

  const BlurCircle({
    super.key,
    required this.size,
    required this.color,
    this.sigma = 48.0,
    this.isCircle = true,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color.withOpacitySafe(opacity),
          borderRadius: isCircle ? null : BorderRadius.circular(24.0),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }
}
