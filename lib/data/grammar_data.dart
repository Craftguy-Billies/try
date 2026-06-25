
import '../models/grammar_lesson.dart';

class GrammarData {
  static final List<GrammarLesson> lessons = [
    GrammarLesson(
      id: 'g1', titleEn: 'Definite & Indefinite Articles', titleFr: 'Les Articles Définis et Indéfinis',
      descriptionEn: 'Learn when to use le, la, les, un, une, des', descriptionFr: 'Apprenez quand utiliser le, la, les, un, une, des',
      difficulty: 1,
      sections: [
        GrammarSection(headingEn: 'Definite Articles', headingFr: 'Articles Définis',
          contentEn: 'French has four definite articles: le (masculine singular), la (feminine singular), l\' (before vowels), les (plural). They all mean "the".',
          contentFr: 'Le français a quatre articles définis : le (masculin singulier), la (féminin singulier), l\' (devant les voyelles), les (pluriel).',
          examples: ['Le chat est noir. (The cat is black.)', 'La maison est grande. (The house is big.)', 'L\'arbre est vert. (The tree is green.)', 'Les enfants jouent. (The children play.)']),
        GrammarSection(headingEn: 'Indefinite Articles', headingFr: 'Articles Indéfinis',
          contentEn: 'French has three indefinite articles: un (masculine), une (feminine), des (plural). They mean "a/an" or "some".',
          contentFr: 'Le français a trois articles indéfinis : un (masculin), une (féminin), des (pluriel).',
          examples: ['Un livre (a book)', 'Une table (a table)', 'Des amis (some friends)']),
      ],
      exercises: [
        GrammarExercise(questionEn: '___ chat (the cat)', questionFr: '___ chat', correctAnswer: 'Le', options: ['Le', 'La', 'Les']),
        GrammarExercise(questionEn: '___ maison (the house)', questionFr: '___ maison', correctAnswer: 'La', options: ['Le', 'La', 'Les']),
        GrammarExercise(questionEn: '___ arbre (a tree)', questionFr: '___ arbre', correctAnswer: 'Un', options: ['Un', 'Une', 'Des']),
        GrammarExercise(questionEn: '___ amis (some friends)', questionFr: '___ amis', correctAnswer: 'Des', options: ['Un', 'Une', 'Des']),
      ],
    ),
    GrammarLesson(
      id: 'g2', titleEn: 'Present Tense - Regular Verbs', titleFr: 'Le Présent - Verbes Réguliers',
      descriptionEn: 'Master the three regular verb groups: -ER, -IR, -RE', descriptionFr: 'Maîtrisez les trois groupes de verbes réguliers : -ER, -IR, -RE',
      difficulty: 1,
      sections: [
        GrammarSection(headingEn: '-ER Verbs (First Group)', headingFr: 'Verbes en -ER (Premier Groupe)',
          contentEn: 'Most French verbs end in -ER. Conjugation: remove -er, add: -e, -es, -e, -ons, -ez, -ent. Example: parler (to speak) → je parle, tu parles, il/elle parle, nous parlons, vous parlez, ils/elles parlent.',
          contentFr: 'La plupart des verbes français se terminent en -ER. Conjugaison : enlevez -er, ajoutez : -e, -es, -e, -ons, -ez, -ent.',
          examples: ['Je parle français.', 'Tu parles anglais.', 'Nous parlons ensemble.', 'Ils parlent vite.']),
        GrammarSection(headingEn: '-IR Verbs (Second Group)', headingFr: 'Verbes en -IR (Deuxième Groupe)',
          contentEn: 'Regular -IR verbs: remove -ir, add: -is, -is, -it, -issons, -issez, -issent. Example: finir (to finish) → je finis, tu finis, il finit, nous finissons, vous finissez, ils finissent.',
          contentFr: 'Verbes réguliers en -IR : enlevez -ir, ajoutez : -is, -is, -it, -issons, -issez, -issent.',
          examples: ['Je finis mon travail.', 'Nous finissons le projet.', 'Vous finissez bientôt.']),
        GrammarSection(headingEn: '-RE Verbs (Third Group)', headingFr: 'Verbes en -RE (Troisième Groupe)',
          contentEn: 'Regular -RE verbs: remove -re, add: -s, -s, -(nothing), -ons, -ez, -ent. Example: vendre (to sell) → je vends, tu vends, il vend, nous vendons, vous vendez, ils vendent.',
          contentFr: 'Verbes réguliers en -RE : enlevez -re, ajoutez : -s, -s, -, -ons, -ez, -ent.',
          examples: ['Je vends ma voiture.', 'Nous vendons des fruits.', 'Elles vendent des livres.']),
      ],
      exercises: [
        GrammarExercise(questionEn: 'Je (parler) français.', questionFr: 'Je (parler) français.', correctAnswer: 'parle', options: ['parle', 'parles', 'parlent', 'parlez']),
        GrammarExercise(questionEn: 'Nous (finir) à 18h.', questionFr: 'Nous (finir) à 18h.', correctAnswer: 'finissons', options: ['finis', 'finit', 'finissons', 'finissent']),
        GrammarExercise(questionEn: 'Tu (vendre) ta maison?', questionFr: 'Tu (vendre) ta maison?', correctAnswer: 'vends', options: ['vends', 'vend', 'vendez', 'vendent']),
      ],
    ),
    GrammarLesson(
      id: 'g3', titleEn: 'Essential Irregular Verbs', titleFr: 'Verbes Irréguliers Essentiels',
      descriptionEn: 'Master être, avoir, faire, aller, pouvoir, vouloir, devoir', descriptionFr: 'Maîtrisez être, avoir, faire, aller, pouvoir, vouloir, devoir',
      difficulty: 1,
      sections: [
        GrammarSection(headingEn: 'être (to be)', headingFr: 'être',
          contentEn: 'je suis, tu es, il/elle est, nous sommes, vous êtes, ils/elles sont',
          contentFr: 'je suis, tu es, il/elle est, nous sommes, vous êtes, ils/elles sont',
          examples: ['Je suis étudiant.', 'Nous sommes français.']),
        GrammarSection(headingEn: 'avoir (to have)', headingFr: 'avoir',
          contentEn: 'j\'ai, tu as, il/elle a, nous avons, vous avez, ils/elles ont',
          contentFr: 'j\'ai, tu as, il/elle a, nous avons, vous avez, ils/elles ont',
          examples: ['J\'ai 20 ans.', 'Ils ont une grande maison.']),
        GrammarSection(headingEn: 'aller (to go)', headingFr: 'aller',
          contentEn: 'je vais, tu vas, il/elle va, nous allons, vous allez, ils/elles vont',
          contentFr: 'je vais, tu vas, il/elle va, nous allons, vous allez, ils/elles vont',
          examples: ['Je vais au cinéma.', 'Nous allons à Paris.']),
        GrammarSection(headingEn: 'faire (to do/make)', headingFr: 'faire',
          contentEn: 'je fais, tu fais, il/elle fait, nous faisons, vous faites, ils/elles font',
          contentFr: 'je fais, tu fais, il/elle fait, nous faisons, vous faites, ils/elles font',
          examples: ['Je fais du sport.', 'Que faites-vous?']),
      ],
      exercises: [
        GrammarExercise(questionEn: 'Je ___ (être)', questionFr: 'Je ___ (être)', correctAnswer: 'suis', options: ['suis', 'es', 'est', 'sont']),
        GrammarExercise(questionEn: 'Tu ___ (avoir)', questionFr: 'Tu ___ (avoir)', correctAnswer: 'as', options: ['as', 'a', 'avons', 'avez']),
        GrammarExercise(questionEn: 'Nous ___ (aller) au parc.', questionFr: 'Nous ___ (aller) au parc.', correctAnswer: 'allons', options: ['allons', 'allez', 'vont', 'va']),
      ],
    ),
    GrammarLesson(
      id: 'g4', titleEn: 'Adjectives & Agreement', titleFr: 'Les Adjectifs et l\'Accord',
      descriptionEn: 'Learn how French adjectives change with gender and number', descriptionFr: 'Apprenez comment les adjectifs français changent avec le genre et le nombre',
      difficulty: 2,
      sections: [
        GrammarSection(headingEn: 'Gender Agreement', headingFr: 'Accord de Genre',
          contentEn: 'Most adjectives add -e for feminine: grand → grande, petit → petite. Some have irregular feminine forms: beau → belle, vieux → vieille, bon → bonne.',
          contentFr: 'La plupart des adjectifs ajoutent -e au féminin : grand → grande, petit → petite.',
          examples: ['Un homme grand. / Une femme grande.', 'Un beau jardin. / Une belle fleur.']),
        GrammarSection(headingEn: 'Number Agreement', headingFr: 'Accord de Nombre',
          contentEn: 'Add -s for plural (most cases): grands, petites. Adjectives ending in -s or -x don\'t change in masculine plural.',
          contentFr: 'Ajoutez -s pour le pluriel : grands, petites.',
          examples: ['Les grands arbres.', 'Les belles maisons.']),
      ],
      exercises: [
        GrammarExercise(questionEn: 'Une ___ voiture (beautiful car)', questionFr: 'Une ___ voiture', correctAnswer: 'belle', options: ['beau', 'belle', 'belles', 'beaux']),
      ],
    ),
    GrammarLesson(
      id: 'g5', titleEn: 'Passé Composé', titleFr: 'Le Passé Composé',
      descriptionEn: 'Learn to form the past tense using avoir and être', descriptionFr: 'Apprenez à former le passé composé avec avoir et être',
      difficulty: 2,
      sections: [
        GrammarSection(headingEn: 'Formation', headingFr: 'Formation',
          contentEn: 'Passé composé = auxiliary (avoir/être in present) + past participle. Most verbs use avoir. Some movement/reflexive verbs use être.',
          contentFr: 'Passé composé = auxiliaire (avoir/être au présent) + participe passé.',
          examples: ['J\'ai mangé. (I ate)', 'Je suis allé(e). (I went)', 'Nous avons fini. (We finished)']),
      ],
      exercises: [
        GrammarExercise(questionEn: 'Hier, j\'___ (manger) une pizza.', questionFr: 'Hier, j\'___ (manger) une pizza.', correctAnswer: 'ai mangé', options: ['ai mangé', 'as mangé', 'a mangé', 'suis mangé']),
      ],
    ),
    GrammarLesson(
      id: 'g6', titleEn: 'Future Tense', titleFr: 'Le Futur Simple',
      descriptionEn: 'Form the future tense for regular and irregular verbs', descriptionFr: 'Formez le futur simple pour les verbes réguliers et irréguliers',
      difficulty: 2,
      sections: [
        GrammarSection(headingEn: 'Regular Future', headingFr: 'Futur Régulier',
          contentEn: 'Add future endings to the infinitive: -ai, -as, -a, -ons, -ez, -ont. For -RE verbs, drop the final -e first.',
          contentFr: 'Ajoutez les terminaisons du futur à l\'infinitif : -ai, -as, -a, -ons, -ez, -ont.',
          examples: ['Je parlerai (I will speak)', 'Nous finirons (We will finish)']),
      ],
      exercises: [
        GrammarExercise(questionEn: 'Demain, je ___ (parler) avec lui.', questionFr: 'Demain, je ___ (parler) avec lui.', correctAnswer: 'parlerai', options: ['parlerai', 'parleras', 'parle', 'parlais']),
      ],
    ),
    GrammarLesson(
      id: 'g7', titleEn: 'Prepositions', titleFr: 'Les Prépositions',
      descriptionEn: 'Master common French prepositions: à, de, dans, sur, sous, etc.', descriptionFr: 'Maîtrisez les prépositions courantes : à, de, dans, sur, sous, etc.',
      difficulty: 1,
      sections: [
        GrammarSection(headingEn: 'Common Prepositions', headingFr: 'Prépositions Courantes',
          contentEn: 'à (to/at), de (of/from), dans (in/inside), sur (on), sous (under), devant (in front of), derrière (behind), entre (between), avec (with), sans (without), pour (for), contre (against).',
          contentFr: 'à, de, dans, sur, sous, devant, derrière, entre, avec, sans, pour, contre.',
          examples: ['Je vais à Paris.', 'Le livre est sur la table.', 'Le chat est sous le lit.']),
      ],
      exercises: [
        GrammarExercise(questionEn: 'Je vais ___ Paris.', questionFr: 'Je vais ___ Paris.', correctAnswer: 'à', options: ['à', 'de', 'dans', 'sur']),
      ],
    ),
    GrammarLesson(
      id: 'g8', titleEn: 'Negation', titleFr: 'La Négation',
      descriptionEn: 'Learn negative structures: ne...pas, ne...jamais, ne...plus', descriptionFr: 'Apprenez les structures négatives : ne...pas, ne...jamais, ne...plus',
      difficulty: 1,
      sections: [
        GrammarSection(headingEn: 'Basic Negation', headingFr: 'Négation de Base',
          contentEn: 'Wrap the verb with ne...pas: Je ne parle pas anglais. In spoken French, "ne" is often dropped: Je parle pas.',
          contentFr: 'Encadrez le verbe avec ne...pas : Je ne parle pas anglais.',
          examples: ['Je ne comprends pas.', 'Il ne mange jamais de viande.', 'Nous n\'avons plus d\'argent.']),
      ],
      exercises: [
        GrammarExercise(questionEn: 'Je ___ parle ___ anglais. (I don\'t speak English)', questionFr: 'Je ___ parle ___ anglais.', correctAnswer: 'ne...pas', options: ['ne...pas', 'ne...jamais', 'ne...plus', 'ne...rien']),
      ],
    ),
  ];
}
