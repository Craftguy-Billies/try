import '../models/verb.dart';

const List<GrammarLesson> grammarLessons = [
  GrammarLesson(
    id: 'g1', title: 'Gender of Nouns', category: 'Basics',
    content: 'Every French noun is either masculine (le/un) or feminine (la/une). There are some patterns to help you guess:\n\n'
        '• Words ending in -tion, -sion, -té, -ée, -ette, -ence, -ance are usually feminine\n'
        '• Words ending in -age, -ment, -eau, -isme, -oir are usually masculine\n'
        '• Days of the week, months, languages, and trees are masculine\n'
        '• Sciences, car brands, and most -eur words are feminine\n\n'
        'The best way to learn is to always memorize the article with each new noun.',
    examples: ['le livre (m) — the book', 'la table (f) — the table', 'une idée (f) — an idea', 'un garçon (m) — a boy'],
    tip: 'When in doubt, check a dictionary! Look for "n.m." (nom masculin) or "n.f." (nom féminin).',
  ),
  GrammarLesson(
    id: 'g2', title: 'Articles: Definite & Indefinite', category: 'Basics',
    content: 'French articles change based on gender, number, and the first letter of the word:\n\n'
        '**Definite articles (the):**\n'
        '• le — masculine singular (le livre)\n'
        '• la — feminine singular (la table)\n'
        '• l\' — before vowels (l\'ami, l\'école)\n'
        '• les — plural for both genders (les livres, les tables)\n\n'
        '**Indefinite articles (a/an/some):**\n'
        '• un — masculine singular (un livre)\n'
        '• une — feminine singular (une table)\n'
        '• des — plural for both genders (des livres, des tables)',
    examples: ['le chat — the cat', 'la maison — the house', 'l\'orange — the orange', 'un chien — a dog', 'une fleur — a flower'],
    tip: 'L\' is used before ALL vowel sounds, including silent h: l\'homme, l\'hôtel.',
  ),
  GrammarLesson(
    id: 'g3', title: 'Present Tense (Le Présent)', category: 'Verbs',
    content: 'The present tense is used for actions happening now, habits, and general truths.\n\n'
        '**Regular -ER verbs (parler = to speak):**\n'
        'je parle • tu parles • il/elle parle • nous parlons • vous parlez • ils/elles parlent\n\n'
        '**Regular -IR verbs (finir = to finish):**\n'
        'je finis • tu finis • il/elle finit • nous finissons • vous finissez • ils/elles finissent\n\n'
        '**Regular -RE verbs (vendre = to sell):**\n'
        'je vends • tu vends • il/elle vend • nous vendons • vous vendez • ils/elles vendent\n\n'
        'The present tense can express: je parle = I speak / I am speaking / I do speak.',
    examples: ['Je parle français. — I speak French.', 'Nous finissons le travail. — We finish the work.', 'Ils vendent des livres. — They sell books.'],
    tip: 'The "-ent" ending on ils/elles is silent! "Ils parlent" sounds just like "il parle."',
  ),
  GrammarLesson(
    id: 'g4', title: 'Passé Composé', category: 'Verbs',
    content: 'The passé composé is the most common past tense in spoken French. It expresses completed actions.\n\n'
        '**Formation:** auxiliary verb (avoir or être) + past participle\n\n'
        '**With AVOIR (most verbs):**\n'
        'j\'ai mangé — I ate / I have eaten\n'
        'tu as fini — you finished\n'
        'il a vendu — he sold\n\n'
        '**With ÊTRE (17 verbs including motion verbs):**\n'
        'je suis allé(e) — I went\n'
        'elle est venue — she came\n'
        'ils sont partis — they left\n\n'
        '**DR. MRS. VANDERTRAMP** mnemonic: Devenir, Revenir, Monter, Rester, Sortir, Venir, Aller, Naître, Descendre, Entrer, Rentrer, Tomber, Retourner, Arriver, Mourir, Partir, Passer',
    examples: ['J\'ai mangé une pomme. — I ate an apple.', 'Elle est allée au cinéma. — She went to the cinema.', 'Nous avons fini nos devoirs. — We finished our homework.'],
    tip: 'With être, the participle agrees with the subject: elle est allée (extra e), ils sont allés (extra s), elles sont allées (e + s).',
  ),
  GrammarLesson(
    id: 'g5', title: 'Imparfait vs. Passé Composé', category: 'Verbs',
    content: 'These two past tenses serve different purposes:\n\n'
        '**Imparfait — for background, habits, descriptions:**\n'
        '• Ongoing/habitual past actions\n'
        '• Descriptions (time, weather, feelings)\n'
        '• Setting the scene\n'
        '• "Was doing" / "used to do"\n\n'
        '**Passé Composé — for main events, completed actions:**\n'
        '• Specific, one-time actions\n'
        '• A sequence of events in a story\n'
        '• Actions with a clear beginning/end\n\n'
        '**Imparfait formation:** nous form stem + -ais, -ais, -ait, -ions, -iez, -aient',
    examples: [
      'Il pleuvait (imparfait) quand je suis sorti (PC). — It was raining when I went out.',
      'Je lisais (imparfait) quand le téléphone a sonné (PC). — I was reading when the phone rang.',
      'Quand j\'étais jeune (imparfait), j\'habitais à Paris (imparfait). — When I was young, I lived in Paris.',
    ],
    tip: 'Think of imparfait as a video (ongoing) and passé composé as a photo (snapshot).',
  ),
  GrammarLesson(
    id: 'g6', title: 'Futur Simple', category: 'Verbs',
    content: 'The futur simple expresses what will happen. It\'s equivalent to "will + verb" in English.\n\n'
        '**Formation:** infinitive + -ai, -as, -a, -ons, -ez, -ont\n'
        '• For -RE verbs, drop the final e: vendre → je vendrai\n'
        '• Many irregular verbs have irregular stems but regular endings\n\n'
        '**Common irregular stems:**\n'
        'être → ser- | avoir → aur- | aller → ir- | faire → fer-\n'
        'pouvoir → pourr- | vouloir → voudr- | voir → verr-\n'
        'venir → viendr- | savoir → saur- | devoir → devr-',
    examples: ['Je parlerai — I will speak', 'Nous serons — We will be', 'Ils auront — They will have', 'Tu pourras — You will be able to'],
    tip: 'Don\'t confuse with "futur proche" (aller + infinitive): Je vais parler = I\'m going to speak.',
  ),
  GrammarLesson(
    id: 'g7', title: 'Adjective Agreement', category: 'Basics',
    content: 'In French, adjectives must agree in gender and number with the noun they describe:\n\n'
        '**Adding feminine:**\n'
        '• Most adjectives add -e: grand → grande, petit → petite\n'
        '• -e endings stay the same: jeune → jeune\n'
        '• -x becomes -se: heureux → heureuse\n'
        '• -f becomes -ve: actif → active\n'
        '• -er becomes -ère: premier → première\n\n'
        '**Irregular feminine forms:**\n'
        'beau → belle | nouveau → nouvelle | vieux → vieille\n'
        'blanc → blanche | long → longue | bon → bonne\n\n'
        '**Adding plural:**\n'
        '• Most add -s: grands, grandes\n'
        '• -s/-x endings stay: gris, heureux\n'
        '• -al becomes -aux: national → nationaux',
    examples: ['un grand homme / une grande femme', 'un livre intéressant / une histoire intéressante', 'des enfants heureux / des filles heureuses'],
    tip: 'Most adjectives come AFTER the noun in French: "une voiture rouge" not "une rouge voiture." BANGS adjectives (Beauty, Age, Number, Goodness, Size) come before.',
  ),
  GrammarLesson(
    id: 'g8', title: 'Partitive Articles', category: 'Basics',
    content: 'Partitive articles express "some" or an unspecified quantity:\n\n'
        '• du — masculine: Je veux du pain (I want some bread)\n'
        '• de la — feminine: Je bois de la bière (I drink some beer)\n'
        '• de l\' — before vowels: Je prends de l\'eau (I\'ll have some water)\n'
        '• des — plural: Je mange des frites (I eat some fries)\n\n'
        '**After negation, use de/d\':**\n'
        'Je veux du fromage → Je ne veux pas de fromage\n'
        'Il a de la chance → Il n\'a pas de chance\n\n'
        '**After expressions of quantity, use de:**\n'
        'beaucoup de, un peu de, trop de, assez de, un kilo de',
    examples: ['Je mange du pain. — I eat bread.', 'Elle boit de l\'eau. — She drinks water.', 'Je ne veux pas de sucre. — I don\'t want any sugar.'],
    tip: 'Think of the partitive as meaning "part of" — you\'re taking part of the bread, not all bread in existence!',
  ),
  GrammarLesson(
    id: 'g9', title: 'Negation', category: 'Basics',
    content: 'The basic French negation is ne...pas around the conjugated verb:\n\n'
        'je parle → je ne parle pas (I don\'t speak)\n'
        'il est → il n\'est pas (he isn\'t)\n\n'
        '**Other negation structures:**\n'
        '• ne...plus — no longer: Je ne fume plus (I don\'t smoke anymore)\n'
        '• ne...jamais — never: Je ne mens jamais (I never lie)\n'
        '• ne...rien — nothing: Je ne comprends rien (I understand nothing)\n'
        '• ne...personne — nobody: Je ne vois personne (I see nobody)\n'
        '• ne...que — only: Je n\'ai que 5 euros (I only have 5 euros)\n\n'
        'In spoken French, "ne" is often dropped: Je sais pas = Je ne sais pas.',
    examples: ['Je ne parle pas anglais. — I don\'t speak English.', 'Il ne mange plus de viande. — He no longer eats meat.', 'Je n\'ai rien compris. — I understood nothing.'],
    tip: 'With compound tenses, the second part goes after the auxiliary: Je n\'ai pas mangé (I didn\'t eat).',
  ),
  GrammarLesson(
    id: 'g10', title: 'Questions', category: 'Basics',
    content: 'There are 3 ways to ask questions in French, from formal to informal:\n\n'
        '**1. Inversion (formal):**\n'
        'Parlez-vous français? — Do you speak French?\n'
        'Avez-vous mangé? — Have you eaten?\n\n'
        '**2. Est-ce que (standard):**\n'
        'Est-ce que vous parlez français?\n'
        'Est-ce qu\'il est là?\n\n'
        '**3. Intonation (informal):**\n'
        'Vous parlez français? (just raise your voice at the end)\n'
        'Il est là?\n\n'
        '**Question words:**\n'
        'Qui? — Who? | Quoi/Que? — What? | Où? — Where?\n'
        'Quand? — When? | Pourquoi? — Why? | Comment? — How?\n'
        'Combien? — How much/many?',
    examples: ['Où habitez-vous? — Where do you live?', 'Qu\'est-ce que tu fais? — What are you doing?', 'Pourquoi est-ce qu\'il est en retard? — Why is he late?'],
    tip: '"Qu\'est-ce que" literally means "What is it that..." — it\'s a very common way to ask "what" questions!',
  ),
];
