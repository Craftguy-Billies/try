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
  bool get isInitialized => _initialized;

  Future<void> init() async {
    _logger.logAsyncStart('Audio', 'init');
    try {
      _tts = FlutterTts();
      await _tts!.setLanguage('fr-FR');
      await _tts!.setSpeechRate(0.45);
      await _tts!.setPitch(1.0);
      await _tts!.setVolume(1.0);
      _initialized = true;
      _tts!.setStartHandler(() {
        _isSpeaking = true;
        _logger.logAudio('TTS-start', text: 'speaking');
      });
      _tts!.setCompletionHandler(() {
        _isSpeaking = false;
        _logger.logAudio('TTS-done');
      });
      _tts!.setErrorHandler((msg) {
        _isSpeaking = false;
        _logger.logAudio('TTS-error', data: {'error': msg});
        _logger.error('Audio', 'TTS engine error', e: msg);
      });
      _tts!.setPauseHandler(() {
        _logger.logAudio('TTS-paused');
      });
      _tts!.setContinueHandler(() {
        _logger.logAudio('TTS-resumed');
      });
      _logger.logAsyncDone('Audio', 'init', data: {
        'lang': 'fr-FR', 'rate': 0.45, 'pitch': 1.0, 'volume': 1.0,
      });
    } catch (e, stack) {
      _logger.logAsyncFail('Audio', 'init', e, stack);
    }
  }

  Future<void> speak(String text) async {
    _logger.logAsyncStart('Audio', 'speak', data: {'text_len': text.length, 'text_preview': text.length > 30 ? '${text.substring(0, 30)}…' : text});

    if (!_initialized || _tts == null) {
      _logger.logGuard('Audio', 'not-initialized', data: {'initialized': _initialized, 'tts_null': _tts == null});
      return;
    }

    if (text.isEmpty) {
      _logger.logGuard('Audio', 'empty-text');
      return;
    }

    try {
      if (_isSpeaking) {
        _logger.logEdge('Audio', 'interrupting-current-speech');
        await stop();
      }
      await _tts!.speak(text);
      _logger.logAsyncDone('Audio', 'speak');
    } catch (e, stack) {
      _logger.logAsyncFail('Audio', 'speak', e, stack);
    }
  }

  Future<void> stop() async {
    _logger.logAsyncStart('Audio', 'stop');
    try {
      await _tts?.stop();
      _logger.logAsyncDone('Audio', 'stop');
    } catch (e) {
      _logger.debug('Audio', 'stop error suppressed', data: {'error': e.toString()});
    }
    _isSpeaking = false;
  }

  void dispose() {
    _logger.logDispose('AudioService');
    _tts?.stop();
    _tts = null;
    _initialized = false;
    _isSpeaking = false;
  }
}
