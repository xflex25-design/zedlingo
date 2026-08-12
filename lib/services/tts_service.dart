import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  TTSService._internal();

  late final FlutterTts _flutterTts;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _flutterTts = FlutterTts();

    await _flutterTts.setSharedInstance(true);
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _isInitialized = true;
  }

  Future<void> speak(String text, {String? languageCode}) async {
    if (!_isInitialized) await initialize();

    String lang = 'en-US';
    switch (languageCode) {
      case 'bemba':
        lang = 'en-US'; // Fallback - TTS doesn't have Bemba
        break;
      case 'nyanja':
        lang = 'en-US';
        break;
      case 'tonga':
        lang = 'en-US';
        break;
      case 'lozi':
        lang = 'en-US';
        break;
      case 'lunda':
        lang = 'en-US';
        break;
      case 'kaonde':
        lang = 'en-US';
        break;
      case 'luvale':
        lang = 'en-US';
        break;
    }

    await _flutterTts.setLanguage(lang);
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    if (!_isInitialized) return;
    await _flutterTts.stop();
  }

  Future<void> setSpeed(double speed) async {
    if (!_isInitialized) return;
    await _flutterTts.setSpeechRate(speed);
  }

  Future<void> dispose() async {
    if (!_isInitialized) return;
    await _flutterTts.stop();
  }
}
