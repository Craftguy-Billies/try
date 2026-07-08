# Craftguy-Billies/try — Project Memory

## Architecture
- **Flutter app** (`flutter_app/`): French learning app — 5 tabs, Material 3, web + Android
- **Global state**:
  - `AppState extends ChangeNotifier` at `lib/state/app_state.dart` — logging/infra
  - `FrenchState extends ChangeNotifier` at `lib/state/french_state.dart` — SRS vocab, XP, streaks, quiz
- **State pattern**: `ListenableBuilder(listenable: frenchState)` for reactive UI; singleton instances

## File Map (18 hand-written Dart files)
```
flutter_app/lib/
├── main.dart                  (190 lines) — entry, FrenchApp, MainShell, 5 tabs, PopScope
├── state/
│   ├── app_state.dart         (217 lines) — ChangeNotifier: logging, lifecycle
│   └── french_state.dart      (~260 lines) — ChangeNotifier: vocab SRS, XP, streaks, quiz gen
├── models/
│   ├── log_entry.dart         (9 lines)  — immutable log entry
│   ├── todo_item.dart         (22 lines) — immutable TodoItem (legacy)
│   ├── vocab_item.dart        (~80 lines) — VocabItem with SRS levels, mastery, colors
│   └── verb.dart              (~50 lines) — VerbConjugation, GrammarLesson
├── data/
│   ├── french_vocab.dart      (~170 lines) — 120+ words across 8 categories
│   ├── french_verbs.dart      (~100 lines) — 10 verbs x 4 tenses
│   └── french_grammar.dart    (~200 lines) — 10 grammar lessons
├── pages/
│   ├── learn_page.dart        (~280 lines) — flashcards with flip anim, category bar
│   ├── practice_page.dart     (~280 lines) — multiple choice quiz, progress bar
│   ├── conjugation_page.dart  (~200 lines) — verb conjugation tables, tense tabs
│   ├── grammar_page.dart      (~200 lines) — grammar lesson browser with filter
│   └── progress_page.dart     (~330 lines) — XP, streaks, study calendar, category breakdown
└── widgets/
    ├── error_boundary.dart    (75 lines) — error catch + restore builder
    └── confetti.dart          (110 lines) — particle burst animation
```

## Critical Fix History (do NOT regress)
1. **Confetti overlay blocks taps**: wrap CustomPaint in IgnorePointer
2. **ErrorBoundary global corruption**: save/restore ErrorWidget.builder in initState/dispose
3. **Void expression in collection**: call void methods from addPostFrameCallback, never inline in children lists
4. **Null safety**: Never use `!` without prior null check

## Build Commands
```bash
# Web
cd flutter_app && flutter build web
# APK (Android SDK 35, NDK 26.3, Java 21)
cd flutter_app && flutter build apk --release
# Serve on port 12001
cd flutter_app/build/web && python3 -m http.server 12001 --bind 0.0.0.0
```

## Key Patterns
- **Reactivity**: Use `ListenableBuilder(listenable: frenchState)` for French state; `appState` for logs
- **Haptics**: Import `flutter/services.dart`, use `HapticFeedback.lightImpact()` / `heavyImpact()`
- **Logging**: Always call `appState.log(category, detail, color:)` before/after state changes
- **SRS**: VocabItem has level 0-5 with intervals [0, 4, 24, 72, 168, 720] hours
- **Data singularity**: frenchState._vocab is the single source of truth; use getDueWords() for quiz items
- **Tab state**: `AnimatedSwitcher` without keys recreates page state on tab switch; global state preserves progress

## Stored Numbers
- **42**: Referenced by conversation CONV-1783504095-A
