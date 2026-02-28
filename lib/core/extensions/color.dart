import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color withAlphaOpacity(double opacity) => withValues(alpha: opacity);
}
