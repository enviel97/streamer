import 'package:flutter/cupertino.dart';

class Spacing {
  const Spacing();
  static const xs = 8.0;
  static const s = 14.0;
  static const sm = 16.0;
  static const m = 18.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 40.0;
  static const xxxl = 56.0;

  static const horizantal = _Horizantal();
  static const vertical = _Vertical();
}

class _Horizantal {
  const _Horizantal();

  /// xs = 8.0;
  SizedBox get xs => const SizedBox(width: Spacing.xs);

  /// s = 14.0;
  SizedBox get s => const SizedBox(width: Spacing.s);

  /// sm = 16.0;
  SizedBox get sm => const SizedBox(width: Spacing.sm);

  /// m = 18.0;
  SizedBox get m => const SizedBox(width: Spacing.m);

  /// lg = 24.0;
  SizedBox get lg => const SizedBox(width: Spacing.lg);

  /// xl = 32.0;
  SizedBox get xl => const SizedBox(width: Spacing.xl);

  /// xxl = 40.0;
  SizedBox get xxl => const SizedBox(width: Spacing.xxl);

  /// xxxl = 56.0;
  SizedBox get xxxl => const SizedBox(width: Spacing.xxxl);

  // Custom size
  SizedBox k(double size) => SizedBox(width: size);
}

class _Vertical {
  const _Vertical();

  /// xs = 8.0;
  SizedBox get xs => const SizedBox(height: Spacing.xs);

  /// s = 14.0;
  SizedBox get s => const SizedBox(height: Spacing.s);

  /// sm = 16.0;
  SizedBox get sm => const SizedBox(height: Spacing.sm);

  /// m = 18.0;
  SizedBox get m => const SizedBox(height: Spacing.m);

  /// lg = 24.0;
  SizedBox get lg => const SizedBox(height: Spacing.lg);

  /// xl = 32.0;
  SizedBox get xl => const SizedBox(height: Spacing.xl);

  /// xxl = 40.0;
  SizedBox get xxl => const SizedBox(height: Spacing.xxl);

  /// xxxl = 56.0;
  SizedBox get xxxl => const SizedBox(height: Spacing.xxxl);

  // Custom size
  SizedBox k(double size) => SizedBox(height: size);
}
