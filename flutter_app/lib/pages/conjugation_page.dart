import 'package:flutter/material.dart';
import '../data/french_verbs.dart';
import '../models/verb.dart';
import '../state/app_state.dart';

class ConjugationPage extends StatefulWidget {
  const ConjugationPage({super.key});
  @override
  State<ConjugationPage> createState() => _ConjugationPageState();
}

class _ConjugationPageState extends State<ConjugationPage> {
  int _verbIndex = 0;
  String _activeTense = 'Présent';

  VerbConjugation get _verb => frenchVerbs[_verbIndex];
  String get _groupLabel {
    switch (_verb.group) {
      case 'er': return '-ER verb';
      case 'ir': return '-IR verb';
      case 're': return '-RE verb';
      default: return 'Irregular';
    }
  }

  Color get _groupColor {
    switch (_verb.group) {
      case 'er': return Colors.blue;
      case 'ir': return Colors.orange;
      case 're': return Colors.purple;
      default: return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conjugations'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Verb selector
          _buildVerbSelector(cs),
          // Tense tabs
          _buildTenseTabs(cs),
          // Conjugation table
          Expanded(child: _buildConjugationTable(cs)),
        ],
      ),
    );
  }

  Widget _buildVerbSelector(ColorScheme cs) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: frenchVerbs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final v = frenchVerbs[i];
          final selected = i == _verbIndex;
          return ChoiceChip(
            label: Text(v.infinitive, style: const TextStyle(fontSize: 13)),
            selected: selected,
            onSelected: (_) {
              setState(() => _verbIndex = i);
              appState.log('FRENCH', 'Conjugation: ${v.infinitive} (${v.group})', color: Colors.indigo);
            },
            avatar: selected ? null : Text(v.meaning, style: TextStyle(fontSize: 10, color: cs.onSurface.withAlpha(120))),
            visualDensity: VisualDensity.compact,
          );
        },
      ),
    );
  }

  Widget _buildTenseTabs(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: VerbConjugation.tenses.map((tense) {
          final active = tense == _activeTense;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: InkWell(
                onTap: () => setState(() => _activeTense = tense),
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: active ? cs.primary : cs.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: active ? cs.primary : cs.outline.withAlpha(50)),
                  ),
                  child: Text(
                    tense,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      color: active ? cs.onPrimary : cs.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildConjugationTable(ColorScheme cs) {
    final pronouns = VerbConjugation.pronouns;
    final shortPronouns = ['je', 'tu', 'il/elle', 'nous', 'vous', 'ils/elles'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Verb info header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _groupColor.withAlpha(20),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _groupColor.withAlpha(50)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _groupColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_groupLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_verb.infinitive, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                      Text(_verb.meaning, style: TextStyle(color: cs.onSurface.withAlpha(150), fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Conjugation rows
          ...List.generate(pronouns.length, (i) {
            final pronoun = pronouns[i];
            final short = shortPronouns[i];
            final form = _verb.conjugated(pronoun, _activeTense);
            final isEven = i % 2 == 0;

            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isEven ? cs.surfaceContainerHighest.withAlpha(70) : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(short, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface.withAlpha(180))),
                  ),
                  Expanded(
                    child: Text(
                      form,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: cs.primary, letterSpacing: 0.3),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          // Quick reference for this tense pattern
          if (_activeTense == 'Présent') _buildTenseTips(cs),
        ],
      ),
    );
  }

  Widget _buildTenseTips(ColorScheme cs) {
    String pattern;
    switch (_verb.group) {
      case 'er':
        pattern = 'Regular -ER pattern: -e, -es, -e, -ons, -ez, -ent';
        break;
      case 'ir':
        pattern = 'Regular -IR pattern: -is, -is, -it, -issons, -issez, -issent';
        break;
      case 're':
        pattern = 'Regular -RE pattern: -s, -s, —, -ons, -ez, -ent';
        break;
      default:
        pattern = 'Irregular verb — memorize this one!';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer.withAlpha(80),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, size: 20, color: cs.tertiary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(pattern, style: TextStyle(fontSize: 12, color: cs.onTertiaryContainer, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
