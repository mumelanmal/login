import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFFf04299);
const Color kDarkBackgroundColor = Color(0xFF010314);
const Color kInputBackgroundColor = Color(0xFF1c0f16);
const Color kInputFocusedBackgroundColor = Color(0xFF221019);
const Color kSubtleTextColor = Color(0xFFb99dab);
const Color kDividerColor = Color(0xFF392830);

// Tambahan konstanta warna yang digunakan di beberapa layar
const Color kDarkTextColor = Color(0xFFFFFFFF);
const Color kPositiveGreen = Color(0xFF16A34A);
// Icon background — representasi warna primer dengan opacity ~20%
const Color kIconBgColor = Color(0x33F04299);
const Color kAccentColor = Color(0xFF6C5CE7);
const Color kLightSubtleTextColor = Color(0xFF6B7280);
const Color kDarkSubtleTextColor = Color(0xFFB0A6AE);

// Compatibility helper: `Color.withOpacity` was deprecated in some SDK versions.
// Use `withOpacitySafe` to create a color with the desired opacity without
// relying on the deprecated API. This avoids precision loss by building a
// new color from ARGB components.
extension ColorOpacitySafe on Color {
	/// Returns this color with the given [opacity] (0.0 - 1.0).
	Color withOpacitySafe(double opacity) {
		final a = (opacity * 255).round().clamp(0, 255);
		// `red`, `green`, `blue` int getters are deprecated in some SDKs.
		// Use the double `r`, `g`, `b` components (0.0 - 1.0) instead.
		final ri = ((r * 255.0).round()) & 0xff;
		final gi = ((g * 255.0).round()) & 0xff;
		final bi = ((b * 255.0).round()) & 0xff;
		return Color.fromARGB(a, ri, gi, bi);
	}
}