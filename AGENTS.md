# Craftguy-Billies/try — Project Memory

## Architecture
- **Flutter app** (`flutter_app/`): Multi-tab web + Android app, Material 3, CanvasKit renderer
- **trialhost.html**: Standalone Vanilla JS debug panel (DOM-based, ~1070 lines, 32+ event categories)
- **Global state**: Singleton `AppState extends ChangeNotifier` at `lib/state/app_state.dart`
- **State pattern**: `ListenableBuilder(listenable: appState, ...)` for reactive UI; `appState.addListener` for pages needing side effects (scroll, keyboard observer)

## File Map (13 hand-written Dart files, 3,077 lines total)
```
flutter_app/lib/
├── main.dart              (176 lines) — entry, TrialHostApp, MainShell, 7 tabs, PopScope
├── state/
│   └── app_state.dart     (217 lines) — ChangeNotifier: counter, tasks, controls, form, lifecycle, logging
├── models/
│   ├── log_entry.dart     (9 lines)  — immutable log entry
│   └── todo_item.dart     (22 lines) — immutable TodoItem with copyWith
├── pages/
│   ├── counter_page.dart  (163 lines) — confetti + haptic + milestone badges + gesture pad
│   ├── tasks_page.dart    (245 lines) — CRUD todo with undo
│   ├── controls_page.dart (147 lines) — sliders, switches, rating, dropdown, chips
│   ├── form_page.dart     (277 lines) — validated registration form
│   ├── logs_page.dart     (179 lines) — log viewer with filter + auto-scroll
│   ├── drawing_page.dart  (190 lines) — finger-paint canvas: 12 colors, undo/redo/clear
│   └── reaction_page.dart (208 lines) — reflex game: idle→waiting→ready→tap state machine
└── widgets/
    ├── error_boundary.dart (75 lines) — catches errors, logs to appState, restores builder
    └── confetti.dart       (110 lines) — particle burst animation (CustomPainter + AnimationController)
```

## Critical Fix History (do NOT regress)
1. **Confetti overlay blocks taps** (2026-06-24): `ConfettiWidget`'s `CustomPaint(size: Size.infinite)` in Stack was on top of child, intercepting all pointer events. Fix: wrap in `IgnorePointer`.
2. **LogsPage never rebuilt** (2026-06-24): `_onStateChanged` didn't call `setState()`. Fix: add `setState(() {})` after auto-scroll logic.
3. **ErrorBoundary global corruption** (2026-06-24): `ErrorWidget.builder` overridden globally, never restored. Fix: save original in initState, restore in dispose.
4. **FormPage null assert** (2026-06-24): `_formKey.currentState!` could crash. Fix: null-safe guard + mounted check.
5. **Counter reactivity** (2026-06-24): Pages were StatelessWidget reading appState once. Fix: `ListenableBuilder` or `addListener` pattern on all pages.

## Build Commands
```bash
# Web (served at port 12001)
cd flutter_app && flutter build web
# APK (Android SDK 35, NDK 26.3, Java 21)
cd flutter_app && flutter build apk --release
# Serve
cd flutter_app/build/web && python3 -m http.server 12001 --bind 0.0.0.0
```

## Key Patterns
- **Reactivity**: Always use `ListenableBuilder(listenable: appState)` to wrap UI that reads appState
- **Haptics**: Import `flutter/services.dart`, use `HapticFeedback.lightImpact()` / `heavyImpact()`
- **Logging**: Always call `appState.log(category, detail, color:)` before/after state changes
- **Dispose**: Cancel timers, remove listeners, restore global state in `dispose()`
- **Null safety**: Never use `!` on nullable values without prior null check
- **CustomPaint overlays**: Always wrap in `IgnorePointer` to let touches pass through
- **Duplicates**: Check for duplicate imports and const constructors before committing
- **Tab state**: `AnimatedSwitcher` without keys recreates page state on tab switch; appState must be the single source of truth
