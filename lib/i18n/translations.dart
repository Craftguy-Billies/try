import 'package:flutter/material.dart';

class AppLanguage {
  final String code;
  final String name;
  final String nativeName;
  final Locale locale;
  final String flag;

  const AppLanguage({
    required this.code, required this.name, required this.nativeName,
    required this.locale, required this.flag,
  });

  static const List<AppLanguage> supported = [
    AppLanguage(code: 'en', name: 'English', nativeName: 'English', locale: Locale('en'), flag: '🇬🇧'),
    AppLanguage(code: 'fr', name: 'French', nativeName: 'Français', locale: Locale('fr'), flag: '🇫🇷'),
    AppLanguage(code: 'es', name: 'Spanish', nativeName: 'Español', locale: Locale('es'), flag: '🇪🇸'),
    AppLanguage(code: 'de', name: 'German', nativeName: 'Deutsch', locale: Locale('de'), flag: '🇩🇪'),
    AppLanguage(code: 'zh', name: 'Chinese', nativeName: '中文', locale: Locale('zh'), flag: '🇨🇳'),
    AppLanguage(code: 'ja', name: 'Japanese', nativeName: '日本語', locale: Locale('ja'), flag: '🇯🇵'),
    AppLanguage(code: 'ko', name: 'Korean', nativeName: '한국어', locale: Locale('ko'), flag: '🇰🇷'),
    AppLanguage(code: 'pt', name: 'Portuguese', nativeName: 'Português', locale: Locale('pt'), flag: '🇧🇷'),
    AppLanguage(code: 'ar', name: 'Arabic', nativeName: 'العربية', locale: Locale('ar'), flag: '🇸🇦'),
    AppLanguage(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', locale: Locale('hi'), flag: '🇮🇳'),
  ];

  static AppLanguage fromCode(String code) {
    return supported.firstWhere((l) => l.code == code, orElse: () => supported.first);
  }
}

class Translations {
  final String code;
  const Translations(this.code);

  String get(String key) => _data[key]?[code] ?? _data[key]?['en'] ?? key;

  static const Map<String, Map<String, String>> _data = {
    'app_name': {'en': 'Learn French', 'fr': 'Apprendre le Français', 'es': 'Aprender Francés', 'de': 'Französisch lernen', 'zh': '学习法语', 'ja': 'フランス語を学ぶ', 'ko': '프랑스어 배우기', 'pt': 'Aprender Francês', 'ar': 'تعلم الفرنسية', 'hi': 'फ्रेंच सीखें'},
    'app_tagline': {'en': 'Your journey to French fluency', 'fr': 'Votre voyage vers la maîtrise du français', 'es': 'Tu viaje hacia la fluidez en francés', 'de': 'Ihre Reise zur Französisch-Kompetenz', 'zh': '您的法语流利之旅', 'ja': 'フランス語習得への旅', 'ko': '프랑스어 유창성을 향한 여정', 'pt': 'Sua jornada para a fluência em francês', 'ar': 'رحلتك إلى إتقان اللغة الفرنسية', 'hi': 'फ्रेंच प्रवाह की आपकी यात्रा'},
    'get_started': {'en': 'Get Started', 'fr': 'Commencer', 'es': 'Comenzar', 'de': 'Loslegen', 'zh': '开始', 'ja': '始める', 'ko': '시작하기', 'pt': 'Começar', 'ar': 'ابدأ', 'hi': 'शुरू करें'},
    'next': {'en': 'Next', 'fr': 'Suivant', 'es': 'Siguiente', 'de': 'Weiter', 'zh': '下一步', 'ja': '次へ', 'ko': '다음', 'pt': 'Próximo', 'ar': 'التالي', 'hi': 'अगला'},
    'skip': {'en': 'Skip', 'fr': 'Passer', 'es': 'Saltar', 'de': 'Überspringen', 'zh': '跳过', 'ja': 'スキップ', 'ko': '건너뛰기', 'pt': 'Pular', 'ar': 'تخطي', 'hi': 'छोड़ें'},
    'home': {'en': 'Home', 'fr': 'Accueil', 'es': 'Inicio', 'de': 'Start', 'zh': '首页', 'ja': 'ホーム', 'ko': '홈', 'pt': 'Início', 'ar': 'الرئيسية', 'hi': 'होम'},
    'vocabulary': {'en': 'Vocabulary', 'fr': 'Vocabulaire', 'es': 'Vocabulario', 'de': 'Wortschatz', 'zh': '词汇', 'ja': '語彙', 'ko': '어휘', 'pt': 'Vocabulário', 'ar': 'المفردات', 'hi': 'शब्दावली'},
    'exam': {'en': 'Exam Prep', 'fr': 'Préparation Examen', 'es': 'Preparación Examen', 'de': 'Prüfungsvorbereitung', 'zh': '考试准备', 'ja': '試験対策', 'ko': '시험 준비', 'pt': 'Preparação para Exame', 'ar': 'التحضير للامتحان', 'hi': 'परीक्षा की तैयारी'},
    'grammar': {'en': 'Grammar', 'fr': 'Grammaire', 'es': 'Gramática', 'de': 'Grammatik', 'zh': '语法', 'ja': '文法', 'ko': '문법', 'pt': 'Gramática', 'ar': 'القواعد', 'hi': 'व्याकरण'},
    'phrases': {'en': 'Phrases', 'fr': 'Expressions', 'es': 'Frases', 'de': 'Sätze', 'zh': '短语', 'ja': 'フレーズ', 'ko': '구문', 'pt': 'Frases', 'ar': 'العبارات', 'hi': 'वाक्यांश'},
    'profile': {'en': 'Profile', 'fr': 'Profil', 'es': 'Perfil', 'de': 'Profil', 'zh': '个人资料', 'ja': 'プロフィール', 'ko': '프로필', 'pt': 'Perfil', 'ar': 'الملف الشخصي', 'hi': 'प्रोफ़ाइल'},
    'settings': {'en': 'Settings', 'fr': 'Paramètres', 'es': 'Configuración', 'de': 'Einstellungen', 'zh': '设置', 'ja': '設定', 'ko': '설정', 'pt': 'Configurações', 'ar': 'الإعدادات', 'hi': 'सेटिंग्स'},
    'language': {'en': 'Language', 'fr': 'Langue', 'es': 'Idioma', 'de': 'Sprache', 'zh': '语言', 'ja': '言語', 'ko': '언어', 'pt': 'Idioma', 'ar': 'اللغة', 'hi': 'भाषा'},
    'dark_mode': {'en': 'Dark Mode', 'fr': 'Mode Sombre', 'es': 'Modo Oscuro', 'de': 'Dunkelmodus', 'zh': '深色模式', 'ja': 'ダークモード', 'ko': '다크 모드', 'pt': 'Modo Escuro', 'ar': 'الوضع الداكن', 'hi': 'डार्क मोड'},
    'notifications': {'en': 'Notifications', 'fr': 'Notifications', 'es': 'Notificaciones', 'de': 'Benachrichtigungen', 'zh': '通知', 'ja': '通知', 'ko': '알림', 'pt': 'Notificações', 'ar': 'الإشعارات', 'hi': 'सूचनाएं'},
    'about': {'en': 'About', 'fr': 'À propos', 'es': 'Acerca de', 'de': 'Über', 'zh': '关于', 'ja': 'について', 'ko': '정보', 'pt': 'Sobre', 'ar': 'حول', 'hi': 'के बारे में'},
    'logout': {'en': 'Logout', 'fr': 'Déconnexion', 'es': 'Cerrar sesión', 'de': 'Abmelden', 'zh': '登出', 'ja': 'ログアウト', 'ko': '로그아웃', 'pt': 'Sair', 'ar': 'تسجيل الخروج', 'hi': 'लॉग आउट'},
    'daily_goal': {'en': 'Daily Goal', 'fr': 'Objectif Quotidien', 'es': 'Meta Diaria', 'de': 'Tagesziel', 'zh': '每日目标', 'ja': '今日の目標', 'ko': '일일 목표', 'pt': 'Meta Diária', 'ar': 'الهدف اليومي', 'hi': 'दैनिक लक्ष्य'},
    'streak': {'en': 'Streak', 'fr': 'Série', 'es': 'Racha', 'de': 'Serie', 'zh': '连续天数', 'ja': '連続日数', 'ko': '연속 일수', 'pt': 'Sequência', 'ar': 'التتابع', 'hi': 'लगातार'},
    'words_learned': {'en': 'Words Learned', 'fr': 'Mots Appris', 'es': 'Palabras Aprendidas', 'de': 'Gelernte Wörter', 'zh': '已学单词', 'ja': '学習済み単語', 'ko': '학습한 단어', 'pt': 'Palavras Aprendidas', 'ar': 'الكلمات المتعلمة', 'hi': 'सीखे गए शब्द'},
    'minutes_practiced': {'en': 'Minutes Practiced', 'fr': 'Minutes Pratiquées', 'es': 'Minutos Practicados', 'de': 'Geübte Minuten', 'zh': '练习分钟', 'ja': '練習時間（分）', 'ko': '연습 시간(분)', 'pt': 'Minutos Praticados', 'ar': 'دقائق التدريب', 'hi': 'अभ्यास के मिनट'},
    'flashcards': {'en': 'Flashcards', 'fr': 'Cartes Mémoire', 'es': 'Tarjetas', 'de': 'Karteikarten', 'zh': '闪卡', 'ja': 'フラッシュカード', 'ko': '플래시카드', 'pt': 'Flashcards', 'ar': 'بطاقات تعليمية', 'hi': 'फ्लैशकार्ड'},
    'quiz': {'en': 'Quiz', 'fr': 'Quiz', 'es': 'Prueba', 'de': 'Quiz', 'zh': '测验', 'ja': 'クイズ', 'ko': '퀴즈', 'pt': 'Quiz', 'ar': 'اختبار', 'hi': 'प्रश्नोत्तरी'},
    'time_remaining': {'en': 'Time Remaining', 'fr': 'Temps Restant', 'es': 'Tiempo Restante', 'de': 'Verbleibende Zeit', 'zh': '剩余时间', 'ja': '残り時間', 'ko': '남은 시간', 'pt': 'Tempo Restante', 'ar': 'الوقت المتبقي', 'hi': 'शेष समय'},
    'exam_result': {'en': 'Exam Result', 'fr': 'Résultat d\'examen', 'es': 'Resultado del examen', 'de': 'Prüfungsergebnis', 'zh': '考试结果', 'ja': '試験結果', 'ko': '시험 결과', 'pt': 'Resultado do Exame', 'ar': 'نتيجة الامتحان', 'hi': 'परीक्षा परिणाम'},
    'passed': {'en': 'PASSED', 'fr': 'RÉUSSI', 'es': 'APROBADO', 'de': 'BESTANDEN', 'zh': '通过', 'ja': '合格', 'ko': '합격', 'pt': 'APROVADO', 'ar': 'ناجح', 'hi': 'उत्तीर्ण'},
    'failed': {'en': 'FAILED', 'fr': 'ÉCHOUÉ', 'es': 'REPROBADO', 'de': 'NICHT BESTANDEN', 'zh': '未通过', 'ja': '不合格', 'ko': '불합격', 'pt': 'REPROVADO', 'ar': 'راسب', 'hi': 'अनुत्तीर्ण'},
    'total_questions': {'en': 'Total Questions', 'fr': 'Questions Totales', 'es': 'Preguntas Totales', 'de': 'Fragen insgesamt', 'zh': '总题数', 'ja': '問題数', 'ko': '총 문제', 'pt': 'Total de Perguntas', 'ar': 'إجمالي الأسئلة', 'hi': 'कुल प्रश्न'},
    'beginner': {'en': 'Beginner', 'fr': 'Débutant', 'es': 'Principiante', 'de': 'Anfänger', 'zh': '初级', 'ja': '初級', 'ko': '초급', 'pt': 'Iniciante', 'ar': 'مبتدئ', 'hi': 'शुरुआती'},
    'intermediate': {'en': 'Intermediate', 'fr': 'Intermédiaire', 'es': 'Intermedio', 'de': 'Mittelstufe', 'zh': '中级', 'ja': '中級', 'ko': '중급', 'pt': 'Intermediário', 'ar': 'متوسط', 'hi': 'मध्यवर्ती'},
    'advanced': {'en': 'Advanced', 'fr': 'Avancé', 'es': 'Avanzado', 'de': 'Fortgeschritten', 'zh': '高级', 'ja': '上級', 'ko': '고급', 'pt': 'Avançado', 'ar': 'متقدم', 'hi': 'उन्नत'},
    'practice': {'en': 'Practice', 'fr': 'Pratiquer', 'es': 'Practicar', 'de': 'Üben', 'zh': '练习', 'ja': '練習', 'ko': '연습', 'pt': 'Praticar', 'ar': 'تدرب', 'hi': 'अभ्यास'},
    'learn': {'en': 'Learn', 'fr': 'Apprendre', 'es': 'Aprender', 'de': 'Lernen', 'zh': '学习', 'ja': '学ぶ', 'ko': '배우기', 'pt': 'Aprender', 'ar': 'تعلم', 'hi': 'सीखें'},
    'review': {'en': 'Review', 'fr': 'Réviser', 'es': 'Repasar', 'de': 'Wiederholen', 'zh': '复习', 'ja': '復習', 'ko': '복습', 'pt': 'Revisar', 'ar': 'مراجعة', 'hi': 'पुनरावलोकन'},
    'completed': {'en': 'Completed', 'fr': 'Terminé', 'es': 'Completado', 'de': 'Abgeschlossen', 'zh': '已完成', 'ja': '完了', 'ko': '완료', 'pt': 'Concluído', 'ar': 'مكتمل', 'hi': 'पूर्ण'},
    'progress': {'en': 'Progress', 'fr': 'Progrès', 'es': 'Progreso', 'de': 'Fortschritt', 'zh': '进度', 'ja': '進捗', 'ko': '진행률', 'pt': 'Progresso', 'ar': 'التقدم', 'hi': 'प्रगति'},
    'score': {'en': 'Score', 'fr': 'Score', 'es': 'Puntuación', 'de': 'Punktzahl', 'zh': '分数', 'ja': 'スコア', 'ko': '점수', 'pt': 'Pontuação', 'ar': 'النتيجة', 'hi': 'स्कोर'},
    'correct': {'en': 'Correct', 'fr': 'Correct', 'es': 'Correcto', 'de': 'Richtig', 'zh': '正确', 'ja': '正解', 'ko': '정답', 'pt': 'Correto', 'ar': 'صحيح', 'hi': 'सही'},
    'incorrect': {'en': 'Incorrect', 'fr': 'Incorrect', 'es': 'Incorrecto', 'de': 'Falsch', 'zh': '错误', 'ja': '不正解', 'ko': '오답', 'pt': 'Incorreto', 'ar': 'غير صحيح', 'hi': 'गलत'},
    'try_again': {'en': 'Try Again', 'fr': 'Réessayer', 'es': 'Intentar de nuevo', 'de': 'Erneut versuchen', 'zh': '再试一次', 'ja': 'もう一度', 'ko': '다시 시도', 'pt': 'Tentar novamente', 'ar': 'حاول مرة أخرى', 'hi': 'पुनः प्रयास करें'},
    'search': {'en': 'Search...', 'fr': 'Rechercher...', 'es': 'Buscar...', 'de': 'Suchen...', 'zh': '搜索...', 'ja': '検索...', 'ko': '검색...', 'pt': 'Pesquisar...', 'ar': 'بحث...', 'hi': 'खोजें...'},
    'categories': {'en': 'Categories', 'fr': 'Catégories', 'es': 'Categorías', 'de': 'Kategorien', 'zh': '分类', 'ja': 'カテゴリ', 'ko': '카테고리', 'pt': 'Categorias', 'ar': 'الفئات', 'hi': 'श्रेणियाँ'},
    'difficulty': {'en': 'Difficulty', 'fr': 'Difficulté', 'es': 'Dificultad', 'de': 'Schwierigkeit', 'zh': '难度', 'ja': '難易度', 'ko': '난이도', 'pt': 'Dificuldade', 'ar': 'الصعوبة', 'hi': 'कठिनाई'},
    'all': {'en': 'All', 'fr': 'Tout', 'es': 'Todo', 'de': 'Alle', 'zh': '全部', 'ja': 'すべて', 'ko': '전체', 'pt': 'Todos', 'ar': 'الكل', 'hi': 'सभी'},
    'save': {'en': 'Save', 'fr': 'Enregistrer', 'es': 'Guardar', 'de': 'Speichern', 'zh': '保存', 'ja': '保存', 'ko': '저장', 'pt': 'Salvar', 'ar': 'حفظ', 'hi': 'सहेजें'},
    'cancel': {'en': 'Cancel', 'fr': 'Annuler', 'es': 'Cancelar', 'de': 'Abbrechen', 'zh': '取消', 'ja': 'キャンセル', 'ko': '취소', 'pt': 'Cancelar', 'ar': 'إلغاء', 'hi': 'रद्द करें'},
    'confirm': {'en': 'Confirm', 'fr': 'Confirmer', 'es': 'Confirmar', 'de': 'Bestätigen', 'zh': '确认', 'ja': '確認', 'ko': '확인', 'pt': 'Confirmar', 'ar': 'تأكيد', 'hi': 'पुष्टि करें'},
    'loading': {'en': 'Loading...', 'fr': 'Chargement...', 'es': 'Cargando...', 'de': 'Laden...', 'zh': '加载中...', 'ja': '読み込み中...', 'ko': '로딩 중...', 'pt': 'Carregando...', 'ar': 'جاري التحميل...', 'hi': 'लोड हो रहा है...'},
    'error_occurred': {'en': 'An error occurred', 'fr': 'Une erreur est survenue', 'es': 'Ocurrió un error', 'de': 'Ein Fehler ist aufgetreten', 'zh': '发生错误', 'ja': 'エラーが発生しました', 'ko': '오류가 발생했습니다', 'pt': 'Ocorreu um erro', 'ar': 'حدث خطأ', 'hi': 'एक त्रुटि हुई'},
    'no_data': {'en': 'No data available', 'fr': 'Aucune donnée disponible', 'es': 'No hay datos disponibles', 'de': 'Keine Daten verfügbar', 'zh': '无可用数据', 'ja': 'データがありません', 'ko': '데이터 없음', 'pt': 'Sem dados disponíveis', 'ar': 'لا توجد بيانات', 'hi': 'कोई डेटा उपलब्ध नहीं'},
    'retry': {'en': 'Retry', 'fr': 'Réessayer', 'es': 'Reintentar', 'de': 'Wiederholen', 'zh': '重试', 'ja': '再試行', 'ko': '재시도', 'pt': 'Tentar novamente', 'ar': 'إعادة المحاولة', 'hi': 'पुनः प्रयास'},
    'level': {'en': 'Level', 'fr': 'Niveau', 'es': 'Nivel', 'de': 'Niveau', 'zh': '级别', 'ja': 'レベル', 'ko': '레벨', 'pt': 'Nível', 'ar': 'المستوى', 'hi': 'स्तर'},
    'delete': {'en': 'Delete', 'fr': 'Supprimer', 'es': 'Eliminar', 'de': 'Löschen', 'zh': '删除', 'ja': '削除', 'ko': '삭제', 'pt': 'Excluir', 'ar': 'حذف', 'hi': 'हटाएं'},
    'quick_actions': {'en': 'Quick Actions', 'fr': 'Actions Rapides', 'es': 'Acciones Rapidas', 'de': 'Schnellaktionen', 'zh': '快速操作', 'ja': 'クイック操作', 'ko': '빠른 작업', 'pt': 'Ações Rapidas', 'ar': 'إجراءات سريعة', 'hi': 'त्वरित कार्रवाइयां'},
    'onboarding_title_1': {'en': 'Welcome to Learn French!', 'fr': 'Bienvenue à Apprendre le Français!', 'es': '¡Bienvenido a Aprender Francés!', 'de': 'Willkommen bei Französisch lernen!', 'zh': '欢迎来到学习法语！', 'ja': 'フランス語学習へようこそ！', 'ko': '프랑스어 배우기에 오신 것을 환영합니다!', 'pt': 'Bem-vindo ao Aprender Francês!', 'ar': 'مرحباً بك في تعلم الفرنسية!', 'hi': 'फ्रेंच सीखें में आपका स्वागत है!'},
    'onboarding_desc_1': {'en': 'Master French with our comprehensive learning platform. From beginner to advanced, we have everything you need to become fluent.', 'fr': 'Maîtrisez le français avec notre plateforme complète. Du débutant à l\'avancé, nous avons tout ce dont vous avez besoin pour devenir fluent.', 'es': 'Domina el francés con nuestra plataforma integral. Desde principiante hasta avanzado, tenemos todo lo que necesitas.', 'de': 'Meistern Sie Französisch mit unserer umfassenden Lernplattform. Vom Anfänger bis zum Fortgeschrittenen.', 'zh': '通过我们的综合学习平台掌握法语。从初级到高级，我们拥有您流利所需的一切。', 'ja': '総合的な学習プラットフォームでフランス語をマスターしましょう。初級から上級まで。', 'ko': '포괄적인 학습 플랫폼으로 프랑스어를 마스터하세요. 초급부터 고급까지.', 'pt': 'Domine o francês com nossa plataforma abrangente. Do iniciante ao avançado.', 'ar': 'أتقن الفرنسية مع منصتنا الشاملة. من المبتدئ إلى المتقدم.', 'hi': 'हमारे व्यापक लर्निंग प्लेटफॉर्म के साथ फ्रेंच में महारत हासिल करें।'},
    'onboarding_title_2': {'en': 'Comprehensive Vocabulary', 'fr': 'Vocabulaire Complet', 'es': 'Vocabulario Completo', 'de': 'Umfassender Wortschatz', 'zh': '全面的词汇', 'ja': '包括的な語彙', 'ko': '포괄적인 어휘', 'pt': 'Vocabulário Abrangente', 'ar': 'مفردات شاملة', 'hi': 'व्यापक शब्दावली'},
    'onboarding_desc_2': {'en': 'Learn 500+ carefully curated French words across 10 categories. Each word includes pronunciation, examples, and difficulty levels aligned with DELF standards.', 'fr': 'Apprenez plus de 500 mots français soigneusement sélectionnés dans 10 catégories. Chaque mot inclut la prononciation, des exemples et des niveaux de difficulté.', 'es': 'Aprende más de 500 palabras en francés cuidadosamente seleccionadas en 10 categorías.', 'de': 'Lernen Sie über 500 sorgfältig ausgewählte französische Wörter in 10 Kategorien.', 'zh': '学习500多个精选法语单词，涵盖10个类别。每个单词包含发音、例句和DELF标准难度等级。', 'ja': '10カテゴリにわたる500以上の厳選されたフランス語単語を学びます。', 'ko': '10개 카테고리에 걸쳐 500개 이상의 엄선된 프랑스어 단어를 학습하세요.', 'pt': 'Aprenda mais de 500 palavras em francês cuidadosamente selecionadas em 10 categorias.', 'ar': 'تعلم أكثر من 500 كلمة فرنسية مختارة بعناية عبر 10 فئات.', 'hi': '10 श्रेणियों में 500+ सावधानीपूर्वक चयनित फ्रेंच शब्द सीखें।'},
    'onboarding_title_3': {'en': 'DELF Exam Preparation', 'fr': 'Préparation DELF', 'es': 'Preparación DELF', 'de': 'DELF-Prüfungsvorbereitung', 'zh': 'DELF考试准备', 'ja': 'DELF試験対策', 'ko': 'DELF 시험 준비', 'pt': 'Preparação para DELF', 'ar': 'التحضير لامتحان DELF', 'hi': 'DELF परीक्षा की तैयारी'},
    'onboarding_desc_3': {'en': 'Practice with realistic exam simulations for A1, A2, B1, and B2 levels. Timed quizzes, multiple choice, and fill-in-the-blank exercises to prepare you for success.', 'fr': 'Entraînez-vous avec des simulations d\'examen réalistes pour les niveaux A1, A2, B1 et B2.', 'es': 'Practica con simulaciones de examen realistas para los niveles A1, A2, B1 y B2.', 'de': 'Üben Sie mit realistischen Prüfungssimulationen für die Niveaus A1, A2, B1 und B2.', 'zh': '通过A1、A2、B1和B2级别的真实考试模拟进行练习。', 'ja': 'A1、A2、B1、B2レベル向けのリアルな試験シミュレーションで練習。', 'ko': 'A1, A2, B1, B2 레벨의 실제 시험 시뮬레이션으로 연습하세요.', 'pt': 'Pratique com simulações realistas de exames para os níveis A1, A2, B1 e B2.', 'ar': 'تدرب مع محاكاة امتحانات واقعية للمستويات A1 و A2 و B1 و B2.', 'hi': 'A1, A2, B1 और B2 स्तरों के लिए यथार्थवादी परीक्षा सिमुलेशन के साथ अभ्यास करें।'},
    'onboarding_title_4': {'en': 'Track Your Progress', 'fr': 'Suivez Votre Progrès', 'es': 'Sigue Tu Progreso', 'de': 'Verfolgen Sie Ihren Fortschritt', 'zh': '追踪您的进度', 'ja': '進捗を追跡', 'ko': '진행 상황 추적', 'pt': 'Acompanhe Seu Progresso', 'ar': 'تتبع تقدمك', 'hi': 'अपनी प्रगति ट्रैक करें'},
    'onboarding_desc_4': {'en': 'Stay motivated with daily streaks, achievement badges, and detailed statistics. See your improvement over time and celebrate your milestones.', 'fr': 'Restez motivé avec des séries quotidiennes, des badges de réussite et des statistiques détaillées.', 'es': 'Mantente motivado con rachas diarias, insignias de logros y estadísticas detalladas.', 'de': 'Bleiben Sie motiviert mit täglichen Serien, Erfolgsabzeichen und detaillierten Statistiken.', 'zh': '通过每日连续学习、成就徽章和详细统计数据保持动力。', 'ja': '毎日の連続学習、達成バッジ、詳細な統計でモチベーションを維持。', 'ko': '일일 연속 학습, 성취 배지, 상세 통계로 동기부여를 유지하세요.', 'pt': 'Mantenha-se motivado com sequências diárias, distintivos de conquista e estatísticas detalhadas.', 'ar': 'حافظ على حماسك مع السلاسل اليومية وشارات الإنجاز والإحصائيات المفصلة.', 'hi': 'दैनिक स्ट्रीक, उपलब्धि बैज और विस्तृत आंकड़ों के साथ प्रेरित रहें।'},
    'page_not_found': {'en': 'Page Not Found', 'fr': 'Page Introuvable', 'es': 'Página No Encontrada', 'de': 'Seite Nicht Gefunden', 'zh': '页面未找到', 'ja': 'ページが見つかりません', 'ko': '페이지를 찾을 수 없습니다', 'pt': 'Página Não Encontrada', 'ar': 'الصفحة غير موجودة', 'hi': 'पृष्ठ नहीं मिला'},
    'page_not_found_desc': {'en': 'The page you\'re looking for doesn\'t exist or has been moved.', 'fr': 'La page que vous cherchez n\'existe pas ou a été déplacée.', 'es': 'La página que buscas no existe o ha sido movida.', 'de': 'Die gesuchte Seite existiert nicht oder wurde verschoben.', 'zh': '您要查找的页面不存在或已被移动。', 'ja': 'お探しのページは存在しないか、移動されました。', 'ko': '찾고 계신 페이지가 존재하지 않거나 이동되었습니다.', 'pt': 'A página que procura não existe ou foi movida.', 'ar': 'الصفحة التي تبحث عنها غير موجودة أو تم نقلها.', 'hi': 'आप जिस पृष्ठ की तलाश कर रहे हैं वह मौजूद नहीं है या स्थानांतरित कर दिया गया है।'},
    'go_home': {'en': 'Go Home', 'fr': 'Accueil', 'es': 'Ir al Inicio', 'de': 'Zur Startseite', 'zh': '返回首页', 'ja': 'ホームに戻る', 'ko': '홈으로 가기', 'pt': 'Ir para o Início', 'ar': 'الذهاب للرئيسية', 'hi': 'होम पर जाएं'},
  };
}
