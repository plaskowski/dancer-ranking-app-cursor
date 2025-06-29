import 'package:flutter/material.dart';

/// Custom theme extension for dance-specific colors
/// These colors are used for dance-related features like recording dances,
/// ranking dancers, and attendance tracking
@immutable
class DanceThemeExtension extends ThemeExtension<DanceThemeExtension> {
  const DanceThemeExtension({
    required this.danceAccent,
    required this.onDanceAccent,
    required this.danceAccentContainer,
    required this.onDanceAccentContainer,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.present,
    required this.onPresent,
    required this.presentContainer,
    required this.onPresentContainer,
    required this.absent,
    required this.onAbsent,
    required this.absentContainer,
    required this.onAbsentContainer,
    required this.rankingHigh,
    required this.onRankingHigh,
    required this.rankingNeutral,
    required this.onRankingNeutral,
  });

  final Color danceAccent;
  final Color onDanceAccent;
  final Color danceAccentContainer;
  final Color onDanceAccentContainer;

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  final Color present;
  final Color onPresent;
  final Color presentContainer;
  final Color onPresentContainer;

  final Color absent;
  final Color onAbsent;
  final Color absentContainer;
  final Color onAbsentContainer;

  final Color rankingHigh;
  final Color onRankingHigh;
  final Color rankingNeutral;
  final Color onRankingNeutral;

  @override
  DanceThemeExtension copyWith({
    Color? danceAccent,
    Color? onDanceAccent,
    Color? danceAccentContainer,
    Color? onDanceAccentContainer,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? present,
    Color? onPresent,
    Color? presentContainer,
    Color? onPresentContainer,
    Color? absent,
    Color? onAbsent,
    Color? absentContainer,
    Color? onAbsentContainer,
    Color? rankingHigh,
    Color? onRankingHigh,
    Color? rankingNeutral,
    Color? onRankingNeutral,
  }) {
    return DanceThemeExtension(
      danceAccent: danceAccent ?? this.danceAccent,
      onDanceAccent: onDanceAccent ?? this.onDanceAccent,
      danceAccentContainer: danceAccentContainer ?? this.danceAccentContainer,
      onDanceAccentContainer:
          onDanceAccentContainer ?? this.onDanceAccentContainer,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      present: present ?? this.present,
      onPresent: onPresent ?? this.onPresent,
      presentContainer: presentContainer ?? this.presentContainer,
      onPresentContainer: onPresentContainer ?? this.onPresentContainer,
      absent: absent ?? this.absent,
      onAbsent: onAbsent ?? this.onAbsent,
      absentContainer: absentContainer ?? this.absentContainer,
      onAbsentContainer: onAbsentContainer ?? this.onAbsentContainer,
      rankingHigh: rankingHigh ?? this.rankingHigh,
      onRankingHigh: onRankingHigh ?? this.onRankingHigh,
      rankingNeutral: rankingNeutral ?? this.rankingNeutral,
      onRankingNeutral: onRankingNeutral ?? this.onRankingNeutral,
    );
  }

  @override
  DanceThemeExtension lerp(
      ThemeExtension<DanceThemeExtension>? other, double t) {
    if (other is! DanceThemeExtension) {
      return this;
    }
    return DanceThemeExtension(
      danceAccent: Color.lerp(danceAccent, other.danceAccent, t)!,
      onDanceAccent: Color.lerp(onDanceAccent, other.onDanceAccent, t)!,
      danceAccentContainer:
          Color.lerp(danceAccentContainer, other.danceAccentContainer, t)!,
      onDanceAccentContainer:
          Color.lerp(onDanceAccentContainer, other.onDanceAccentContainer, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      present: Color.lerp(present, other.present, t)!,
      onPresent: Color.lerp(onPresent, other.onPresent, t)!,
      presentContainer:
          Color.lerp(presentContainer, other.presentContainer, t)!,
      onPresentContainer:
          Color.lerp(onPresentContainer, other.onPresentContainer, t)!,
      absent: Color.lerp(absent, other.absent, t)!,
      onAbsent: Color.lerp(onAbsent, other.onAbsent, t)!,
      absentContainer: Color.lerp(absentContainer, other.absentContainer, t)!,
      onAbsentContainer:
          Color.lerp(onAbsentContainer, other.onAbsentContainer, t)!,
      rankingHigh: Color.lerp(rankingHigh, other.rankingHigh, t)!,
      onRankingHigh: Color.lerp(onRankingHigh, other.onRankingHigh, t)!,
      rankingNeutral: Color.lerp(rankingNeutral, other.rankingNeutral, t)!,
      onRankingNeutral:
          Color.lerp(onRankingNeutral, other.onRankingNeutral, t)!,
    );
  }

  /// Light theme extension
  static const DanceThemeExtension light = DanceThemeExtension(
    danceAccent: Color(0xFF7B1FA2), // Material Purple 700
    onDanceAccent: Color(0xFFFFFFFF),
    danceAccentContainer: Color(0xFFF3E5F5), // Material Purple 50
    onDanceAccentContainer: Color(0xFF4A148C), // Material Purple 900

    success: Color(0xFF388E3C), // Material Green 700
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFE8F5E8), // Material Green 50
    onSuccessContainer: Color(0xFF1B5E20), // Material Green 900

    warning: Color(0xFFF57C00), // Material Orange 700
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFFF3E0), // Material Orange 50
    onWarningContainer: Color(0xFFE65100), // Material Orange 900

    present: Color(0xFF388E3C), // Material Green 700
    onPresent: Color(0xFFFFFFFF),
    presentContainer: Color(0xFFE8F5E8), // Material Green 50
    onPresentContainer: Color(0xFF1B5E20), // Material Green 900

    absent: Color(0xFFD32F2F), // Material Red 700
    onAbsent: Color(0xFFFFFFFF),
    absentContainer: Color(0xFFFFEBEE), // Material Red 50
    onAbsentContainer: Color(0xFFB71C1C), // Material Red 900

    rankingHigh: Color(0xFF1976D2), // Material Blue 700
    onRankingHigh: Color(0xFFFFFFFF),
    rankingNeutral: Color(0xFF616161), // Material Grey 700
    onRankingNeutral: Color(0xFFFFFFFF),
  );

  /// Dark theme extension
  static const DanceThemeExtension dark = DanceThemeExtension(
    danceAccent: Color(0xFFCE93D8), // Material Purple 200
    onDanceAccent: Color(0xFF4A148C), // Material Purple 900
    danceAccentContainer: Color(0xFF6A1B9A), // Material Purple 800
    onDanceAccentContainer: Color(0xFFF3E5F5), // Material Purple 50

    success: Color(0xFF81C784), // Material Green 300
    onSuccess: Color(0xFF1B5E20), // Material Green 900
    successContainer: Color(0xFF2E7D32), // Material Green 800
    onSuccessContainer: Color(0xFFE8F5E8), // Material Green 50

    warning: Color(0xFFFFB74D), // Material Orange 300
    onWarning: Color(0xFFE65100), // Material Orange 900
    warningContainer: Color(0xFFF57C00), // Material Orange 700
    onWarningContainer: Color(0xFFFFF3E0), // Material Orange 50

    present: Color(0xFF81C784), // Material Green 300
    onPresent: Color(0xFF1B5E20), // Material Green 900
    presentContainer: Color(0xFF2E7D32), // Material Green 800
    onPresentContainer: Color(0xFFE8F5E8), // Material Green 50

    absent: Color(0xFFEF5350), // Material Red 400
    onAbsent: Color(0xFFB71C1C), // Material Red 900
    absentContainer: Color(0xFFD32F2F), // Material Red 700
    onAbsentContainer: Color(0xFFFFEBEE), // Material Red 50

    rankingHigh: Color(0xFF90CAF9), // Material Blue 200
    onRankingHigh: Color(0xFF0D47A1), // Material Blue 900
    rankingNeutral: Color(0xFFBDBDBD), // Material Grey 400
    onRankingNeutral: Color(0xFF212121), // Material Grey 900
  );
}

/// Helper extension to get dance theme from context
extension DanceThemeContext on BuildContext {
  DanceThemeExtension get danceTheme =>
      Theme.of(this).extension<DanceThemeExtension>()!;
}
