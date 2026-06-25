import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:french_app/debug/debug_logger.dart';
import 'package:french_app/i18n/app_localizations.dart';
import 'package:french_app/screens/home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      icon: Icons.school_rounded,
      gradient: [Color(0xFFFF6B35), Color(0xFFFF8C5A), Color(0xFFFFB347)],
      titleKey: 'onboarding_feature1_title',
      descKey: 'onboarding_feature1_desc',
    ),
    _OnboardingPageData(
      icon: Icons.star_rounded,
      gradient: [Color(0xFF4A6CF7), Color(0xFF6B8AFF), Color(0xFF9B59B6)],
      titleKey: 'onboarding_feature2_title',
      descKey: 'onboarding_feature2_desc',
    ),
    _OnboardingPageData(
      icon: Icons.trending_up_rounded,
      gradient: [Color(0xFF00B894), Color(0xFF00CEC9), Color(0xFF55EFC4)],
      titleKey: 'onboarding_feature3_title',
      descKey: 'onboarding_feature3_desc',
    ),
  ];

  @override
  void initState() {
    super.initState();
    DebugLogger.logScreenView('OnboardingScreen');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    DebugLogger.logAction('Onboarding completed');

    if (!mounted) return;
    DebugLogger.logNavigation('OnboardingScreen', 'HomeScreen');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    DebugLogger.logScreenView('OnboardingPage${page + 1}');
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return _buildPage(page, i18n);
            },
          ),
          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: TextButton(
              onPressed: _completeOnboarding,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                i18n.onboarding_skip,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Bottom section: dots + button
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 24,
            left: 24,
            right: 24,
            child: Column(
              children: [
                // Dot indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (index) {
                    final isActive = index == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 28 : 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                // Next / Get Started button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLastPage
                        ? _completeOnboarding
                        : () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: _pages[_currentPage].gradient[1],
                      elevation: 4,
                      shadowColor:
                          _pages[_currentPage].gradient[1].withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isLastPage
                          ? i18n.onboarding_get_started
                          : i18n.onboarding_next,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardingPageData page, AppLocalizations i18n) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: page.gradient,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // Icon container
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  page.icon,
                  size: 56,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 48),
              // Title
              Text(
                _titleForPage(page, i18n),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 20),
              // Description
              Text(
                _descForPage(page, i18n),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }

  String _titleForPage(_OnboardingPageData page, AppLocalizations i18n) {
    switch (page.titleKey) {
      case 'onboarding_feature1_title':
        return i18n.onboarding_feature1_title;
      case 'onboarding_feature2_title':
        return i18n.onboarding_feature2_title;
      case 'onboarding_feature3_title':
        return i18n.onboarding_feature3_title;
      default:
        return '';
    }
  }

  String _descForPage(_OnboardingPageData page, AppLocalizations i18n) {
    switch (page.descKey) {
      case 'onboarding_feature1_desc':
        return i18n.onboarding_feature1_desc;
      case 'onboarding_feature2_desc':
        return i18n.onboarding_feature2_desc;
      case 'onboarding_feature3_desc':
        return i18n.onboarding_feature3_desc;
      default:
        return '';
    }
  }
}

class _OnboardingPageData {
  final IconData icon;
  final List<Color> gradient;
  final String titleKey;
  final String descKey;

  const _OnboardingPageData({
    required this.icon,
    required this.gradient,
    required this.titleKey,
    required this.descKey,
  });
}
