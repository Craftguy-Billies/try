/// Comprehensive French grammar lessons for DELF preparation and general learning.
/// Each lesson contains substantive explanations with real French examples.
/// Content is formatted in Markdown for rendering in a Flutter app.

class GrammarLesson {
  final String id;
  final String title;
  final int level; // 1-5 difficulty
  final List<String> topics;
  final String content;

  const GrammarLesson({
    required this.id,
    required this.title,
    required this.level,
    required this.topics,
    required this.content,
  });
}

// ─── 1. Articles ────────────────────────────────────────────────────────────

const _lessonArticles = GrammarLesson(
  id: 'articles',
  title: 'Les Articles – Definite, Indefinite & Partitive',
  level: 1,
  topics: ['Definite articles', 'Indefinite articles', 'Partitive articles', 'Article omission rules'],
  content: '''## Les Articles en Français

French articles are essential determiners that precede nouns and must agree in **gender** (masculine/feminine) and **number** (singular/plural).

### 1. Les Articles Définis (Definite Articles)

Used for specific or known nouns, general truths, and abstract concepts.

| Article | Usage | Example |
|---------|-------|---------|
| **le** | Masculine singular | *Le livre est intéressant.* |
| **la** | Feminine singular | *La maison est grande.* |
| **l'** | Before vowel or mute h | *L'école est fermée. L'hôtel est complet.* |
| **les** | Plural (both genders) | *Les enfants jouent. Les portes sont ouvertes.* |

**Key rules:**
- Use for general truths: *Le vin est bon pour la santé.* (Wine in general)
- Use for likes/dislikes: *J'aime le chocolat.* (Chocolate in general)
- Use with days for habitual actions: *Le lundi, je vais à la gym.* (On Mondays)

### 2. Les Articles Indéfinis (Indefinite Articles)

Used for non-specific or newly introduced nouns.

| Article | Usage | Example |
|---------|-------|---------|
| **un** | Masculine singular | *J'ai un ami à Paris.* |
| **une** | Feminine singular | *Elle achète une robe.* |
| **des** | Plural (both genders) | *Il y a des fleurs dans le jardin.* |

**Key rule:** *Des* becomes *de* before a plural adjective preceding the noun:
- *J'ai **de** beaux livres.* (not *des beaux livres*)

### 3. Les Articles Partitifs (Partitive Articles)

Used for uncountable nouns, expressing "some" or "a part of".

| Article | Usage | Example |
|---------|-------|---------|
| **du** | Masculine | *Je voudrais du pain.* |
| **de la** | Feminine | *Elle boit de la bière.* |
| **de l'** | Before vowel/h | *Il prend de l'eau.* |
| **des** | Plural uncountable | rare in practice |

**After negation**, all partitives become **de**:
- *Je mange du fromage.* → *Je ne mange pas **de** fromage.*
- *Elle boit de la bière.* → *Elle ne boit pas **de** bière.*

### 4. Article Omission

Articles are omitted in these cases:
- After *être* with professions: *Elle est **professeur**.* (not ~~une professeur~~)
- In enumerations and lists: *Hommes, femmes et enfants sont venus.*
- After *avec* or *sans* in certain expressions: *avec plaisir, sans problème*
- Fixed expressions: *avoir faim, avoir soif, faire peur*''',
);

// ─── 2. Nouns & Gender ──────────────────────────────────────────────────────

const _lessonNounsGender = GrammarLesson(
  id: 'nouns_gender',
  title: 'Les Noms et le Genre – Nouns and Gender',
  level: 1,
  topics: ['Masculine/feminine patterns', 'Plural formation', 'Irregular plurals', 'Noun-adjective agreement'],
  content: '''## Les Noms en Français

Every French noun has a gender: **masculine** or **feminine**. Learning the gender along with each noun is essential for correct sentence construction.

### Common Gender Patterns

**Typically masculine endings** (-age, -ment, -eau, -isme, -oir):
- *le from**age**, le bât**iment**, le bat**eau**, le tour**isme**, le mir**oir** *

**Typically feminine endings** (-tion, -sion, -té, -ure, -ette, -ence, -ance):
- *la na**tion**, la télévi**sion**, la liber**té**, la peint**ure**, la fourch**ette**, la pati**ence** *

**Common exceptions to memorize:**
- Masculine: *le squelette, le silence, le groupe, le musée, le lycée*
- Feminine: *la plage, la cage, la page, la mer, la peau, la main, la fin*

**Tricky pairs (same spelling, different meaning):**
| Masculine | Meaning | Feminine | Meaning |
|-----------|---------|----------|---------|
| *le livre* | the book | *la livre* | the pound |
| *le tour* | the tour/turn | *la tour* | the tower |
| *le mode* | the method | *la mode* | fashion |
| *le poste* | the post/job | *la poste* | the post office |

### Forming Plurals

**Regular:** Add **-s** → *le chat → les chats*

**Exceptions:**
- Nouns ending in *-eau, -au, -eu* → add **-x**: *le bateau → les bateaux*
- Nouns ending in *-al* → change to **-aux**: *le journal → les journaux* (except: *le festival → les festivals*)
- Nouns ending in *-s, -x, -z* → **no change**: *le bras → les bras, le nez → les nez*
- Nouns ending in *-ou* → add **-s** (except 7 with *-x*): *bijou, caillou, chou, genou, hibou, joujou, pou*
- Irregular plurals: *l'œil → les yeux, monsieur → messieurs, madame → mesdames*

### Agreement with Adjectives

Adjectives must agree with the noun in gender and number:
- *un petit garçon* → *une petite fille*
- *des petits garçons* → *des petites filles*''',
);

// ─── 3. Adjectives ──────────────────────────────────────────────────────────

const _lessonAdjectives = GrammarLesson(
  id: 'adjectives',
  title: 'Les Adjectifs – Agreement, Position & Comparison',
  level: 2,
  topics: ['Feminine formation', 'Plural formation', 'Position rules', 'Comparative', 'Superlative'],
  content: '''## Les Adjectifs en Français

French adjectives must agree in **gender** and **number** with the noun they modify. Their position relative to the noun also follows specific rules.

### 1. Forming the Feminine

| Masculine | Feminine | Rule |
|-----------|----------|------|
| *grand* | *grande* | Add **-e** |
| *gris* | *grise* | Consonant doubles + e (partially) |
| *heureux* | *heureuse* | -eux → -euse |
| *sportif* | *sportive* | -if → -ive |
| *bon* | *bonne* | -n → -nne |
| *blanc* | *blanche* | -c → -che |
| *étranger* | *étrangère* | -er → -ère |

**Irregular feminines (memorize these):**
- *beau → belle, nouveau → nouvelle, vieux → vieille*
- *fou → folle, mou → molle, doux → douce*
- *faux → fausse, roux → rousse, long → longue*
- *public → publique, turc → turque, grec → grecque*

### 2. Forming the Plural

| Singular | Plural | Rule |
|----------|--------|------|
| *grand / grande* | *grands / grandes* | Add **-s** |
| *beau* | *beaux* | -eau → -eaux |
| *-al* | *-aux* | *normal → normaux* (except: *banal → banals*) |

### 3. Position of Adjectives

**After the noun (most common)** – for descriptive, classifying adjectives:
- Color: *une robe **rouge***
- Shape: *une table **ronde***
- Nationality: *un film **français***
- Religion: *une église **catholique***
- Category: *une voiture **électrique***

**Before the noun (BAGS rule)** – Beauty, Age, Goodness, Size:
- ***Beau** paysage, **vieille** maison, **bonne** idée, **grande** ville*
- Also: *autre, jeune, joli, long, mauvais, nouveau, petit, premier*

### 4. Comparative (*le comparatif*)

| Type | Formula | Example |
|------|---------|---------|
| Superiority | plus + adj + que | *Elle est **plus grande que** moi.* |
| Inferiority | moins + adj + que | *Ce film est **moins intéressant que** l'autre.* |
| Equality | aussi + adj + que | *Il est **aussi intelligent que** son frère.* |

**Irregular comparatives:** *bon → meilleur, mauvais → pire*

### 5. Superlative (*le superlatif*)

Formula: **le/la/les + plus/moins + adjective (+ de)**

- *C'est **la plus belle** ville **de** France.*
- *C'est **le moins cher** des hôtels.*''',
);

// ─── 4. Present Tense ───────────────────────────────────────────────────────

const _lessonPresent = GrammarLesson(
  id: 'present_tense',
  title: 'Le Présent – The Present Tense',
  level: 1,
  topics: ['-ER verbs', '-IR verbs', '-RE verbs', 'Irregular patterns', 'Usage of présent'],
  content: '''## Le Présent de l'Indicatif

The present tense is the most fundamental tense in French. It expresses current actions, habitual activities, general truths, and can even convey the near future.

### 1. Regular -ER Verbs (1st Group)

Remove **-er** and add: **-e, -es, -e, -ons, -ez, -ent**

*Parler* (to speak):
| Pronoun | Conjugation |
|---------|-------------|
| je | parl**e** |
| tu | parl**es** |
| il/elle/on | parl**e** |
| nous | parl**ons** |
| vous | parl**ez** |
| ils/elles | parl**ent** |

**Spelling-change -ER verbs:**
- *Manger* → nous mange**ons** (keep soft 'g' sound)
- *Commencer* → nous commen**ç**ons (keep soft 'c' sound)
- *Appeler* → j'appe**ll**e, nous appe**l**ons
- *Acheter* → j'ach**è**te, nous ach**e**tons

### 2. Regular -IR Verbs (2nd Group)

Remove **-ir** and add: **-is, -is, -it, -issons, -issez, -issent**

*Finir* (to finish):
| Pronoun | Conjugation |
|---------|-------------|
| je | fin**is** |
| tu | fin**is** |
| il/elle/on | fin**it** |
| nous | fin**issons** |
| vous | fin**issez** |
| ils/elles | fin**issent** |

### 3. Regular -RE Verbs (3rd Group)

Remove **-re** and add: **-s, -s, - (nothing), -ons, -ez, -ent**

*Vendre* (to sell):
| Pronoun | Conjugation |
|---------|-------------|
| je | vend**s** |
| tu | vend**s** |
| il/elle/on | vend |
| nous | vend**ons** |
| vous | vend**ez** |
| ils/elles | vend**ent** |

### 4. Key Irregular Verbs

| Être | Avoir | Aller | Faire |
|------|-------|-------|-------|
| je suis | j'ai | je vais | je fais |
| tu es | tu as | tu vas | tu fais |
| il est | il a | il va | il fait |
| nous sommes | nous avons | nous allons | nous faisons |
| vous êtes | vous avez | vous allez | vous faites |
| ils sont | ils ont | ils vont | ils font |

### 5. Usage of the Present Tense

- **Current action:** *Je mange une pomme maintenant.*
- **Habitual:** *Je fais du sport tous les jours.*
- **General truth:** *La Terre tourne autour du Soleil.*
- **Near future:** *Je pars demain.* (I'm leaving tomorrow)
- **Since...:** *J'habite ici depuis trois ans.* (I've lived here for three years)
- **Si clauses (probability):** *Si j'ai le temps, je viendrai.*''',
);

// ─── 5. Past Tenses ─────────────────────────────────────────────────────────

const _lessonPastTenses = GrammarLesson(
  id: 'past_tenses',
  title: 'Le Passé Composé et l\'Imparfait',
  level: 2,
  topics: ['Passé composé formation', 'Imparfait formation', 'When to use each', 'Auxiliary choice', 'Agreement rules'],
  content: '''## Les Temps du Passé

French has two primary past tenses. Mastering the distinction between them is crucial for fluency.

### 1. Le Passé Composé – Completed Actions

**Formation:** *être/avoir* (present) + past participle

**With *avoir* (most verbs):**
- *J'**ai mangé** une pomme.* (I ate an apple)
- *Tu **as fini** ton travail.* (You finished your work)
- *Elle **a vendu** sa maison.* (She sold her house)

**With *être* (17 key verbs, DR MRS VANDERTRAMP):**
*Devenir, Revenir, Monter, Rester, Sortir, Venir, Aller, Naître, Descendre, Entrer, Rentrer, Tomber, Retourner, Arriver, Mourir, Partir, Passer*

- *Elle **est partie** à 8h.* (She left at 8)
- *Ils **sont allés** au cinéma.* (They went to the cinema)

**Être verbs require agreement** with the subject:
- *Elle est parti**e**.* / *Elles sont parti**es**.*

**Past participle agreement with avoir** – agrees with preceding direct object:
- *La pomme que j'ai mangé**e**.* (The apple that I ate)

### 2. L'Imparfait – Ongoing/Background

**Formation:** nous form → remove -ons → add:
*-ais, -ais, -ait, -ions, -iez, -aient*

- *Je march**ais** dans la rue.* (I was walking down the street)
- *Quand j'**étais** petit...* (When I was little...)

Only irregular stem: *être → ét-* (j'étais, tu étais...)

### 3. When to Use Each

| Passé Composé | Imparfait |
|---------------|-----------|
| Completed, one-time action | Ongoing, continuous action |
| Specific time reference | Background description |
| Interruption | The interrupted action |
| Series of completed events | Habitual/repeated past actions |

**Classic contrast example:**
*Je **dormais** (imparfait) quand le téléphone **a sonné** (passé composé).*
(I was sleeping when the phone rang.)

**Description vs. events:**
*Il **faisait** beau, le soleil **brillait**, les oiseaux **chantaient**. Soudain, un chien **est apparu**.*

### 4. Past Participle Formations

| Infinitive ending | Past participle | Examples |
|---|---|---|
| **-er** | **-é** | *manger → mangé, parler → parlé* |
| **-ir** | **-i** | *finir → fini, choisir → choisi* |
| **-re** | **-u** | *vendre → vendu, perdre → perdu* |
| Irregular | Various | *être → été, avoir → eu, faire → fait, prendre → pris, mettre → mis, voir → vu, lire → lu, écrire → écrit, dire → dit, savoir → su, pouvoir → pu, vouloir → voulu* |''',
);

// ─── 6. Future & Conditional ───────────────────────────────────────────────

const _lessonFutureConditional = GrammarLesson(
  id: 'future_conditional',
  title: 'Le Futur et le Conditionnel',
  level: 2,
  topics: ['Futur simple', 'Futur proche', 'Conditionnel présent', 'Si clauses', 'Usage differences'],
  content: '''## Le Futur et le Conditionnel

French has multiple ways to express future events, plus the conditional for hypothetical situations.

### 1. Le Futur Proche (Near Future)

**Formation:** *aller* (present) + infinitive

Used for immediate or certain future events:
- *Je **vais partir** dans cinq minutes.*
- *Nous **allons voir** ce film ce soir.*

Very common in spoken French for most future references.

### 2. Le Futur Simple (Simple Future)

**Formation:** infinitive + *-ai, -as, -a, -ons, -ez, -ont*

For -RE verbs, drop final *-e* first.

*Parler → je parler**ai**, tu parler**as**, il parler**a**, nous parler**ons**, vous parler**ez**, ils parler**ont** *

**Irregular future stems:**

| Verb | Stem | Full (je) |
|------|------|-----------|
| être | ser- | je serai |
| avoir | aur- | j'aurai |
| aller | ir- | j'irai |
| faire | fer- | je ferai |
| pouvoir | pourr- | je pourrai |
| vouloir | voudr- | je voudrai |
| devoir | devr- | je devrai |
| savoir | saur- | je saurai |
| venir | viendr- | je viendrai |
| voir | verr- | je verrai |
| falloir | faudr- | il faudra |
| pleuvoir | pleuvr- | il pleuvra |

**Usage:** formal statements, written French, distant/uncertain future, after *quand* and *lorsque* when the action is future:
- *Quand j'**aurai** le temps, je t'**appellerai**.*

### 3. Le Conditionnel Présent

**Formation:** same stem as futur simple + imparfait endings
(*-ais, -ais, -ait, -ions, -iez, -aient*)

- *Je **voudrais** un café.* (I would like a coffee)
- *Il **devrait** venir demain.* (He should come tomorrow)
- *J'**aimerais** voyager au Japon.* (I would like to travel to Japan)

### 4. Si Clauses (Conditional Sentences)

| Si clause | Main clause | Type |
|-----------|-------------|------|
| Si + présent | présent / futur / impératif | Probability |
| Si + imparfait | conditionnel présent | Hypothesis |
| Si + plus-que-parfait | conditionnel passé | Regret |

- *Si je **suis** libre, je **viendrai**.* (Present → Future)
- *Si j'**étais** riche, je **voyagerais**.* (Imparfait → Conditional)
- *Si j'**avais su**, je **serais venu**.* (Pluperfect → Conditional past)

**Key distinction:** Imparfait describes real past; conditionnel describes hypothetical present/future:
- *J'**étais** fatigué.* (I was tired – real past)
- *Je **serais** fatigué.* (I would be tired – hypothetical)''',
);

// ─── 7. Pronouns ────────────────────────────────────────────────────────────

const _lessonPronouns = GrammarLesson(
  id: 'pronouns',
  title: 'Les Pronoms – All Types of French Pronouns',
  level: 2,
  topics: ['Subject pronouns', 'Direct object pronouns', 'Indirect object pronouns', 'Y and En', 'Word order rules'],
  content: '''## Les Pronoms en Français

French uses pronouns extensively to avoid repetition. Mastering their position and order is essential for natural speech.

### 1. Subject Pronouns

| Person | French | Notes |
|--------|--------|-------|
| 1st sing. | **je / j'** | J' before vowel |
| 2nd sing. | **tu** | Informal you |
| 3rd sing. | **il / elle / on** | On = we/one/people |
| 1st pl. | **nous** | Formal we |
| 2nd pl. | **vous** | Plural or formal you |
| 3rd pl. | **ils / elles** | All-masculine or all-feminine |

### 2. Direct Object Pronouns (COD)

Replace the direct object (answers *qui?* or *quoi?*):
**me, te, le, la, nous, vous, les**

- *Je vois **Marie**.* → *Je **la** vois.*
- *Il mange **la pomme**.* → *Il **la** mange.*

In passé composé with avoir, the past participle agrees with preceding direct object pronoun:
- *J'ai mangé la pomme* → *Je l'ai mangé**e**.*

### 3. Indirect Object Pronouns (COI)

Replace *à* + person (answers *à qui?*):
**me, te, lui, nous, vous, leur**

- *Je parle **à Marie**.* → *Je **lui** parle.*
- *Il donne le livre **à ses enfants**.* → *Il **leur** donne le livre.*

**Note:** *lui* and *leur* only replace people; *à + thing* uses **y**.

### 4. Y and En

**Y** replaces:
- *à + place*: *Je vais **à Paris**.* → *J'**y** vais.*
- *à + thing*: *Je pense **à mes vacances**.* → *J'**y** pense.*

**En** replaces:
- *de + noun*: *Je viens **de Paris**.* → *J'**en** viens.*
- Partitive quantities: *Je voudrais **du pain**.* → *J'**en** voudrais.*
- *de + verb*: *Il a besoin **d'aide**.* → *Il **en** a besoin.*

### 5. Pronoun Order (the crucial rule!)

When multiple pronouns appear before the verb, use this exact order:

**me/te/se/nous/vous → le/la/les → lui/leur → y → en**

Examples:
- *Il **me le** donne.* (He gives it to me.)
- *Je **vous y** emmène.* (I'm taking you there.)
- *Elle **nous en** a parlé.* (She told us about it.)
- *Je **le lui** ai dit.* (I told it to him/her.)

**In the imperative (command) form:**
- Affirmative: *Donne-**le-moi**!* (verb-le/la/les-moi/toi-lui-nous-vous-leur)
- Negative: *Ne **me le** donne pas!* (normal order before verb)''',
);

// ─── 8. Prepositions ────────────────────────────────────────────────────────

const _lessonPrepositions = GrammarLesson(
  id: 'prepositions',
  title: 'Les Prépositions – Location, Direction & Usage',
  level: 2,
  topics: ['à and de', 'Location prepositions', 'Direction prepositions', 'Chez', 'Preposition + article contractions'],
  content: '''## Les Prépositions Françaises

Prepositions are small but powerful words that establish relationships between elements in a sentence.

### 1. À and De – The Workhorses

**À** (to, at, in):
- Destination: *Je vais **à** Paris.*
- Location: *Je suis **à** la maison.*
- Time: *Le train part **à** 8 heures.*
- Purpose: *Une machine **à** laver.*
- Characteristic: *Un homme **aux** yeux bleus.*

**De** (of, from, about):
- Origin: *Je viens **de** France.*
- Possession: *Le livre **de** Paul.*
- Content: *Une tasse **de** café.*
- Cause: *Mourir **de** faim.*

### 2. Contractions with À and De

| À + article | Result | Example |
|-------------|--------|---------|
| à + le | **au** | *Je vais au cinéma.* |
| à + les | **aux** | *Je parle aux étudiants.* |
| à + la | **à la** | *Je vais à la poste.* |
| à + l' | **à l'** | *Je vais à l'école.* |

| De + article | Result | Example |
|--------------|--------|---------|
| de + le | **du** | *Je viens du Canada.* |
| de + les | **des** | *C'est le livre des enfants.* |
| de + la | **de la** | *Je viens de la boulangerie.* |
| de + l' | **de l'** | *Je viens de l'hôpital.* |

### 3. Location Prepositions

| Preposition | Meaning | Example |
|-------------|---------|---------|
| **dans** | in, inside | *Les clés sont **dans** le sac.* |
| **sur** | on, on top of | *Le livre est **sur** la table.* |
| **sous** | under | *Le chat est **sous** le lit.* |
| **devant** | in front of | *La voiture est **devant** la maison.* |
| **derrière** | behind | *Le jardin est **derrière** la maison.* |
| **entre** | between | *Le cinéma est **entre** la gare et le parc.* |
| **à côté de** | next to | *La boulangerie est **à côté de** la pharmacie.* |
| **en face de** | opposite | *L'arrêt de bus est **en face de** l'école.* |
| **près de** | near | *J'habite **près de** la plage.* |
| **loin de** | far from | *L'aéroport est **loin de** la ville.* |
| **au-dessus de** | above | *Le miroir est **au-dessus** du lavabo.* |
| **au-dessous de** | below | *Il fait 5° **au-dessous** de zéro.* |

### 4. Chez – A Special Preposition

**Chez** means "at the place/home of" or "at the business of":
- *Je vais **chez** le médecin.* (to the doctor's)
- *Je suis **chez** moi.* (at home)
- ***Chez** les Français, on mange tard.* (Among the French)

### 5. Avec, Pour, Sans, Contre, Parmi

- **Avec** (with): *Je viens **avec** toi.*
- **Pour** (for): *C'est **pour** vous.*
- **Sans** (without): *Un café **sans** sucre.*
- **Contre** (against): *Je suis **contre** cette idée.*
- **Parmi** (among): *Il est **parmi** les meilleurs.*''',
);

// ─── 9. Negation ────────────────────────────────────────────────────────────

const _lessonNegation = GrammarLesson(
  id: 'negation',
  title: 'La Négation – Expressing Negation in French',
  level: 1,
  topics: ['ne...pas', 'ne...jamais', 'ne...plus', 'ne...rien', 'ne...personne', 'Word order'],
  content: '''## La Négation en Français

French negation uses two-part structures wrapping around the verb. In spoken French, *ne* is often dropped, but formal writing requires it.

### 1. Basic Negation: ne...pas

**Formation:** *ne* + verb + *pas*

- *Je **ne** parle **pas** anglais.* (I don't speak English)
- *Il **n'**est **pas** français.* (He is not French)

With compound tenses (*passé composé*), *ne...pas* wraps the auxiliary:
- *Je **n'ai pas** mangé.* (I did not eat / I haven't eaten)

With infinitives, *ne pas* precedes:
- *Je te dis de **ne pas** fumer.* (I'm telling you not to smoke)

### 2. Other Negation Forms

| Negation | Meaning | Example |
|----------|---------|---------|
| **ne...jamais** | never | *Je **ne** fume **jamais**.* |
| **ne...plus** | no longer / not anymore | *Il **ne** travaille **plus** ici.* |
| **ne...rien** | nothing | *Je **n**'ai **rien** vu.* |
| **ne...personne** | nobody | *Je **ne** connais **personne**.* |
| **ne...aucun(e)** | no / not any | *Je **n**'ai **aucune** idée.* |
| **ne...que** | only | *Je **n**'ai **que** deux euros.* |
| **ne...ni...ni** | neither...nor | *Je **ne** bois **ni** café **ni** thé.* |
| **ne...guère** | hardly / scarcely | *Il **ne** mange **guère**.* |

### 3. Pas Without Ne (Spoken French)

In informal spoken French, *ne* is frequently dropped:
- *Je sais **pas**.* (instead of Je ne sais pas)
- *C'est **pas** grave.* (instead of Ce n'est pas grave)

### 4. Negation Word Order

**Simple tense:** ne → verb → negation word
- *Je **ne** mange **jamais** de viande.*

**Compound tense:** ne → auxiliary → negation word → past participle
- *Je **n**'ai **rien** mangé.*
- *Je **ne** suis **pas** allé.* (être verb: negation wraps the auxiliary)

**Exception – personne:**
- *Je **n**'ai vu **personne**.* (personne after the past participle)

**Infinitives:**
- *Il est important de **ne pas** oublier.*
- *Je préfère **ne rien** dire.*

### 5. Rien and Personne as Subjects

When used as subjects, they precede the verb with *ne*:
- ***Rien n**'est impossible.* (Nothing is impossible)
- ***Personne n**'est parfait.* (Nobody is perfect)

### 6. Si – Answering Negative Questions

When disagreeing with a negative question, use **si** instead of *oui*:
- *Tu n'aimes pas le chocolat ?* — ***Si**, j'adore ça !*''',
);

// ─── 10. Questions ──────────────────────────────────────────────────────────

const _lessonQuestions = GrammarLesson(
  id: 'questions',
  title: 'Les Questions – How to Ask Questions',
  level: 1,
  topics: ['Intonation', 'Est-ce que', 'Inversion', 'Question words', 'DELF oral production'],
  content: '''## Poser des Questions en Français

French has three main ways to form questions, ranging from informal to formal. Mastering all three is essential for DELF exams.

### 1. Intonation (Informal)

Simply raise your voice at the end of a statement. Most common in conversation.

- *Tu viens ?* (You're coming?)
- *Il est français ?* (He's French?)
- *Vous avez des enfants ?* (Do you have children?)

**DELF note:** Acceptable in speaking sections but too informal for writing.

### 2. Est-ce que (Standard)

Insert **est-ce que** (or variant) before the statement. Works in all situations.

| Variant | Meaning |
|---------|---------|
| **est-ce que** | general yes/no |
| **est-ce qui** | when asking about the subject |
| **quand est-ce que** | when |
| **où est-ce que** | where |
| **qui est-ce que** | whom (object) |
| **qu'est-ce que** | what (object) |

- ***Est-ce que** tu viens ?*
- ***Qu'est-ce que** tu fais ?* (What are you doing?)
- ***Quand est-ce que** le train part ?* (When does the train leave?)
- ***Où est-ce que** tu habites ?* (Where do you live?)

### 3. Inversion (Formal)

Invert subject and verb, joined by a hyphen. Used in formal writing and official speech.

**Simple inversion:** verb-subject
- *Parlez-**vous** français ?*
- *Habite-**t**-**il** à Paris ?* (note the -t- for euphony)

**Compound inversion:** auxiliary-subject-past participle
- *Avez-**vous** vu ce film ?*
- *Sont-**ils** arrivés ?*

**With a noun subject,** keep the noun, add matching pronoun for inversion:
- ***Pierre** connaît-**il** la réponse ?*
- ***Les enfants** sont-**ils** prêts ?*

### 4. Question Words

| French | English | Example with inversion |
|--------|---------|------------------------|
| **qui** | who | *Qui est là ?* |
| **que / qu'** | what | *Que faites-vous ?* |
| **quoi** | what (after prep.) | *De quoi parles-tu ?* |
| **quand** | when | *Quand partez-vous ?* |
| **où** | where | *Où allez-vous ?* |
| **comment** | how | *Comment allez-vous ?* |
| **pourquoi** | why | *Pourquoi pleures-tu ?* |
| **combien (de)** | how much/many | *Combien coûte ce livre ?* |
| **quel(le)(s)** | which/what | *Quelle heure est-il ?* |

### 5. Quel – Which/What

Agrees with the noun it modifies:
- *Quel livre lis-tu ?* (m.s.)
- *Quelle robe préfères-tu ?* (f.s.)
- *Quels exercices sont difficiles ?* (m.pl.)
- *Quelles langues parles-tu ?* (f.pl.)

### 6. DELF Oral Production Tips

For DELF speaking tests, use **est-ce que** for reliability:
- *Est-ce que vous pouvez répéter ?* (Can you repeat?)
- *Qu'est-ce que ça veut dire ?* (What does that mean?)
- *Comment est-ce qu'on dit...en français ?* (How do you say...in French?)

Demonstrate range by mixing inversion in formal parts and intonation in conversation role-plays.''',
);

// ─── 11. Subjunctive ────────────────────────────────────────────────────────

const _lessonSubjunctive = GrammarLesson(
  id: 'subjunctive',
  title: 'Le Subjonctif – Formation and Usage',
  level: 3,
  topics: ['Formation', 'Triggers and expressions', 'Subjunctive vs indicative', 'Common mistakes'],
  content: '''## Le Subjonctif Présent

The subjunctive mood expresses subjectivity: doubt, emotion, necessity, desire, and uncertainty. It's used after certain conjunctions and expressions.

### 1. Formation

Start from the 3rd person plural (ils/elles) of the present tense, remove **-ent**, and add subjunctive endings:

**Endings:** *-e, -es, -e, -ions, -iez, -ent*

| Verb | ils/elles form | Stem | Subjunctive (que je...) |
|------|---------------|------|------------------------|
| parler | ils parl**ent** | parl- | parle, parles, parle, parlions, parliez, parlent |
| finir | ils finiss**ent** | finiss- | finisse, finisses, finisse, finissions, finissiez, finissent |
| prendre | ils prenn**ent** | prenn- | prenne, prennes, prenne, prenions, preniez, prennent |
| partir | ils part**ent** | part- | parte, partes, parte, partions, partiez, partent |

### 2. Irregular Subjunctive Stems

| Verb | Stem | (que) je/tu/il | (que) nous | (que) vous | (qu') ils |
|------|------|---------------|------------|------------|-----------|
| être | soi-/soy- | sois, sois, soit | soyons | soyez | soient |
| avoir | ai-/ay- | aie, aies, ait | ayons | ayez | aient |
| aller | aill-/all- | aille, ailles, aille | allions | alliez | aillent |
| faire | fass- | fasse, fasses, fasse | fassions | fassiez | fassent |
| pouvoir | puiss- | puisse, puisses, puisse | puissions | puissiez | puissent |
| savoir | sach- | sache, saches, sache | sachions | sachiez | sachent |
| vouloir | veuill-/voul- | veuille...veuille | voulions | vouliez | veuillent |
| falloir | faill- | (il) faille | — | — | — |
| pleuvoir | pleuv- | (il) pleuve | — | — | — |

### 3. When to Use the Subjunctive

**A. After expressions of necessity, emotion, doubt, desire:**

| Category | Trigger expressions |
|----------|-------------------|
| Necessity | *il faut que, il est nécessaire que, il est essentiel que* |
| Emotion | *je suis content que, je suis triste que, j'ai peur que* |
| Doubt | *je doute que, il est possible que, il n'est pas sûr que* |
| Desire/will | *je veux que, je souhaite que, j'aimerais que* |
| Opinion (negative) | *je ne pense pas que, je ne crois pas que* |

**B. After certain conjunctions:**

| Conjunction | Meaning | Example |
|-------------|---------|---------|
| *avant que* | before | *Pars avant qu'il ne pleuve.* |
| *bien que* | although | *Bien qu'il soit tard...* |
| *pour que* | so that | *Je t'explique pour que tu comprennes.* |
| *à moins que* | unless | *À moins que tu ne sois fatigué.* |
| *jusqu'à ce que* | until | *Attends jusqu'à ce que je revienne.* |
| *sans que* | without | *Il est parti sans que je le sache.* |

**C. After superlative expressions of uniqueness:**
- *C'est le meilleur film que j'**aie** jamais vu.*
- *C'est la seule personne qui **puisse** nous aider.*

### 4. When NOT to Use Subjunctive

After expressions of certainty, probability (affirmative):
- *Je pense qu'il **vient**.* (indicative, NOT subjunctive)
- *Je crois qu'elle **a** raison.*
- *Il est certain que tu **réussiras**.*
- *Il est probable qu'il **sera** en retard.*

But negated: *Je **ne** pense **pas** qu'il **vienne**.* (subjunctive!)

**After *après que* (after)** → use indicative, NOT subjunctive:
- *Après qu'il **est parti**, j'ai pleuré.* (indicative, passé composé)

### 5. DELF B1/B2 Tips

The subjunctive is expected at B1 level and above. Common B1 expressions to use:
- *Il faut que je **parte**.*
- *Je suis content(e) que tu **sois** là.*
- *Je ne pense pas que ce **soit** une bonne idée.*''',
);

// ─── 12. DELF Exam Tips ─────────────────────────────────────────────────────

const _lessonDelfTips = GrammarLesson(
  id: 'delf_tips',
  title: 'Conseils DELF – Exam Tips & Strategies',
  level: 3,
  topics: ['Common mistakes', 'Oral production tips', 'Written production tips', 'Time management', 'Scoring criteria'],
  content: '''## Conseils Pratiques pour le DELF

This lesson synthesises practical advice for succeeding in the DELF exams (A1 through B2), drawing on examiner expectations and common pitfalls.

### 1. Common Mistakes to Avoid

**Gender errors:**
- Every noun has a gender. Learn them together. Common traps: *le problème* (masc., not fem.), *la main* (fem., not masc.), *le silence* (masc.).
- Adjectives must agree: *une belle maison*, NOT ~~*un beau maison*~~.

**Accent confusion:**
- *a* (has) vs *à* (to/at)
- *ou* (or) vs *où* (where)
- *du* (some/of the) vs *dû* (had to, past participle of devoir)
- *sur* (on) vs *sûr* (sure)
- *la* (the) vs *là* (there)
- *a* vs *à* is the most frequently tested distinction in dictation exercises.

**Verb conjugation pitfalls:**
- *J'ai été* (I was/have been) NOT ~~*j'ai êtré*~~
- *Il a plu* (it rained) vs *Il a plus* (only used in *ne...plus*)
- *Je suis allé(e)* NOT ~~*j'ai allé*~~

**Auxiliary choice:**
- Learn the 17 *être* verbs (DR MRS VANDERTRAMP) and reflexive verbs (always être)
- *J'ai monté les escaliers* (transitive, avoir) vs *Je suis monté(e)* (intransitive, être)

**False friends:**
| French | Real meaning | Not this |
|--------|-------------|----------|
| *actuellement* | currently | actually (*en fait*) |
| *sensible* | sensitive | sensible (*raisonnable*) |
| *la librairie* | bookstore | library (*la bibliothèque*) |
| *assister à* | attend | assist (*aider*) |
| *passer un examen* | take an exam | pass (*réussir*) |

### 2. Oral Production Tips

**Production orale – monologue (5-10 min):**
- Structure your presentation: introduction, 2-3 points, conclusion
- B1: You get 10 min prep – use it to write KEYWORDS, not full sentences
- B2: Present your point of view, support with examples, give advantages/inconveniences
- Use connectors: *tout d'abord, ensuite, de plus, cependant, en conclusion*

**Production orale – entretien (interaction):**
- If you don't understand: *Pouvez-vous répéter, s'il vous plaît ?* or *Qu'est-ce que ça veut dire, ... ?*
- Never switch to English. Say: *Comment dit-on ... en français ?*
- Show engagement: *Ah oui, je suis d'accord !* or *C'est une question intéressante...*
- A2/B1: Prepare answers about yourself, family, hobbies, daily routine

**Scoring criteria for oral:**
- Lexical range (vocabulary variety)
- Grammatical accuracy
- Phonetic control (pronunciation, intonation)
- Coherence and fluency
- Ability to interact and respond

### 3. Written Production Tips

**Production écrite format (letter/email):**
- Always include: date, salutation, body, closing, signature
- Formal: *Cher Monsieur / Chère Madame, ... Cordialement / Respectueusement,*
- Informal: *Salut / Cher Paul, ... Amitiés / À bientôt,*

**For the essay/argument (B1/B2):**
- Plan before writing (5 min): outline thesis, 2 arguments for, 1 counter-argument, conclusion
- B1: 160-180 words; B2: 250+ words
- Use paragraphs: one idea per paragraph
- Enrich with connectors: *par conséquent, néanmoins, en revanche, d'une part...d'autre part*

**Markers are looking for:**
- Task completion (did you cover all required points?)
- Cohesion and coherence (is there a logical flow?)
- Lexical range and spelling
- Grammatical accuracy

### 4. Time Management

| DELF Level | Oral prep | Oral exam | Written |
|------------|----------|-----------|---------|
| A1 | none | 5-7 min | 30 min |
| A2 | none | 6-8 min | 45 min |
| B1 | 10 min | 10-15 min | 45 min |
| B2 | 30 min | 20 min | 60 min |

**B1/B2 Listening:** Use the pause to read the questions FIRST so you know what to listen for.

**Reading comprehension:** Read questions first, then scan the text. Don't get stuck on unknown words.

### 5. DELF Level-Specific Focus

**DELF A1:** Survival French. Focus on: self-introductions, numbers, prices, time, basic descriptions. You can make mistakes but you must be understood.

**DELF A2:** Everyday situations. Focus on: past tense (passé composé), making requests, expressing opinions simply, talking about future plans.

**DELF B1:** Independent user. Focus on: expressing and defending opinions, handling unexpected situations, subjunctive in basic triggers, using connectors and varied structures.

**DELF B2:** Advanced independent. Focus on: presenting structured arguments, subjunctive thoroughly, complex sentence structures, formal register for letters and debates.

### 6. Key Expressions for the Exam

**Giving opinions:**
- *À mon avis...* (In my opinion)
- *Je pense que... / Je crois que...*
- *Il me semble que...* (It seems to me that)

**Agreeing / Disagreeing:**
- *Je suis d'accord avec vous.*
- *Je ne suis pas tout à fait d'accord.* (I don't entirely agree)
- *Vous avez raison, mais...*

**Asking for clarification:**
- *Excusez-moi, je n'ai pas compris.*
- *Pouvez-vous répéter plus lentement ?*
- *Ça veut dire quoi, ... ?*

**Hesitation fillers (sound more French):**
- *Euh... alors...* (Um... so...)
- *C'est-à-dire...* (That is to say...)
- *Voyons...* (Let's see...)''',
);

// ─── Master list ────────────────────────────────────────────────────────────

const List<GrammarLesson> grammarLessons = [
  _lessonArticles,
  _lessonNounsGender,
  _lessonAdjectives,
  _lessonPresent,
  _lessonPastTenses,
  _lessonFutureConditional,
  _lessonPronouns,
  _lessonPrepositions,
  _lessonNegation,
  _lessonQuestions,
  _lessonSubjunctive,
  _lessonDelfTips,
];

// ─── Helpers ────────────────────────────────────────────────────────────────

/// Look up a grammar lesson by ID.
GrammarLesson? lookupLesson(String id) {
  for (final lesson in grammarLessons) {
    if (lesson.id == id) return lesson;
  }
  return null;
}

/// Get lessons filtered by difficulty level.
List<GrammarLesson> lessonsByLevel(int level) {
  return grammarLessons.where((l) => l.level == level).toList();
}

int get lessonCount => grammarLessons.length;
