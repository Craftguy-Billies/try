import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/app_state.dart';

import '../i18n/app_localizations.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _animController;
  int _currentPage = 0;
  Locale? _selectedLocale;

  static const _supportedLanguages = [
    _LangOption('English', '🇬🇧', 'en'),
    _LangOption('中文', '🇨🇳', 'zh'),
    _LangOption('日本語', '🇯🇵', 'ja'),
    _LangOption('한국어', '🇰🇷', 'ko'),
    _LangOption('Español', '🇪🇸', 'es'),
    _LangOption('Français', '🇫🇷', 'fr'),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    if (_selectedLocale != null) {
      AppState().setLocale(_selectedLocale!);
    }
    AppState().setOnboardingComplete();
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A237E),
              Color(0xFF283593),
              Color(0xFF3949AB),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(l10n),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                    HapticFeedback.selectionClick();
                  },
                  children: [
                    _buildPageOne(l10n, theme),
                    _buildPageTwo(l10n, theme),
                    _buildPageThree(l10n, theme),
                  ],
                ),
              ),
              _buildBottomSection(l10n, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(3, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == i ? 24.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: _currentPage == i
                      ? Colors.white
                      : Colors.white.withAlpha(100),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          if (_currentPage < 2)
            TextButton(
              onPressed: _finishOnboarding,
              child: Text(
                l10n.skip,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildPageOne(AppLocalizations l10n, ThemeData theme) {
    return _OnboardingSlide(
      emoji: '📚',
      title: l10n.onboardingTitle1,
      description: l10n.onboardingDesc1,
      gradientColors: const [
        Color(0xFF1A237E),
        Color(0xFF4A148C),
      ],
    );
  }

  Widget _buildPageTwo(AppLocalizations l10n, ThemeData theme) {
    return _OnboardingSlide(
      emoji: '✍️',
      title: l10n.onboardingTitle2,
      description: l10n.onboardingDesc2,
      gradientColors: const [
        Color(0xFF004D40),
        Color(0xFF00695C),
      ],
    );
  }

  Widget _buildPageThree(AppLocalizations l10n, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Text(
            '🌍',
            style: TextStyle(fontSize: 56),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.onboardingWelcome,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingSelectLang,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withAlpha(180),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: _supportedLanguages.map((lang) {
              final isSelected =
                  _selectedLocale?.languageCode == lang.code;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedLocale = Locale(lang.code));
                  HapticFeedback.lightImpact();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 100,
                  height: 110,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withAlpha(50)
                        : Colors.white.withAlpha(15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? Colors.amberAccent
                          : Colors.white.withAlpha(30),
                      width: isSelected ? 2.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.amberAccent.withAlpha(60),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lang.flag,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lang.name,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.amberAccent
                              : Colors.white,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      if (isSelected)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.amberAccent,
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBottomSection(AppLocalizations l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: _currentPage < 2
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.icon(
                  onPressed: () => _goToPage(_currentPage + 1),
                  icon: const Icon(Icons.arrow_forward, size: 20),
                  label: Text(l10n.next),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: const Color(0xFF1A237E),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          : SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _finishOnboarding,
                icon: const Icon(Icons.rocket_launch, size: 22),
                label: Text(l10n.getStarted),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                  foregroundColor: const Color(0xFF1A237E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
    );
  }
}

class _LangOption {
  final String name;
  final String flag;
  final String code;
  const _LangOption(this.name, this.flag, this.code);
}

class _OnboardingSlide extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final List<Color> gradientColors;

  const _OnboardingSlide({
    required this.emoji,
    required this.title,
    required this.description,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withAlpha(30),
                  Colors.white.withAlpha(10),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 52)),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withAlpha(200),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
