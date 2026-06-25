
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../i18n/translations.dart';
import '../../models/vocabulary.dart';
import '../../services/audit_logger.dart';
import '../../services/audio_service.dart';
import '../home/home_screen.dart';

class FlashcardScreen extends StatefulWidget {
  final List<VocabularyWord> words;
  const FlashcardScreen({super.key, required this.words});
  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> with SingleTickerProviderStateMixin {
  final _logger = AuditLogger();
  int _index = 0;
  bool _showBack = false;
  late AnimationController _flipCtrl;
  late Animation<double> _flipAnim;

  @override
  void initState() {
    super.initState();
    _logger.logInit('Flashcard', data: {'wordCount': widget.words.length});
    _logger.logScreenView('Flashcard', p: {'words': widget.words.length});
    _flipCtrl = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut));
    _flipCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) _logger.logAnimationDone('Flashcard', 'flip-forward');
      if (status == AnimationStatus.dismissed) _logger.logAnimationDone('Flashcard', 'flip-reverse');
    });
  }

  @override
  void dispose() {
    _logger.logDispose('Flashcard', data: {'lastIndex': _index, 'total': widget.words.length});
    _flipCtrl.dispose();
    super.dispose();
  }

  void _flip() {
    final oldShowBack = _showBack;
    if (_showBack) {
      _logger.logAnimationStart('Flashcard', 'flip-reverse');
      _flipCtrl.reverse();
    } else {
      _logger.logAnimationStart('Flashcard', 'flip-forward');
      _flipCtrl.forward();
    }
    setState(() => _showBack = !_showBack);
    _logger.logTap('Flashcard', 'card-flip', data: {'front→back': oldShowBack ? 'no' : 'yes'});
  }

  void _next() {
    if (_index < widget.words.length - 1) {
      final oldIdx = _index;
      final completedWord = widget.words[_index];
      setState(() { _index++; _showBack = false; _flipCtrl.reset(); });
      _logger.logStateChangeInt('Flashcard', 'index', oldIdx, _index);
      final progress = context.read<UserProgressProvider>();
      progress.markWordComplete(completedWord.id, completedWord.category);
      _logger.logButton('Flashcard', 'Next', data: {'completed': completedWord.id, 'newIdx': _index});

      if (_index >= widget.words.length - 1) {
        _logger.logEdge('Flashcard', 'last-word-reached', data: {'index': _index, 'total': widget.words.length});
        _logger.info('Flashcard', '🎉 All flashcards completed!', data: {'total': widget.words.length, 'completed': completedWord.id});
      }
    } else {
      _logger.logGuard('Flashcard', 'next-at-end', data: {'index': _index, 'total': widget.words.length});
      _logger.info('Flashcard', '🎉 All flashcards already completed!', data: {'total': widget.words.length});
    }
  }

  void _prev() {
    if (_index > 0) {
      final oldIdx = _index;
      setState(() { _index--; _showBack = false; _flipCtrl.reset(); });
      _logger.logStateChangeInt('Flashcard', 'index', oldIdx, _index);
      _logger.logButton('Flashcard', 'Prev', data: {'newIdx': _index});
    } else {
      _logger.logGuard('Flashcard', 'prev-at-start');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations(Localizations.localeOf(context).languageCode);
    final word = widget.words[_index];
    return Scaffold(
      appBar: AppBar(title: Text(t.get('flashcards')),
        actions: [Text('${_index + 1}/${widget.words.length}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
        ]),
      body: Column(children: [
        Expanded(child: GestureDetector(onTap: _flip,
          child: AnimatedBuilder(animation: _flipAnim, builder: (ctx, child) {
            final isFront = _flipAnim.value < 0.5;
            return Transform(alignment: Alignment.center, transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)..rotateY(_flipAnim.value * 3.14159),
              child: Container(margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: isFront ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(40), blurRadius: 20, offset: const Offset(0, 8))]),
                child: Center(child: isFront
                  ? Padding(padding: const EdgeInsets.all(32),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(word.french, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white)),
                        if (word.pronunciation != null) ...[
                          const SizedBox(height: 8),
                          Text(word.pronunciation!, style: TextStyle(fontSize: 16, color: Colors.white.withAlpha(200))),
                        ],
                        const SizedBox(height: 16),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white.withAlpha(30), borderRadius: BorderRadius.circular(20)),
                          child: Text(word.partOfSpeech, style: const TextStyle(color: Colors.white, fontSize: 14))),
                        if (word.gender != null) ...[const SizedBox(height: 8),
                          Text(word.gender!, style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 13))],
                      ]))
                  : Padding(padding: const EdgeInsets.all(32),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(word.english, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        const SizedBox(height: 16),
                        if (word.exampleFrench != null) ...[
                          Text(word.exampleFrench!, textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                          const SizedBox(height: 6),
                          Text(word.exampleEnglish!, textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: AppColors.textSecondary.withAlpha(180))),
                        ],
                      ])),
                )));
          })),
        ),
        Padding(padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton.filled(onPressed: _index > 0 ? _prev : null, icon: const Icon(Icons.arrow_back)),
            IconButton.filled(onPressed: () {
              _logger.logButton('Flashcard', 'Audio:${word.french}');
              context.read<AudioService>().speak(word.french);
            }, icon: const Icon(Icons.volume_up), style: IconButton.styleFrom(backgroundColor: AppColors.accent)),
            IconButton.filled(onPressed: _index < widget.words.length - 1 ? _next : null, icon: const Icon(Icons.arrow_forward)),
          ])),
        const SizedBox(height: 8),
      ]),
    );
  }
}