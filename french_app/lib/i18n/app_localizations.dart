import 'package:flutter/material.dart';
import 'translations.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Map of supported locale labels
  static const Map<String, String> localizedLabels = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'zh': '中文',
    'ja': '日本語',
    'ko': '한국어',
    'pt': 'Português',
    'ar': 'العربية',
    'hi': 'हिन्दी',
    'it': 'Italiano',
    'ru': 'Русский',
  };

  String get localeName => localizedLabels[locale.languageCode] ?? locale.languageCode;

  // ─── Translation lookup ───

  String _t(String key) {
    return translations[locale.languageCode]?[key] ??
        translations['en']?[key] ??
        key;
  }

  // ─── App ───

  String get appTitle => _t('app_title');
  String get appTagline => 'Master French with DELF exam preparation';

  // ─── Onboarding ───

  String get onboarding_welcome => _t('onboarding_welcome');
  String get onboarding_subtitle => _t('onboarding_subtitle');
  String get onboarding_feature1_title => _t('onboarding_feature1_title');
  String get onboarding_feature1_desc => _t('onboarding_feature1_desc');
  String get onboarding_feature2_title => _t('onboarding_feature2_title');
  String get onboarding_feature2_desc => _t('onboarding_feature2_desc');
  String get onboarding_feature3_title => _t('onboarding_feature3_title');
  String get onboarding_feature3_desc => _t('onboarding_feature3_desc');
  String get onboarding_get_started => _t('onboarding_get_started');
  String get onboarding_skip => _t('onboarding_skip');
  String get onboarding_next => _t('onboarding_next');
  String get onboarding_done => _t('onboarding_done');

  // ─── Navigation ───

  String get nav_home => _t('nav_home');
  String get nav_learn => _t('nav_learn');
  String get nav_exam => _t('nav_exam');
  String get nav_profile => _t('nav_profile');
  String get nav_settings => _t('nav_settings');

  // ─── Home ───

  String get home_greeting => _t('home_greeting');
  String get home_streak => _t('home_streak');
  String get home_words_learned => _t('home_words_learned');
  String get home_continue_learning => _t('home_continue_learning');
  String get home_start_exam => _t('home_start_exam');
  String get home_daily_goal => _t('home_daily_goal');
  String get home_words_today => _t('home_words_today');
  String get home_review_due => _t('home_review_due');
  String get home_words_to_review => _t('home_words_to_review');
  String get home_flashcards => _t('home_flashcards');
  String get home_flashcards_subtitle => _t('home_flashcards_subtitle');
  String get home_categories => _t('home_categories');
  String get home_categories_subtitle => _t('home_categories_subtitle');

  // ─── Learn ───

  String get learn => _t('nav_learn');
  String get exam => _t('nav_exam');
  String get profile => _t('nav_profile');
  String get settings => _t('nav_settings');

  String get vocabulary => _t('learn_vocabulary');
  String get grammar => _t('learn_grammar');
  String get comprehensive => _t('exam_comprehensive');

  String get learnTitle => _t('learn_title');
  String get learnSelectLevel => _t('learn_select_level');
  String get learnSelectCategory => _t('learn_select_category');
  String get learnFlashcards => _t('learn_flashcards');
  String get learnQuiz => _t('learn_quiz');
  String get learnListening => _t('learn_listening');
  String get learnWriting => _t('learn_writing');
  String get learnAllCategories => _t('learn_all_categories');
  String get learnSearch => _t('learn_search');

  String get levelA1 => _t('level_a1');
  String get levelA2 => _t('level_a2');
  String get levelB1 => _t('level_b1');
  String get levelB2 => _t('level_b2');
  String get levelAll => _t('level_all');

  // ─── Categories ───

  String get catGreetings => _t('cat_greetings');
  String get catFamily => _t('cat_family');
  String get catFood => _t('cat_food');
  String get catClothing => _t('cat_clothing');
  String get catHome => _t('cat_home');
  String get catCity => _t('cat_city');
  String get catWork => _t('cat_work');
  String get catNumbers => _t('cat_numbers');
  String get catNature => _t('cat_nature');
  String get catSports => _t('cat_sports');
  String get catColors => _t('cat_colors');
  String get catBody => _t('cat_body');
  String get catWeather => _t('cat_weather');
  String get catMedia => _t('cat_media');
  String get catTravel => _t('cat_travel');

  // ─── Flashcards ───

  String get flashcardTapToFlip => _t('flashcard_tap_to_flip');
  String get flashcardKnown => _t('flashcard_known');
  String get flashcardStillLearning => _t('flashcard_still_learning');
  String flashcardProgress(int current, int total) =>
      _t('flashcard_progress').replaceAll('{current}', '$current').replaceAll('{total}', '$total');
  String get flashcardComplete => _t('flashcard_complete');
  String flashcardScore(int known, int total) =>
      _t('flashcard_score').replaceAll('{known}', '$known').replaceAll('{total}', '$total');
  String get flashcardRestart => _t('flashcard_restart');
  String get flashcardBackToList => _t('flashcard_back_to_list');

  // ─── General ───

  String get search => _t('search');
  String get noData => _t('no_data');
  String get back => _t('back');
  String get loading => _t('loading');
  String get error => _t('error');
  String get retry => _t('retry');
  String get done => _t('done');
  String get save => _t('save');
  String get delete => _t('delete');
  String get yes => _t('yes');
  String get no => _t('no');
  String get cancel => _t('cancel');
  String get confirm => _t('confirm');

  /// Public accessor for dynamic key lookups (e.g. category names).
  String translate(String key) => _t(key);

  String get wordsLearned => _t('home_words_learned');
  String get streak => _t('home_streak');
  String get examResults => _t('exam_results');

  String get congratulations => _t('exam_passed');
  String get keepGoing => 'Keep going!';
  String get tryAgain => _t('exam_try_again');
  String get passed => _t('exam_passed');
  String get failed => _t('exam_failed');

  // ─── Profile ───

  String get profileTitle => _t('profile_title');
  String get profileName => _t('profile_name');
  String get profileNameHint => _t('profile_name_hint');
  String get profileEmail => _t('profile_email');
  String get profileLearningGoal => _t('profile_learning_goal');
  String get profileGoalDaily => _t('profile_goal_daily');
  String get profileGoalExam => _t('profile_goal_exam');
  String get profileGoalTravel => _t('profile_goal_travel');
  String get profileGoalWork => _t('profile_goal_work');
  String get profileGoalCasual => _t('profile_goal_casual');
  String get profileStats => _t('profile_stats');
  String get profileTotalLearned => _t('profile_total_learned');
  String get profileTotalReviewed => _t('profile_total_reviewed');
  String get profileCurrentStreak => _t('profile_current_streak');
  String get profileLongestStreak => _t('profile_longest_streak');
  String get profileOverallProgress => _t('profile_overall_progress');
  String get profileSave => _t('profile_save');
  String get profileSaved => _t('profile_saved');
  String get profileLevelProgress => _t('profile_level_progress');
  String get profileCategoryProgress => _t('profile_category_progress');
  String get profileWords => _t('profile_words');
  String get profileAppearance => _t('profile_appearance');
  String get profileLanguage => _t('profile_language');
  String get profileLearning => _t('profile_learning');
  String get profileData => _t('profile_data');
  String get profileAbout => _t('profile_about');

  // ─── Settings ───

  String get settingsTitle => _t('settings_title');
  String get settingsLanguage => _t('settings_language');
  String get settingsLanguageDesc => _t('settings_language_desc');
  String get settingsTheme => _t('settings_theme');
  String get settingsThemeLight => _t('settings_theme_light');
  String get settingsThemeDark => _t('settings_theme_dark');
  String get settingsThemeSystem => _t('settings_theme_system');
  String get settingsNotifications => _t('settings_notifications');
  String get settingsDailyReminder => _t('settings_daily_reminder');
  String get settingsSoundEffects => _t('settings_sound_effects');
  String get settingsResetProgress => _t('settings_reset_progress');
  String get settingsResetConfirm => _t('settings_reset_confirm');
  String get settingsAbout => _t('settings_about');
  String get settingsVersion => _t('settings_version');
  String get settingsResetTitle => _t('settings_reset_title');
  String get settingsResetMessage => _t('settings_reset_message');
  String get settingsAboutApp => _t('settings_about_app');
  String get settingsCredits => _t('settings_credits');

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.localizedLabels.containsKey(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
