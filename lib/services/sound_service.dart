import 'package:flutter/services.dart';

/// Sound service for Zedlingo — uses haptic feedback as sound simulation
/// since audio packages aren't in the available stack.
/// Visual + haptic feedback creates the "sound" experience.
class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  bool _enabled = true;

  bool get isEnabled => _enabled;

  void toggle() => _enabled = !_enabled;

  Future<void> playCorrect() async {
    if (!_enabled) return;
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.lightImpact();
  }

  Future<void> playIncorrect() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  Future<void> playTap() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }

  Future<void> playStreak() async {
    if (!_enabled) return;
    for (int i = 0; i < 3; i++) {
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 60));
    }
  }

  Future<void> playXpEarned() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.mediumImpact();
  }

  Future<void> playLessonComplete() async {
    if (!_enabled) return;
    for (int i = 0; i < 4; i++) {
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 80));
    }
  }
}
