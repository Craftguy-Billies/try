import 'package:flutter_tts/flutter_tts.dart';
import 'audit_logger.dart';

class AudioService {
  static final AudioService _instance = AudioService._();
  factory AudioService() => _instance;
  AudioService._();

  final _logger = AuditLogger();
  FlutterTts? _tts;
  bool _initialized = false;
  bool _isSpeaking = false;

  bool get isSpeaking => _isSpeaking;

  Future<void> init() async {
    try {
      _tts = FlutterTts();
      await _tts!.setLanguage('fr-FR');
      await _tts!.setSpeechRate(0.45);
      await _tts!.setPitch(1.0);
      await _tts!.setVolume(1.0);
      _initialized = true;
      _tts!.setStartHandler(() => _isSpeaking = true);
      _tts!.setCompletionHandler(() => _isSpeaking = false);
      _tts!.setErrorHandler((msg) {
        _isSpeaking = false;
        _logger.error('Audio', 'TTS error', e: msg);
      });
      _logger.info('Audio', 'Initialized');
    } catch (e, stack) {
      _logger.error('Audio', 'Init failed', e: e, s: stack);
    }
  }

  Future<void> speak(String text) async {
    if (!_initialized || _tts == null) {
      _logger.warn('Audio', 'Not initialized');
      return;
    }
    try {
      if (_isSpeaking) await stop();
      await _tts!.speak(text);
    } catch (e, stack) {
      _logger.error('Audio', 'Speak failed', e: e, s: stack);
    }
  }

  Future<void> stop() async {
    try { await _tts?.stop(); } catch (_) {}
    _isSpeaking = false;
  }

  void dispose() {
    _tts?.stop();
    _tts = null;
    _initialized = false;
  }
}
