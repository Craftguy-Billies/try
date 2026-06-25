import '../models/verb.dart';

const List<VerbConjugation> frenchVerbs = [
  // ---- Être ----
  VerbConjugation(
    infinitive: 'être', meaning: 'to be', group: 'irregular',
    conjugations: {
      'Présent': {'je': 'suis', 'tu': 'es', 'il/elle/on': 'est', 'nous': 'sommes', 'vous': 'êtes', 'ils/elles': 'sont'},
      'Imparfait': {'je': 'étais', 'tu': 'étais', 'il/elle/on': 'était', 'nous': 'étions', 'vous': 'étiez', 'ils/elles': 'étaient'},
      'Futur Simple': {'je': 'serai', 'tu': 'seras', 'il/elle/on': 'sera', 'nous': 'serons', 'vous': 'serez', 'ils/elles': 'seront'},
      'Passé Composé': {'je': 'ai été', 'tu': 'as été', 'il/elle/on': 'a été', 'nous': 'avons été', 'vous': 'avez été', 'ils/elles': 'ont été'},
    },
  ),
  // ---- Avoir ----
  VerbConjugation(
    infinitive: 'avoir', meaning: 'to have', group: 'irregular',
    conjugations: {
      'Présent': {'je': 'ai', 'tu': 'as', 'il/elle/on': 'a', 'nous': 'avons', 'vous': 'avez', 'ils/elles': 'ont'},
      'Imparfait': {'je': 'avais', 'tu': 'avais', 'il/elle/on': 'avait', 'nous': 'avions', 'vous': 'aviez', 'ils/elles': 'avaient'},
      'Futur Simple': {'je': 'aurai', 'tu': 'auras', 'il/elle/on': 'aura', 'nous': 'aurons', 'vous': 'aurez', 'ils/elles': 'auront'},
      'Passé Composé': {'je': 'ai eu', 'tu': 'as eu', 'il/elle/on': 'a eu', 'nous': 'avons eu', 'vous': 'avez eu', 'ils/elles': 'ont eu'},
    },
  ),
  // ---- Aller ----
  VerbConjugation(
    infinitive: 'aller', meaning: 'to go', group: 'irregular',
    conjugations: {
      'Présent': {'je': 'vais', 'tu': 'vas', 'il/elle/on': 'va', 'nous': 'allons', 'vous': 'allez', 'ils/elles': 'vont'},
      'Imparfait': {'je': 'allais', 'tu': 'allais', 'il/elle/on': 'allait', 'nous': 'allions', 'vous': 'alliez', 'ils/elles': 'allaient'},
      'Futur Simple': {'je': 'irai', 'tu': 'iras', 'il/elle/on': 'ira', 'nous': 'irons', 'vous': 'irez', 'ils/elles': 'iront'},
      'Passé Composé': {'je': 'suis allé(e)', 'tu': 'es allé(e)', 'il/elle/on': 'est allé(e)', 'nous': 'sommes allé(e)s', 'vous': 'êtes allé(e)(s)', 'ils/elles': 'sont allé(e)s'},
    },
  ),
  // ---- Faire ----
  VerbConjugation(
    infinitive: 'faire', meaning: 'to do / make', group: 'irregular',
    conjugations: {
      'Présent': {'je': 'fais', 'tu': 'fais', 'il/elle/on': 'fait', 'nous': 'faisons', 'vous': 'faites', 'ils/elles': 'font'},
      'Imparfait': {'je': 'faisais', 'tu': 'faisais', 'il/elle/on': 'faisait', 'nous': 'faisions', 'vous': 'faisiez', 'ils/elles': 'faisaient'},
      'Futur Simple': {'je': 'ferai', 'tu': 'feras', 'il/elle/on': 'fera', 'nous': 'ferons', 'vous': 'ferez', 'ils/elles': 'feront'},
      'Passé Composé': {'je': 'ai fait', 'tu': 'as fait', 'il/elle/on': 'a fait', 'nous': 'avons fait', 'vous': 'avez fait', 'ils/elles': 'ont fait'},
    },
  ),
  // ---- Parler (-er regular) ----
  VerbConjugation(
    infinitive: 'parler', meaning: 'to speak', group: 'er',
    conjugations: {
      'Présent': {'je': 'parle', 'tu': 'parles', 'il/elle/on': 'parle', 'nous': 'parlons', 'vous': 'parlez', 'ils/elles': 'parlent'},
      'Imparfait': {'je': 'parlais', 'tu': 'parlais', 'il/elle/on': 'parlait', 'nous': 'parlions', 'vous': 'parliez', 'ils/elles': 'parlaient'},
      'Futur Simple': {'je': 'parlerai', 'tu': 'parleras', 'il/elle/on': 'parlera', 'nous': 'parlerons', 'vous': 'parlerez', 'ils/elles': 'parleront'},
      'Passé Composé': {'je': 'ai parlé', 'tu': 'as parlé', 'il/elle/on': 'a parlé', 'nous': 'avons parlé', 'vous': 'avez parlé', 'ils/elles': 'ont parlé'},
    },
  ),
  // ---- Finir (-ir regular) ----
  VerbConjugation(
    infinitive: 'finir', meaning: 'to finish', group: 'ir',
    conjugations: {
      'Présent': {'je': 'finis', 'tu': 'finis', 'il/elle/on': 'finit', 'nous': 'finissons', 'vous': 'finissez', 'ils/elles': 'finissent'},
      'Imparfait': {'je': 'finissais', 'tu': 'finissais', 'il/elle/on': 'finissait', 'nous': 'finissions', 'vous': 'finissiez', 'ils/elles': 'finissaient'},
      'Futur Simple': {'je': 'finirai', 'tu': 'finiras', 'il/elle/on': 'finira', 'nous': 'finirons', 'vous': 'finirez', 'ils/elles': 'finiront'},
      'Passé Composé': {'je': 'ai fini', 'tu': 'as fini', 'il/elle/on': 'a fini', 'nous': 'avons fini', 'vous': 'avez fini', 'ils/elles': 'ont fini'},
    },
  ),
  // ---- Vendre (-re regular) ----
  VerbConjugation(
    infinitive: 'vendre', meaning: 'to sell', group: 're',
    conjugations: {
      'Présent': {'je': 'vends', 'tu': 'vends', 'il/elle/on': 'vend', 'nous': 'vendons', 'vous': 'vendez', 'ils/elles': 'vendent'},
      'Imparfait': {'je': 'vendais', 'tu': 'vendais', 'il/elle/on': 'vendait', 'nous': 'vendions', 'vous': 'vendiez', 'ils/elles': 'vendaient'},
      'Futur Simple': {'je': 'vendrai', 'tu': 'vendras', 'il/elle/on': 'vendra', 'nous': 'vendrons', 'vous': 'vendrez', 'ils/elles': 'vendront'},
      'Passé Composé': {'je': 'ai vendu', 'tu': 'as vendu', 'il/elle/on': 'a vendu', 'nous': 'avons vendu', 'vous': 'avez vendu', 'ils/elles': 'ont vendu'},
    },
  ),
  // ---- Pouvoir ----
  VerbConjugation(
    infinitive: 'pouvoir', meaning: 'to be able to / can', group: 'irregular',
    conjugations: {
      'Présent': {'je': 'peux', 'tu': 'peux', 'il/elle/on': 'peut', 'nous': 'pouvons', 'vous': 'pouvez', 'ils/elles': 'peuvent'},
      'Imparfait': {'je': 'pouvais', 'tu': 'pouvais', 'il/elle/on': 'pouvait', 'nous': 'pouvions', 'vous': 'pouviez', 'ils/elles': 'pouvaient'},
      'Futur Simple': {'je': 'pourrai', 'tu': 'pourras', 'il/elle/on': 'pourra', 'nous': 'pourrons', 'vous': 'pourrez', 'ils/elles': 'pourront'},
      'Passé Composé': {'je': 'ai pu', 'tu': 'as pu', 'il/elle/on': 'a pu', 'nous': 'avons pu', 'vous': 'avez pu', 'ils/elles': 'ont pu'},
    },
  ),
  // ---- Vouloir ----
  VerbConjugation(
    infinitive: 'vouloir', meaning: 'to want', group: 'irregular',
    conjugations: {
      'Présent': {'je': 'veux', 'tu': 'veux', 'il/elle/on': 'veut', 'nous': 'voulons', 'vous': 'voulez', 'ils/elles': 'veulent'},
      'Imparfait': {'je': 'voulais', 'tu': 'voulais', 'il/elle/on': 'voulait', 'nous': 'voulions', 'vous': 'vouliez', 'ils/elles': 'voulaient'},
      'Futur Simple': {'je': 'voudrai', 'tu': 'voudras', 'il/elle/on': 'voudra', 'nous': 'voudrons', 'vous': 'voudrez', 'ils/elles': 'voudront'},
      'Passé Composé': {'je': 'ai voulu', 'tu': 'as voulu', 'il/elle/on': 'a voulu', 'nous': 'avons voulu', 'vous': 'avez voulu', 'ils/elles': 'ont voulu'},
    },
  ),
  // ---- Devoir ----
  VerbConjugation(
    infinitive: 'devoir', meaning: 'to have to / must', group: 'irregular',
    conjugations: {
      'Présent': {'je': 'dois', 'tu': 'dois', 'il/elle/on': 'doit', 'nous': 'devons', 'vous': 'devez', 'ils/elles': 'doivent'},
      'Imparfait': {'je': 'devais', 'tu': 'devais', 'il/elle/on': 'devait', 'nous': 'devions', 'vous': 'deviez', 'ils/elles': 'devaient'},
      'Futur Simple': {'je': 'devrai', 'tu': 'devras', 'il/elle/on': 'devra', 'nous': 'devrons', 'vous': 'devrez', 'ils/elles': 'devront'},
      'Passé Composé': {'je': 'ai dû', 'tu': 'as dû', 'il/elle/on': 'a dû', 'nous': 'avons dû', 'vous': 'avez dû', 'ils/elles': 'ont dû'},
    },
  ),
];
