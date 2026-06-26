
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../i18n/translations.dart';
import '../../services/audit_logger.dart';
import '../../services/storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _logger = AuditLogger();
  final _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;
  bool _isAnimating = false;
  bool _completing = false; // guard against double-complete
  int _rapidTapCount = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(icon: Icons.school, color: AppColors.primary, titleKey: 'onboarding_title_1', descKey: 'onboarding_desc_1'),
    _OnboardingPage(icon: Icons.menu_book, color: AppColors.accent, titleKey: 'onboarding_title_2', descKey: 'onboarding_desc_2'),
    _OnboardingPage(icon: Icons.quiz, color: AppColors.success, titleKey: 'onboarding_title_3', descKey: 'onboarding_desc_3'),
    _OnboardingPage(icon: Icons.trending_up, color: AppColors.frenchRed, titleKey: 'onboarding_title_4', descKey: 'onboarding_desc_4'),
  ];

  @override
  void initState() {
    super.initState();
    _logger.logInit('Onboarding', data: {'pages': _totalPages});
    _logger.logScreenView('Onboarding');
  }

  @override
  void dispose() {
    _logger.logDispose('Onboarding', data: {
      'last_page': _currentPage, 'completing': _completing,
      'rapidTapCount': _rapidTapCount,
    });
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int i) {
    if (i < 0 || i >= _totalPages) {
      _logger.logEdge('Onboarding', 'page-index-out-of-bounds', data: {
        'index': i, 'total': _totalPages,
      });
      return;
    }
    final old = _currentPage;
    _isAnimating = false;
    _rapidTapCount = 0;
    setState(() => _currentPage = i);
    _logger.logSwipe('Onboarding', from: old, to: i);
    _logger.logStateChangeInt('Onboarding', 'currentPage', old, i);
  }

  Future<void> _completeOnboarding(String reason) async {
    if (_completing) {
      _logger.logGuard('Onboarding', 'complete-already-in-progress', data: {'reason': reason});
      return;
    }
    _completing = true;
    _logger.logEdge('Onboarding', 'User $reason onboarding');
    try {
      await StorageService().setOnboardingCompleted();
      _logger.debug('Onboarding', 'setOnboardingCompleted succeeded');
    } catch (e, stack) {
      _logger.logAsyncFail('Onboarding', 'setOnboardingCompleted', e, stack);
      _logger.logRecover('Onboarding', 'onboarding flag save failed — navigating anyway');
    }
    if (!mounted) {
      _logger.logEdge('Onboarding', 'not-mounted-after-onboarding-complete');
      _completing = false;
      return;
    }
    _logger.logNavigate('Onboarding', '/home', method: 'pushReplacement');
    try {
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e, stack) {
      _logger.logAsyncFail('Onboarding', 'pushReplacementNamed-/home', e, stack);
      _logger.logRecover('Onboarding', 'navigation failed — widget may have been disposed');
    }
  }

  void _handleSkip() {
    if (_completing) {
      _logger.logGuard('Onboarding', 'skip-during-complete');
      return;
    }
    _logger.logButton('Onboarding', 'Skip', data: {'from_page': _currentPage});
    _completeOnboarding('skipped');
  }

  void _handleNextOrStart() {
    if (_completing) {
      _logger.logGuard('Onboarding', 'next-during-complete');
      return;
    }
    if (_isAnimating) {
      _rapidTapCount++;
      _logger.logGuard('Onboarding', 'rapid-tap-next-guarded', data: {
        'page': _currentPage, 'rapidTapCount': _rapidTapCount,
      });
      if (_rapidTapCount > 5) {
        _logger.warn('Onboarding', 'User rapidly tapping next repeatedly — possible UI frustration',
            data: {'count': _rapidTapCount});
      }
      return;
    }
    if (_currentPage < _totalPages - 1) {
      _logger.logButton('Onboarding', 'Next', data: {'page': _currentPage, 'to': _currentPage + 1});
      _isAnimating = true;
      try {
        _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      } catch (e, stack) {
        _logger.logAsyncFail('Onboarding', 'nextPage-controller-failed', e, stack,
            data: {'fromPage': _currentPage});
        _isAnimating = false;
        // Manual fallback
        if (mounted) {
          setState(() { _currentPage++; _isAnimating = false; });
        }
      }
    } else {
      _logger.logButton('Onboarding', 'Get Started', data: {'from_page': _currentPage});
      _completeOnboarding('completed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations(Localizations.localeOf(context).languageCode);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _logger.logBackPress('Onboarding', handled: false, data: {'page': _currentPage});
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(children: [
            Expanded(flex: 3, child: PageView.builder(
              controller: _pageController, itemCount: _totalPages,
              onPageChanged: _onPageChanged,
              itemBuilder: (ctx, i) => _buildPage(ctx, _pages[i]),
            )),
            _buildDots(),
            const SizedBox(height: 24),
            _buildButtons(t),
            const SizedBox(height: 40),
          ]),
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext ctx, _OnboardingPage page) {
    final t = Translations(Localizations.localeOf(ctx).languageCode);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 120, height: 120,
          decoration: BoxDecoration(shape: BoxShape.circle, color: page.color.withAlpha(25)),
          child: Icon(page.icon, size: 60, color: page.color)),
        const SizedBox(height: 40),
        Text(t.get(page.titleKey), textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        const SizedBox(height: 16),
        Text(t.get(page.descKey), textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.5)),
      ]),
    );
  }

  Widget _buildDots() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_totalPages, (i) {
      return AnimatedContainer(duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: _currentPage == i ? 28 : 8, height: 8,
        decoration: BoxDecoration(
          color: _currentPage == i ? AppColors.primary : AppColors.primary.withAlpha(60),
          borderRadius: BorderRadius.circular(4)));
    }));
  }

  Widget _buildButtons(Translations t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(children: [
        if (_currentPage < _totalPages - 1)
          TextButton(onPressed: _handleSkip,
            child: Text(t.get('skip'), style: TextStyle(color: AppColors.textSecondary)))
        else const Spacer(),
        const Spacer(),
        ElevatedButton(
          onPressed: _handleNextOrStart,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
          child: Text(_currentPage < _totalPages - 1 ? t.get('next') : t.get('get_started'),
            style: const TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ]),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final Color color;
  final String titleKey;
  final String descKey;
  const _OnboardingPage({required this.icon, required this.color, required this.titleKey, required this.descKey});
}
