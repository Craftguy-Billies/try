/// Complete conjugation tables for 25 essential French verbs.
/// Each verb includes 6 tenses with all 6 grammatical persons.
/// Pronouns follow the standard order: je, tu, il/elle/on, nous, vous, ils/elles

class VerbTense {
  final String name;
  final List<String> conjugations; // length 6
  final List<String> pronouns; // length 6

  const VerbTense({
    required this.name,
    required this.conjugations,
    required this.pronouns,
  });
}

class FrenchVerb {
  final String infinitive;
  final String english;
  final String group; // "1st", "2nd", "3rd", "irregular" (être/avoir)
  final List<VerbTense> tenses;
  final String? example;

  const FrenchVerb({
    required this.infinitive,
    required this.english,
    required this.group,
    required this.tenses,
    this.example,
  });

  /// Look up a specific tense by name.
  VerbTense? tense(String name) {
    for (final t in tenses) {
      if (t.name == name) return t;
    }
    return null;
  }
}

// Shared pronoun list
const _pr = ['je', 'tu', 'il/elle/on', 'nous', 'vous', 'ils/elles'];
const _prAlt = ['je/j\'', 'tu', 'il/elle/on', 'nous', 'vous', 'ils/elles'];

// ─── 1. ÊTRE ────────────────────────────────────────────────────────────────

const _etre = FrenchVerb(
  infinitive: 'être',
  english: 'to be',
  group: 'irregular',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _prAlt, conjugations: [
      'suis', 'es', 'est', 'sommes', 'êtes', 'sont',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _prAlt, conjugations: [
      'étais', 'étais', 'était', 'étions', 'étiez', 'étaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'serai', 'seras', 'sera', 'serons', 'serez', 'seront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai été', 'as été', 'a été', 'avons été', 'avez été', 'ont été',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'serais', 'serais', 'serait', 'serions', 'seriez', 'seraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'sois', 'sois', 'soit', 'soyons', 'soyez', 'soient',
    ]),
  ],
  example: 'Je suis français.',
);

// ─── 2. AVOIR ───────────────────────────────────────────────────────────────

const _avoir = FrenchVerb(
  infinitive: 'avoir',
  english: 'to have',
  group: 'irregular',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _prAlt, conjugations: [
      'ai', 'as', 'a', 'avons', 'avez', 'ont',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _prAlt, conjugations: [
      'avais', 'avais', 'avait', 'avions', 'aviez', 'avaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _prAlt, conjugations: [
      'aurai', 'auras', 'aura', 'aurons', 'aurez', 'auront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai eu', 'as eu', 'a eu', 'avons eu', 'avez eu', 'ont eu',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _prAlt, conjugations: [
      'aurais', 'aurais', 'aurait', 'aurions', 'auriez', 'auraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _prAlt, conjugations: [
      'aie', 'aies', 'ait', 'ayons', 'ayez', 'aient',
    ]),
  ],
  example: "J'ai deux sœurs.",
);

// ─── 3. ALLER ───────────────────────────────────────────────────────────────

const _aller = FrenchVerb(
  infinitive: 'aller',
  english: 'to go',
  group: '3rd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'vais', 'vas', 'va', 'allons', 'allez', 'vont',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _prAlt, conjugations: [
      'allais', 'allais', 'allait', 'allions', 'alliez', 'allaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _prAlt, conjugations: [
      'irai', 'iras', 'ira', 'irons', 'irez', 'iront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _pr, conjugations: [
      'suis allé(e)', 'es allé(e)', 'est allé(e)', 'sommes allé(e)s', 'êtes allé(e)(s)', 'sont allé(e)s',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _prAlt, conjugations: [
      'irais', 'irais', 'irait', 'irions', 'iriez', 'iraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _prAlt, conjugations: [
      'aille', 'ailles', 'aille', 'allions', 'alliez', 'aillent',
    ]),
  ],
  example: 'Je vais au marché.',
);

// ─── 4. FAIRE ───────────────────────────────────────────────────────────────

const _faire = FrenchVerb(
  infinitive: 'faire',
  english: 'to do / to make',
  group: '3rd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'fais', 'fais', 'fait', 'faisons', 'faites', 'font',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'faisais', 'faisais', 'faisait', 'faisions', 'faisiez', 'faisaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'ferai', 'feras', 'fera', 'ferons', 'ferez', 'feront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai fait', 'as fait', 'a fait', 'avons fait', 'avez fait', 'ont fait',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'ferais', 'ferais', 'ferait', 'ferions', 'feriez', 'feraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'fasse', 'fasses', 'fasse', 'fassions', 'fassiez', 'fassent',
    ]),
  ],
  example: 'Je fais mes devoirs.',
);

// ─── 5. POUVOIR ─────────────────────────────────────────────────────────────

const _pouvoir = FrenchVerb(
  infinitive: 'pouvoir',
  english: 'to be able to / can',
  group: '3rd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'peux', 'peux', 'peut', 'pouvons', 'pouvez', 'peuvent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'pouvais', 'pouvais', 'pouvait', 'pouvions', 'pouviez', 'pouvaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'pourrai', 'pourras', 'pourra', 'pourrons', 'pourrez', 'pourront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai pu', 'as pu', 'a pu', 'avons pu', 'avez pu', 'ont pu',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'pourrais', 'pourrais', 'pourrait', 'pourrions', 'pourriez', 'pourraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'puisse', 'puisses', 'puisse', 'puissions', 'puissiez', 'puissent',
    ]),
  ],
  example: 'Je peux parler français.',
);

// ─── 6. VOULOIR ─────────────────────────────────────────────────────────────

const _vouloir = FrenchVerb(
  infinitive: 'vouloir',
  english: 'to want',
  group: '3rd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'veux', 'veux', 'veut', 'voulons', 'voulez', 'veulent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'voulais', 'voulais', 'voulait', 'voulions', 'vouliez', 'voulaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'voudrai', 'voudras', 'voudra', 'voudrons', 'voudrez', 'voudront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai voulu', 'as voulu', 'a voulu', 'avons voulu', 'avez voulu', 'ont voulu',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'voudrais', 'voudrais', 'voudrait', 'voudrions', 'voudriez', 'voudraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'veuille', 'veuilles', 'veuille', 'voulions', 'vouliez', 'veuillent',
    ]),
  ],
  example: 'Je voudrais un café.',
);

// ─── 7. DEVOIR ──────────────────────────────────────────────────────────────

const _devoir = FrenchVerb(
  infinitive: 'devoir',
  english: 'to have to / must / to owe',
  group: '3rd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'dois', 'dois', 'doit', 'devons', 'devez', 'doivent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'devais', 'devais', 'devait', 'devions', 'deviez', 'devaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'devrai', 'devras', 'devra', 'devrons', 'devrez', 'devront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai dû', 'as dû', 'a dû', 'avons dû', 'avez dû', 'ont dû',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'devrais', 'devrais', 'devrait', 'devrions', 'devriez', 'devraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'doive', 'doives', 'doive', 'devions', 'deviez', 'doivent',
    ]),
  ],
  example: 'Je dois partir maintenant.',
);

// ─── 8. SAVOIR ──────────────────────────────────────────────────────────────

const _savoir = FrenchVerb(
  infinitive: 'savoir',
  english: 'to know',
  group: '3rd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'sais', 'sais', 'sait', 'savons', 'savez', 'savent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'savais', 'savais', 'savait', 'savions', 'saviez', 'savaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'saurai', 'sauras', 'saura', 'saurons', 'saurez', 'sauront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai su', 'as su', 'a su', 'avons su', 'avez su', 'ont su',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'saurais', 'saurais', 'saurait', 'saurions', 'sauriez', 'sauraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'sache', 'saches', 'sache', 'sachions', 'sachiez', 'sachent',
    ]),
  ],
  example: 'Je sais parler français.',
);

// ─── 9. VOIR ────────────────────────────────────────────────────────────────

const _voir = FrenchVerb(
  infinitive: 'voir',
  english: 'to see',
  group: '3rd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'vois', 'vois', 'voit', 'voyons', 'voyez', 'voient',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'voyais', 'voyais', 'voyait', 'voyions', 'voyiez', 'voyaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'verrai', 'verras', 'verra', 'verrons', 'verrez', 'verront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai vu', 'as vu', 'a vu', 'avons vu', 'avez vu', 'ont vu',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'verrais', 'verrais', 'verrait', 'verrions', 'verriez', 'verraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'voie', 'voies', 'voie', 'voyions', 'voyiez', 'voient',
    ]),
  ],
  example: 'Je vois la tour Eiffel.',
);

// ─── 10. VENIR ──────────────────────────────────────────────────────────────

const _venir = FrenchVerb(
  infinitive: 'venir',
  english: 'to come',
  group: '3rd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'viens', 'viens', 'vient', 'venons', 'venez', 'viennent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'venais', 'venais', 'venait', 'venions', 'veniez', 'venaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'viendrai', 'viendras', 'viendra', 'viendrons', 'viendrez', 'viendront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _pr, conjugations: [
      'suis venu(e)', 'es venu(e)', 'est venu(e)', 'sommes venu(e)s', 'êtes venu(e)(s)', 'sont venu(e)s',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'viendrais', 'viendrais', 'viendrait', 'viendrions', 'viendriez', 'viendraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'vienne', 'viennes', 'vienne', 'venions', 'veniez', 'viennent',
    ]),
  ],
  example: 'Je viens de Paris.',
);

// ─── 11. PRENDRE ────────────────────────────────────────────────────────────

const _prendre = FrenchVerb(
  infinitive: 'prendre',
  english: 'to take',
  group: '3rd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'prends', 'prends', 'prend', 'prenons', 'prenez', 'prennent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'prenais', 'prenais', 'prenait', 'prenions', 'preniez', 'prenaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'prendrai', 'prendras', 'prendra', 'prendrons', 'prendrez', 'prendront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai pris', 'as pris', 'a pris', 'avons pris', 'avez pris', 'ont pris',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'prendrais', 'prendrais', 'prendrait', 'prendrions', 'prendriez', 'prendraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'prenne', 'prennes', 'prenne', 'prenions', 'preniez', 'prennent',
    ]),
  ],
  example: 'Je prends le train.',
);

// ─── 12. METTRE ─────────────────────────────────────────────────────────────

const _mettre = FrenchVerb(
  infinitive: 'mettre',
  english: 'to put / to wear',
  group: '3rd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'mets', 'mets', 'met', 'mettons', 'mettez', 'mettent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'mettais', 'mettais', 'mettait', 'mettions', 'mettiez', 'mettaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'mettrai', 'mettras', 'mettra', 'mettrons', 'mettrez', 'mettront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai mis', 'as mis', 'a mis', 'avons mis', 'avez mis', 'ont mis',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'mettrais', 'mettrais', 'mettrait', 'mettrions', 'mettriez', 'mettraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'mette', 'mettes', 'mette', 'mettions', 'mettiez', 'mettent',
    ]),
  ],
  example: 'Je mets la table.',
);

// ─── 13. DIRE ───────────────────────────────────────────────────────────────

const _dire = FrenchVerb(
  infinitive: 'dire',
  english: 'to say / to tell',
  group: '3rd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'dis', 'dis', 'dit', 'disons', 'dites', 'disent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'disais', 'disais', 'disait', 'disions', 'disiez', 'disaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'dirai', 'diras', 'dira', 'dirons', 'direz', 'diront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai dit', 'as dit', 'a dit', 'avons dit', 'avez dit', 'ont dit',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'dirais', 'dirais', 'dirait', 'dirions', 'diriez', 'diraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'dise', 'dises', 'dise', 'disions', 'disiez', 'disent',
    ]),
  ],
  example: 'Je dis la vérité.',
);

// ─── 14. LIRE ───────────────────────────────────────────────────────────────

const _lire = FrenchVerb(
  infinitive: 'lire',
  english: 'to read',
  group: '3rd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'lis', 'lis', 'lit', 'lisons', 'lisez', 'lisent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'lisais', 'lisais', 'lisait', 'lisions', 'lisiez', 'lisaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'lirai', 'liras', 'lira', 'lirons', 'lirez', 'liront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai lu', 'as lu', 'a lu', 'avons lu', 'avez lu', 'ont lu',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'lirais', 'lirais', 'lirait', 'lirions', 'liriez', 'liraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'lise', 'lises', 'lise', 'lisions', 'lisiez', 'lisent',
    ]),
  ],
  example: 'Je lis un livre.',
);

// ─── 15. ÉCRIRE ─────────────────────────────────────────────────────────────

const _ecrire = FrenchVerb(
  infinitive: 'écrire',
  english: 'to write',
  group: '3rd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _prAlt, conjugations: [
      'écris', 'écris', 'écrit', 'écrivons', 'écrivez', 'écrivent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _prAlt, conjugations: [
      'écrivais', 'écrivais', 'écrivait', 'écrivions', 'écriviez', 'écrivaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _prAlt, conjugations: [
      'écrirai', 'écriras', 'écrira', 'écrirons', 'écrirez', 'écriront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai écrit', 'as écrit', 'a écrit', 'avons écrit', 'avez écrit', 'ont écrit',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _prAlt, conjugations: [
      'écrirais', 'écrirais', 'écrirait', 'écririons', 'écririez', 'écriraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _prAlt, conjugations: [
      'écrive', 'écrives', 'écrive', 'écrivions', 'écriviez', 'écrivent',
    ]),
  ],
  example: "J'écris une lettre.",
);

// ─── 16. PARTIR ─────────────────────────────────────────────────────────────

const _partir = FrenchVerb(
  infinitive: 'partir',
  english: 'to leave',
  group: '3rd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'pars', 'pars', 'part', 'partons', 'partez', 'partent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'partais', 'partais', 'partait', 'partions', 'partiez', 'partaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'partirai', 'partiras', 'partira', 'partirons', 'partirez', 'partiront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _pr, conjugations: [
      'suis parti(e)', 'es parti(e)', 'est parti(e)', 'sommes parti(e)s', 'êtes parti(e)(s)', 'sont parti(e)s',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'partirais', 'partirais', 'partirait', 'partirions', 'partiriez', 'partiraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'parte', 'partes', 'parte', 'partions', 'partiez', 'partent',
    ]),
  ],
  example: 'Je pars demain matin.',
);

// ─── 17. SORTIR ─────────────────────────────────────────────────────────────

const _sortir = FrenchVerb(
  infinitive: 'sortir',
  english: 'to go out / to exit',
  group: '3rd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'sors', 'sors', 'sort', 'sortons', 'sortez', 'sortent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'sortais', 'sortais', 'sortait', 'sortions', 'sortiez', 'sortaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'sortirai', 'sortiras', 'sortira', 'sortirons', 'sortirez', 'sortiront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _pr, conjugations: [
      'suis sorti(e)', 'es sorti(e)', 'est sorti(e)', 'sommes sorti(e)s', 'êtes sorti(e)(s)', 'sont sorti(e)s',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'sortirais', 'sortirais', 'sortirait', 'sortirions', 'sortiriez', 'sortiraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'sorte', 'sortes', 'sorte', 'sortions', 'sortiez', 'sortent',
    ]),
  ],
  example: 'Je sors ce soir.',
);

// ─── 18. DORMIR ─────────────────────────────────────────────────────────────

const _dormir = FrenchVerb(
  infinitive: 'dormir',
  english: 'to sleep',
  group: '3rd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'dors', 'dors', 'dort', 'dormons', 'dormez', 'dorment',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'dormais', 'dormais', 'dormait', 'dormions', 'dormiez', 'dormaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'dormirai', 'dormiras', 'dormira', 'dormirons', 'dormirez', 'dormiront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai dormi', 'as dormi', 'a dormi', 'avons dormi', 'avez dormi', 'ont dormi',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'dormirais', 'dormirais', 'dormirait', 'dormirions', 'dormiriez', 'dormiraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'dorme', 'dormes', 'dorme', 'dormions', 'dormiez', 'dorment',
    ]),
  ],
  example: 'Je dors huit heures par nuit.',
);

// ─── 19. FINIR ──────────────────────────────────────────────────────────────

const _finir = FrenchVerb(
  infinitive: 'finir',
  english: 'to finish',
  group: '2nd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'finis', 'finis', 'finit', 'finissons', 'finissez', 'finissent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'finissais', 'finissais', 'finissait', 'finissions', 'finissiez', 'finissaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'finirai', 'finiras', 'finira', 'finirons', 'finirez', 'finiront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai fini', 'as fini', 'a fini', 'avons fini', 'avez fini', 'ont fini',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'finirais', 'finirais', 'finirait', 'finirions', 'finiriez', 'finiraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'finisse', 'finisses', 'finisse', 'finissions', 'finissiez', 'finissent',
    ]),
  ],
  example: 'Je finis mes devoirs.',
);

// ─── 20. CHOISIR ────────────────────────────────────────────────────────────

const _choisir = FrenchVerb(
  infinitive: 'choisir',
  english: 'to choose',
  group: '2nd',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'choisis', 'choisis', 'choisit', 'choisissons', 'choisissez', 'choisissent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'choisissais', 'choisissais', 'choisissait', 'choisissions', 'choisissiez', 'choisissaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'choisirai', 'choisiras', 'choisira', 'choisirons', 'choisirez', 'choisiront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai choisi', 'as choisi', 'a choisi', 'avons choisi', 'avez choisi', 'ont choisi',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'choisirais', 'choisirais', 'choisirait', 'choisirions', 'choisiriez', 'choisiraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'choisisse', 'choisisses', 'choisisse', 'choisissions', 'choisissiez', 'choisissent',
    ]),
  ],
  example: 'Je choisis le menu végétarien.',
);

// ─── 21. PARLER ─────────────────────────────────────────────────────────────

const _parler = FrenchVerb(
  infinitive: 'parler',
  english: 'to speak / to talk',
  group: '1st',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'parle', 'parles', 'parle', 'parlons', 'parlez', 'parlent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'parlais', 'parlais', 'parlait', 'parlions', 'parliez', 'parlaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'parlerai', 'parleras', 'parlera', 'parlerons', 'parlerez', 'parleront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai parlé', 'as parlé', 'a parlé', 'avons parlé', 'avez parlé', 'ont parlé',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'parlerais', 'parlerais', 'parlerait', 'parlerions', 'parleriez', 'parleraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'parle', 'parles', 'parle', 'parlions', 'parliez', 'parlent',
    ]),
  ],
  example: 'Je parle français et anglais.',
);

// ─── 22. AIMER ──────────────────────────────────────────────────────────────

const _aimer = FrenchVerb(
  infinitive: 'aimer',
  english: 'to love / to like',
  group: '1st',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _prAlt, conjugations: [
      'aime', 'aimes', 'aime', 'aimons', 'aimez', 'aiment',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _prAlt, conjugations: [
      'aimais', 'aimais', 'aimait', 'aimions', 'aimiez', 'aimaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _prAlt, conjugations: [
      'aimerai', 'aimeras', 'aimera', 'aimerons', 'aimerez', 'aimeront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai aimé', 'as aimé', 'a aimé', 'avons aimé', 'avez aimé', 'ont aimé',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _prAlt, conjugations: [
      'aimerais', 'aimerais', 'aimerait', 'aimerions', 'aimeriez', 'aimeraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _prAlt, conjugations: [
      'aime', 'aimes', 'aime', 'aimions', 'aimiez', 'aiment',
    ]),
  ],
  example: "J'aime le chocolat.",
);

// ─── 23. MANGER ─────────────────────────────────────────────────────────────

const _manger = FrenchVerb(
  infinitive: 'manger',
  english: 'to eat',
  group: '1st',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'mange', 'manges', 'mange', 'mangeons', 'mangez', 'mangent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'mangeais', 'mangeais', 'mangeait', 'mangions', 'mangiez', 'mangeaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'mangerai', 'mangeras', 'mangera', 'mangerons', 'mangerez', 'mangeront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai mangé', 'as mangé', 'a mangé', 'avons mangé', 'avez mangé', 'ont mangé',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'mangerais', 'mangerais', 'mangerait', 'mangerions', 'mangeriez', 'mangeraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'mange', 'manges', 'mange', 'mangions', 'mangiez', 'mangent',
    ]),
  ],
  example: 'Je mange une pomme.',
);

// ─── 24. COMMENCER ──────────────────────────────────────────────────────────

const _commencer = FrenchVerb(
  infinitive: 'commencer',
  english: 'to begin / to start',
  group: '1st',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _pr, conjugations: [
      'commence', 'commences', 'commence', 'commençons', 'commencez', 'commencent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _pr, conjugations: [
      'commençais', 'commençais', 'commençait', 'commencions', 'commenciez', 'commençaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _pr, conjugations: [
      'commencerai', 'commenceras', 'commencera', 'commencerons', 'commencerez', 'commenceront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai commencé', 'as commencé', 'a commencé', 'avons commencé', 'avez commencé', 'ont commencé',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _pr, conjugations: [
      'commencerais', 'commencerais', 'commencerait', 'commencerions', 'commenceriez', 'commenceraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _pr, conjugations: [
      'commence', 'commences', 'commence', 'commencions', 'commenciez', 'commencent',
    ]),
  ],
  example: 'Le film commence à 20h.',
);

// ─── 25. APPELER ────────────────────────────────────────────────────────────

const _appeler = FrenchVerb(
  infinitive: 'appeler',
  english: 'to call / to name',
  group: '1st',
  tenses: [
    VerbTense(name: 'Présent', pronouns: _prAlt, conjugations: [
      'appelle', 'appelles', 'appelle', 'appelons', 'appelez', 'appellent',
    ]),
    VerbTense(name: 'Imparfait', pronouns: _prAlt, conjugations: [
      'appelais', 'appelais', 'appelait', 'appelions', 'appeliez', 'appelaient',
    ]),
    VerbTense(name: 'Futur simple', pronouns: _prAlt, conjugations: [
      'appellerai', 'appelleras', 'appellera', 'appellerons', 'appellerez', 'appelleront',
    ]),
    VerbTense(name: 'Passé composé', pronouns: _prAlt, conjugations: [
      'ai appelé', 'as appelé', 'a appelé', 'avons appelé', 'avez appelé', 'ont appelé',
    ]),
    VerbTense(name: 'Conditionnel présent', pronouns: _prAlt, conjugations: [
      'appellerais', 'appellerais', 'appellerait', 'appellerions', 'appelleriez', 'appelleraient',
    ]),
    VerbTense(name: 'Subjonctif présent', pronouns: _prAlt, conjugations: [
      'appelle', 'appelles', 'appelle', 'appelions', 'appeliez', 'appellent',
    ]),
  ],
  example: "Je m'appelle Marie.",
);

// ─── Master list ────────────────────────────────────────────────────────────

const List<FrenchVerb> allVerbs = [
  _etre,
  _avoir,
  _aller,
  _faire,
  _pouvoir,
  _vouloir,
  _devoir,
  _savoir,
  _voir,
  _venir,
  _prendre,
  _mettre,
  _dire,
  _lire,
  _ecrire,
  _partir,
  _sortir,
  _dormir,
  _finir,
  _choisir,
  _parler,
  _aimer,
  _manger,
  _commencer,
  _appeler,
];

// ─── Group access helpers ───────────────────────────────────────────────────

Map<String, List<FrenchVerb>> get verbsByGroup {
  final map = <String, List<FrenchVerb>>{};
  for (final v in allVerbs) {
    map.putIfAbsent(v.group, () => []).add(v);
  }
  return map;
}

List<FrenchVerb> get firstGroupVerbs =>
    allVerbs.where((v) => v.group == '1st').toList();

List<FrenchVerb> get secondGroupVerbs =>
    allVerbs.where((v) => v.group == '2nd').toList();

List<FrenchVerb> get thirdGroupVerbs =>
    allVerbs.where((v) => v.group == '3rd').toList();

List<FrenchVerb> get irregularVerbs =>
    allVerbs.where((v) => v.group == 'irregular').toList();

/// Look up a verb by infinitive (case-insensitive).
FrenchVerb? lookupVerb(String infinitive) {
  final q = infinitive.trim().toLowerCase();
  for (final v in allVerbs) {
    if (v.infinitive.toLowerCase() == q) return v;
  }
  return null;
}

int get verbCount => allVerbs.length;
