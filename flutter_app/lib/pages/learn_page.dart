import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/french_state.dart';
import '../models/vocab_item.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});
  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> with SingleTickerProviderStateMixin {
  VocabItem? _currentWord;
  bool _showAnswer = false;
  bool _correct = false;
  late AnimationController _flipCtrl;
  late Animation<double> _flipAnim;
  int _sessionCount = 0;
  int _sessionCorrect = 0;
  bool _allDone = false;

  @override
  void initState() {
    super.initState();
    _flipCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut));
    _nextWord();
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    super.dispose();
  }

  void _nextWord() {
    _flipCtrl.reset();
    setState(() {
      _showAnswer = false;
      _correct = false;
      _currentWord = frenchState.getNextDueWord(frenchState.activeCategory);
      _allDone = _currentWord == null;
      if (_allDone && frenchState.getDueWords(frenchState.activeCategory).isEmpty) {
        // Check if there are any words at all
        _allDone = true;
      } else if (_currentWord != null) {
        _allDone = false;
      }
    });
  }

  void _reveal() {
    HapticFeedback.lightImpact();
    setState(() => _showAnswer = true);
    _flipCtrl.forward();
  }

  void _answer(bool knewIt) {
    if (_currentWord == null) return;
    HapticFeedback.mediumImpact();
    final item = _currentWord!;
    frenchState.recordAnswer(item, knewIt);
    _sessionCount++;
    if (knewIt) _sessionCorrect++;

    setState(() => _correct = knewIt);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _nextWord();
    });
  }

  void _switchCategory(String cat) {
    frenchState.setCategory(cat);
    _sessionCount = 0;
    _sessionCorrect = 0;
    _nextWord();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn'),
        centerTitle: true,
        actions: [
          if (_sessionCount > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  _sessionCorrect > 0 ? '${(_sessionCorrect / _sessionCount * 100).toInt()}%' : '0%',
                  style: TextStyle(fontWeight: FontWeight.bold, color: cs.primary, fontSize: 14),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryBar(cs),
          Expanded(child: _allDone ? _buildAllDone(cs) : _buildCard(cs)),
          if (!_allDone) _buildAnswerButtons(cs),
        ],
      ),
    );
  }

  Widget _buildCategoryBar(ColorScheme cs) {
    final cats = frenchState.categories;
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final cat = cats[i];
          final active = cat == frenchState.activeCategory;
          final progress = frenchState.categoryProgress[cat] ?? 0;
          return FilterChip(
            label: Text(cat, style: TextStyle(fontSize: 12, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
            selected: active,
            onSelected: (_) => _switchCategory(cat),
            avatar: active
                ? null
                : Text('$progress%', style: TextStyle(fontSize: 9, color: cs.onSurface.withAlpha(150))),
            visualDensity: VisualDensity.compact,
          );
        },
      ),
    );
  }

  Widget _buildCard(ColorScheme cs) {
    final word = _currentWord!;

    return ListenableBuilder(
      listenable: frenchState,
      builder: (context, _) => GestureDetector(
        onTap: _showAnswer ? null : _reveal,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AnimatedBuilder(
              animation: _flipAnim,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(_flipAnim.value * 3.14159),
                  child: _flipAnim.value < 0.5
                      ? _buildFront(cs, word)
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateX(3.14159),
                          child: _buildBack(cs, word),
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFront(ColorScheme cs, VocabItem word) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 300),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.primary.withAlpha(40), width: 2),
        boxShadow: [BoxShadow(color: cs.shadow.withAlpha(20), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (word.gender != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: word.gender == 'm' ? Colors.blue.shade100 : Colors.pink.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(word.gender == 'm' ? 'masculin' : 'féminin',
                style: TextStyle(fontSize: 12, color: word.gender == 'm' ? Colors.blue.shade800 : Colors.pink.shade800, fontWeight: FontWeight.w600),
              ),
            ),
          const SizedBox(height: 16),
          Text(word.french, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: 0.5), textAlign: TextAlign.center),
          if (word.ipa != null) ...[
            const SizedBox(height: 4),
            Text(word.ipa!, style: TextStyle(fontSize: 15, color: cs.onSurface.withAlpha(100), fontStyle: FontStyle.italic)),
          ],
          const SizedBox(height: 8),
          Text(word.category, style: TextStyle(fontSize: 13, color: cs.onSurface.withAlpha(120))),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 10, height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < word.level ? word.levelColor : cs.onSurface.withAlpha(30),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Text('Tap to reveal', style: TextStyle(fontSize: 14, color: cs.primary.withAlpha(180))),
        ],
      ),
    );
  }

  Widget _buildBack(ColorScheme cs, VocabItem word) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 300),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withAlpha(60),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.primary.withAlpha(60), width: 2),
        boxShadow: [BoxShadow(color: cs.shadow.withAlpha(20), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_correct ? Icons.check_circle : Icons.help_outline, size: 48, color: _correct ? Colors.green : cs.primary),
          const SizedBox(height: 12),
          Text(word.english, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: cs.onSurface), textAlign: TextAlign.center),
          if (word.example != null) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text('"${word.example}"',
                style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: cs.onSurface.withAlpha(160)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 10, height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < word.level ? word.levelColor : cs.onSurface.withAlpha(30),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButtons(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: !_showAnswer ? null : () => _answer(false),
              icon: const Icon(Icons.thumb_down_alt_outlined),
              label: const Text('Still Learning'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                foregroundColor: Colors.red,
                side: BorderSide(color: Colors.red.withAlpha(80)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: !_showAnswer ? null : () => _answer(true),
              icon: const Icon(Icons.thumb_up_alt_outlined),
              label: const Text('Got It!'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllDone(ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.celebration, size: 72, color: Colors.amber),
          const SizedBox(height: 16),
          Text('All caught up! 🎉', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'You\'ve reviewed all due words in\n${frenchState.activeCategory}',
            style: TextStyle(color: cs.onSurface.withAlpha(150)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed: () {
              frenchState.setCategory(frenchState.categories[0]);
              _sessionCount = 0;
              _sessionCorrect = 0;
              _nextWord();
            },
            child: const Text('Pick Another Category'),
          ),
        ],
      ),
    );
  }
}
