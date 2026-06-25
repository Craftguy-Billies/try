/// Comprehensive French vocabulary dataset for DELF preparation and general learning.
/// All words use real French with proper accents and are organized by category and CEFR level.

class VocabWord {
  final String french;
  final String english;
  final String partOfSpeech;
  final String category;
  final int difficulty; // 1=A1, 2=A2, 3=B1, 4=B2, 5=C1
  final String? example;

  const VocabWord({
    required this.french,
    required this.english,
    required this.partOfSpeech,
    required this.category,
    required this.difficulty,
    this.example,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabWord &&
          french == other.french &&
          english == other.english &&
          partOfSpeech == other.partOfSpeech &&
          category == other.category;

  @override
  int get hashCode => Object.hash(french, english, partOfSpeech, category);
}

// ─── Category 1: Greetings & Politeness ─────────────────────────────────────

const _greetingsPoliteness = [
  VocabWord(french: 'bonjour', english: 'hello / good morning', partOfSpeech: 'interjection', category: 'Greetings & Politeness', difficulty: 1, example: 'Bonjour, comment allez-vous ?'),
  VocabWord(french: 'salut', english: 'hi / bye (informal)', partOfSpeech: 'interjection', category: 'Greetings & Politeness', difficulty: 1, example: 'Salut ! Ça va ?'),
  VocabWord(french: 'merci', english: 'thank you', partOfSpeech: 'interjection', category: 'Greetings & Politeness', difficulty: 1, example: 'Merci beaucoup pour votre aide.'),
  VocabWord(french: 'au revoir', english: 'goodbye', partOfSpeech: 'phrase', category: 'Greetings & Politeness', difficulty: 1, example: 'Au revoir et bonne journée !'),
  VocabWord(french: "s'il vous plaît", english: 'please (formal)', partOfSpeech: 'phrase', category: 'Greetings & Politeness', difficulty: 1, example: "Un café, s'il vous plaît."),
  VocabWord(french: "s'il te plaît", english: 'please (informal)', partOfSpeech: 'phrase', category: 'Greetings & Politeness', difficulty: 1, example: "Passe-moi le sel, s'il te plaît."),
  VocabWord(french: 'pardon', english: 'sorry / excuse me', partOfSpeech: 'interjection', category: 'Greetings & Politeness', difficulty: 1, example: 'Pardon, je suis en retard.'),
  VocabWord(french: 'de rien', english: "you're welcome", partOfSpeech: 'phrase', category: 'Greetings & Politeness', difficulty: 1, example: '— Merci ! — De rien !'),
  VocabWord(french: 'enchanté', english: 'nice to meet you', partOfSpeech: 'adjective', category: 'Greetings & Politeness', difficulty: 1, example: 'Enchanté de faire votre connaissance.'),
  VocabWord(french: 'bonne journée', english: 'have a good day', partOfSpeech: 'phrase', category: 'Greetings & Politeness', difficulty: 1, example: 'Merci, bonne journée !'),
  VocabWord(french: 'bonsoir', english: 'good evening', partOfSpeech: 'interjection', category: 'Greetings & Politeness', difficulty: 1, example: 'Bonsoir, tout le monde.'),
  VocabWord(french: 'bonne nuit', english: 'good night', partOfSpeech: 'phrase', category: 'Greetings & Politeness', difficulty: 1, example: 'Bonne nuit, dors bien.'),
  VocabWord(french: 'à bientôt', english: 'see you soon', partOfSpeech: 'phrase', category: 'Greetings & Politeness', difficulty: 1, example: 'À bientôt, j\'espère !'),
  VocabWord(french: 'ça va', english: "how's it going / I'm fine", partOfSpeech: 'phrase', category: 'Greetings & Politeness', difficulty: 1, example: 'Salut, ça va ? — Oui, ça va.'),
  VocabWord(french: 'comment allez-vous', english: 'how are you (formal)', partOfSpeech: 'phrase', category: 'Greetings & Politeness', difficulty: 1, example: 'Bonjour, comment allez-vous ?'),
  VocabWord(french: "je m'appelle", english: 'my name is', partOfSpeech: 'phrase', category: 'Greetings & Politeness', difficulty: 1, example: 'Je m\'appelle Marie.'),
  VocabWord(french: 'excusez-moi', english: 'excuse me (formal)', partOfSpeech: 'phrase', category: 'Greetings & Politeness', difficulty: 1, example: 'Excusez-moi, où est la gare ?'),
  VocabWord(french: 'félicitations', english: 'congratulations', partOfSpeech: 'interjection', category: 'Greetings & Politeness', difficulty: 2, example: 'Félicitations pour ton diplôme !'),
  VocabWord(french: 'bienvenue', english: 'welcome', partOfSpeech: 'interjection', category: 'Greetings & Politeness', difficulty: 1, example: 'Bienvenue chez nous !'),
  VocabWord(french: 'bon appétit', english: 'enjoy your meal', partOfSpeech: 'phrase', category: 'Greetings & Politeness', difficulty: 1, example: 'Voilà le dîner. Bon appétit !'),
];

// ─── Category 2: Family & People ────────────────────────────────────────────

const _familyPeople = [
  VocabWord(french: 'la mère', english: 'mother', partOfSpeech: 'noun (f)', category: 'Family & People', difficulty: 1, example: 'Ma mère est médecin.'),
  VocabWord(french: 'le père', english: 'father', partOfSpeech: 'noun (m)', category: 'Family & People', difficulty: 1, example: 'Mon père travaille à Paris.'),
  VocabWord(french: 'la sœur', english: 'sister', partOfSpeech: 'noun (f)', category: 'Family & People', difficulty: 1, example: "J'ai une sœur et deux frères."),
  VocabWord(french: 'le frère', english: 'brother', partOfSpeech: 'noun (m)', category: 'Family & People', difficulty: 1, example: 'Mon frère aime le football.'),
  VocabWord(french: 'la fille', english: 'daughter / girl', partOfSpeech: 'noun (f)', category: 'Family & People', difficulty: 1, example: 'La fille joue dans le jardin.'),
  VocabWord(french: 'le fils', english: 'son', partOfSpeech: 'noun (m)', category: 'Family & People', difficulty: 1, example: 'Son fils étudie à l\'université.'),
  VocabWord(french: "l'enfant", english: 'child', partOfSpeech: 'noun (m/f)', category: 'Family & People', difficulty: 1, example: 'Les enfants aiment le chocolat.'),
  VocabWord(french: "l'homme", english: 'man', partOfSpeech: 'noun (m)', category: 'Family & People', difficulty: 1, example: "L'homme porte un chapeau."),
  VocabWord(french: 'la femme', english: 'woman / wife', partOfSpeech: 'noun (f)', category: 'Family & People', difficulty: 1, example: 'Cette femme parle français.'),
  VocabWord(french: 'le mari', english: 'husband', partOfSpeech: 'noun (m)', category: 'Family & People', difficulty: 1, example: 'Son mari est architecte.'),
  VocabWord(french: "l'ami / l'amie", english: 'friend', partOfSpeech: 'noun', category: 'Family & People', difficulty: 1, example: 'Mon ami habite à Lyon.'),
  VocabWord(french: 'le voisin / la voisine', english: 'neighbor', partOfSpeech: 'noun', category: 'Family & People', difficulty: 1, example: 'Les voisins sont très gentils.'),
  VocabWord(french: 'le bébé', english: 'baby', partOfSpeech: 'noun (m)', category: 'Family & People', difficulty: 1, example: 'Le bébé dort paisiblement.'),
  VocabWord(french: 'la grand-mère', english: 'grandmother', partOfSpeech: 'noun (f)', category: 'Family & People', difficulty: 1, example: 'Ma grand-mère fait de bons gâteaux.'),
  VocabWord(french: 'le grand-père', english: 'grandfather', partOfSpeech: 'noun (m)', category: 'Family & People', difficulty: 1, example: 'Mon grand-père raconte des histoires.'),
  VocabWord(french: 'les parents', english: 'parents', partOfSpeech: 'noun (m pl)', category: 'Family & People', difficulty: 1, example: "Mes parents habitent en province."),
  VocabWord(french: 'la tante', english: 'aunt', partOfSpeech: 'noun (f)', category: 'Family & People', difficulty: 2, example: "Ma tante vit au Canada."),
  VocabWord(french: "l'oncle", english: 'uncle', partOfSpeech: 'noun (m)', category: 'Family & People', difficulty: 2, example: "Mon oncle est professeur."),
  VocabWord(french: 'le cousin / la cousine', english: 'cousin', partOfSpeech: 'noun', category: 'Family & People', difficulty: 2, example: 'Ma cousine parle trois langues.'),
  VocabWord(french: 'le neveu', english: 'nephew', partOfSpeech: 'noun (m)', category: 'Family & People', difficulty: 2, example: 'Mon neveu a dix ans.'),
  VocabWord(french: 'la nièce', english: 'niece', partOfSpeech: 'noun (f)', category: 'Family & People', difficulty: 2, example: 'Ma nièce adore la danse.'),
];

// ─── Category 3: Food & Drink ───────────────────────────────────────────────

const _foodDrink = [
  VocabWord(french: 'le pain', english: 'bread', partOfSpeech: 'noun (m)', category: 'Food & Drink', difficulty: 1, example: 'Je voudrais du pain, s\'il vous plaît.'),
  VocabWord(french: "l'eau", english: 'water', partOfSpeech: 'noun (f)', category: 'Food & Drink', difficulty: 1, example: 'Un verre d\'eau, s\'il vous plaît.'),
  VocabWord(french: 'le vin', english: 'wine', partOfSpeech: 'noun (m)', category: 'Food & Drink', difficulty: 1, example: 'Ce vin rouge est excellent.'),
  VocabWord(french: 'le fromage', english: 'cheese', partOfSpeech: 'noun (m)', category: 'Food & Drink', difficulty: 1, example: 'La France produit beaucoup de fromages.'),
  VocabWord(french: 'le lait', english: 'milk', partOfSpeech: 'noun (m)', category: 'Food & Drink', difficulty: 1, example: 'Je prends du lait dans mon café.'),
  VocabWord(french: 'le café', english: 'coffee', partOfSpeech: 'noun (m)', category: 'Food & Drink', difficulty: 1, example: 'Un café noir, s\'il vous plaît.'),
  VocabWord(french: 'le thé', english: 'tea', partOfSpeech: 'noun (m)', category: 'Food & Drink', difficulty: 1, example: 'Elle boit du thé tous les matins.'),
  VocabWord(french: 'la viande', english: 'meat', partOfSpeech: 'noun (f)', category: 'Food & Drink', difficulty: 1, example: 'Il ne mange pas de viande.'),
  VocabWord(french: 'le poisson', english: 'fish', partOfSpeech: 'noun (m)', category: 'Food & Drink', difficulty: 1, example: 'Le poisson est bon pour la santé.'),
  VocabWord(french: 'le riz', english: 'rice', partOfSpeech: 'noun (m)', category: 'Food & Drink', difficulty: 1, example: 'Le riz accompagne bien le curry.'),
  VocabWord(french: 'les pâtes', english: 'pasta', partOfSpeech: 'noun (f pl)', category: 'Food & Drink', difficulty: 1, example: 'Les enfants adorent les pâtes.'),
  VocabWord(french: 'la salade', english: 'salad', partOfSpeech: 'noun (f)', category: 'Food & Drink', difficulty: 1, example: 'Je prends une salade verte en entrée.'),
  VocabWord(french: 'le beurre', english: 'butter', partOfSpeech: 'noun (m)', category: 'Food & Drink', difficulty: 1, example: 'Mettez du beurre sur le pain.'),
  VocabWord(french: 'le sucre', english: 'sugar', partOfSpeech: 'noun (m)', category: 'Food & Drink', difficulty: 1, example: 'Voulez-vous du sucre dans votre café ?'),
  VocabWord(french: 'le chocolat', english: 'chocolate', partOfSpeech: 'noun (m)', category: 'Food & Drink', difficulty: 1, example: 'Le chocolat suisse est délicieux.'),
  VocabWord(french: 'le jus', english: 'juice', partOfSpeech: 'noun (m)', category: 'Food & Drink', difficulty: 1, example: 'Un jus d\'orange frais, s\'il vous plaît.'),
  VocabWord(french: 'la bière', english: 'beer', partOfSpeech: 'noun (f)', category: 'Food & Drink', difficulty: 1, example: 'Une bière blonde, s\'il vous plaît.'),
  VocabWord(french: 'le gâteau', english: 'cake', partOfSpeech: 'noun (m)', category: 'Food & Drink', difficulty: 1, example: 'Le gâteau au chocolat est son préféré.'),
  VocabWord(french: 'la soupe', english: 'soup', partOfSpeech: 'noun (f)', category: 'Food & Drink', difficulty: 1, example: 'La soupe à l\'oignon est un plat français.'),
  VocabWord(french: "l'œuf", english: 'egg', partOfSpeech: 'noun (m)', category: 'Food & Drink', difficulty: 1, example: 'Je prends deux œufs au petit-déjeuner.'),
  VocabWord(french: 'la pomme', english: 'apple', partOfSpeech: 'noun (f)', category: 'Food & Drink', difficulty: 1, example: 'Une pomme par jour éloigne le médecin.'),
  VocabWord(french: 'la banane', english: 'banana', partOfSpeech: 'noun (f)', category: 'Food & Drink', difficulty: 1, example: 'La banane est riche en potassium.'),
  VocabWord(french: 'la fraise', english: 'strawberry', partOfSpeech: 'noun (f)', category: 'Food & Drink', difficulty: 2, example: 'Les fraises sont délicieuses en été.'),
  VocabWord(french: 'le poulet', english: 'chicken', partOfSpeech: 'noun (m)', category: 'Food & Drink', difficulty: 1, example: 'Le poulet rôti est un plat dominical.'),
  VocabWord(french: 'la crêpe', english: 'crepe / thin pancake', partOfSpeech: 'noun (f)', category: 'Food & Drink', difficulty: 2, example: 'Les crêpes bretonnes sont célèbres.'),
];

// ─── Category 4: Travel & Transport ─────────────────────────────────────────

const _travelTransport = [
  VocabWord(french: 'la voiture', english: 'car', partOfSpeech: 'noun (f)', category: 'Travel & Transport', difficulty: 1, example: 'Ma voiture est garée dans la rue.'),
  VocabWord(french: 'le train', english: 'train', partOfSpeech: 'noun (m)', category: 'Travel & Transport', difficulty: 1, example: 'Le train part à huit heures.'),
  VocabWord(french: "l'avion", english: 'airplane', partOfSpeech: 'noun (m)', category: 'Travel & Transport', difficulty: 1, example: "L'avion décolle dans une heure."),
  VocabWord(french: 'le bus', english: 'bus', partOfSpeech: 'noun (m)', category: 'Travel & Transport', difficulty: 1, example: 'Je prends le bus pour aller au travail.'),
  VocabWord(french: 'le métro', english: 'subway / metro', partOfSpeech: 'noun (m)', category: 'Travel & Transport', difficulty: 1, example: 'Le métro de Paris est très pratique.'),
  VocabWord(french: 'le taxi', english: 'taxi', partOfSpeech: 'noun (m)', category: 'Travel & Transport', difficulty: 1, example: 'Prenons un taxi, il pleut.'),
  VocabWord(french: 'le vélo', english: 'bicycle', partOfSpeech: 'noun (m)', category: 'Travel & Transport', difficulty: 1, example: 'Je vais au travail à vélo.'),
  VocabWord(french: "l'aéroport", english: 'airport', partOfSpeech: 'noun (m)', category: 'Travel & Transport', difficulty: 1, example: "L'aéroport est loin du centre-ville."),
  VocabWord(french: 'la gare', english: 'train station', partOfSpeech: 'noun (f)', category: 'Travel & Transport', difficulty: 1, example: 'La gare est à cinq minutes à pied.'),
  VocabWord(french: 'le billet', english: 'ticket', partOfSpeech: 'noun (m)', category: 'Travel & Transport', difficulty: 1, example: 'J\'ai acheté un billet aller-retour.'),
  VocabWord(french: 'la valise', english: 'suitcase', partOfSpeech: 'noun (f)', category: 'Travel & Transport', difficulty: 1, example: 'Ma valise est trop lourde.'),
  VocabWord(french: "l'hôtel", english: 'hotel', partOfSpeech: 'noun (m)', category: 'Travel & Transport', difficulty: 1, example: "L'hôtel est situé près de la plage."),
  VocabWord(french: 'la plage', english: 'beach', partOfSpeech: 'noun (f)', category: 'Travel & Transport', difficulty: 1, example: 'Nous allons à la plage cet après-midi.'),
  VocabWord(french: 'la montagne', english: 'mountain', partOfSpeech: 'noun (f)', category: 'Travel & Transport', difficulty: 1, example: 'Les Alpes sont des montagnes magnifiques.'),
  VocabWord(french: 'la route', english: 'road', partOfSpeech: 'noun (f)', category: 'Travel & Transport', difficulty: 1, example: 'La route est fermée à cause de la neige.'),
  VocabWord(french: 'la rue', english: 'street', partOfSpeech: 'noun (f)', category: 'Travel & Transport', difficulty: 1, example: 'La rue est très animée le soir.'),
  VocabWord(french: 'le pont', english: 'bridge', partOfSpeech: 'noun (m)', category: 'Travel & Transport', difficulty: 1, example: 'Le pont Alexandre-III est magnifique.'),
  VocabWord(french: 'le musée', english: 'museum', partOfSpeech: 'noun (m)', category: 'Travel & Transport', difficulty: 1, example: 'Le Louvre est un musée célèbre.'),
  VocabWord(french: 'le parc', english: 'park', partOfSpeech: 'noun (m)', category: 'Travel & Transport', difficulty: 1, example: 'Je fais une promenade dans le parc.'),
  VocabWord(french: 'le ticket', english: 'ticket (metro/bus)', partOfSpeech: 'noun (m)', category: 'Travel & Transport', difficulty: 1, example: 'Achète un ticket de métro.'),
  VocabWord(french: 'le passeport', english: 'passport', partOfSpeech: 'noun (m)', category: 'Travel & Transport', difficulty: 2, example: "N'oubliez pas votre passeport !"),
  VocabWord(french: 'la réservation', english: 'reservation / booking', partOfSpeech: 'noun (f)', category: 'Travel & Transport', difficulty: 2, example: "J'ai fait une réservation pour deux nuits."),
  VocabWord(french: 'le voyage', english: 'trip / journey', partOfSpeech: 'noun (m)', category: 'Travel & Transport', difficulty: 1, example: 'Bon voyage !'),
  VocabWord(french: 'la carte', english: 'map', partOfSpeech: 'noun (f)', category: 'Travel & Transport', difficulty: 2, example: 'Vous avez une carte de la ville ?'),
];

// ─── Category 5: Home & Living ──────────────────────────────────────────────

const _homeLiving = [
  VocabWord(french: 'la maison', english: 'house', partOfSpeech: 'noun (f)', category: 'Home & Living', difficulty: 1, example: 'La maison a un grand jardin.'),
  VocabWord(french: 'la chambre', english: 'bedroom', partOfSpeech: 'noun (f)', category: 'Home & Living', difficulty: 1, example: 'Ma chambre est au premier étage.'),
  VocabWord(french: 'la cuisine', english: 'kitchen', partOfSpeech: 'noun (f)', category: 'Home & Living', difficulty: 1, example: 'La cuisine est bien équipée.'),
  VocabWord(french: 'la salle de bain', english: 'bathroom', partOfSpeech: 'noun (f)', category: 'Home & Living', difficulty: 1, example: 'La salle de bain est à gauche.'),
  VocabWord(french: 'la porte', english: 'door', partOfSpeech: 'noun (f)', category: 'Home & Living', difficulty: 1, example: 'Fermez la porte, s\'il vous plaît.'),
  VocabWord(french: 'la fenêtre', english: 'window', partOfSpeech: 'noun (f)', category: 'Home & Living', difficulty: 1, example: 'Ouvre la fenêtre, il fait chaud.'),
  VocabWord(french: 'la table', english: 'table', partOfSpeech: 'noun (f)', category: 'Home & Living', difficulty: 1, example: 'La table est mise pour le dîner.'),
  VocabWord(french: 'la chaise', english: 'chair', partOfSpeech: 'noun (f)', category: 'Home & Living', difficulty: 1, example: 'Assieds-toi sur la chaise.'),
  VocabWord(french: 'le lit', english: 'bed', partOfSpeech: 'noun (m)', category: 'Home & Living', difficulty: 1, example: 'Le lit est très confortable.'),
  VocabWord(french: 'le canapé', english: 'sofa / couch', partOfSpeech: 'noun (m)', category: 'Home & Living', difficulty: 1, example: 'Je lis un livre sur le canapé.'),
  VocabWord(french: 'le miroir', english: 'mirror', partOfSpeech: 'noun (m)', category: 'Home & Living', difficulty: 1, example: 'Elle se regarde dans le miroir.'),
  VocabWord(french: 'la lampe', english: 'lamp', partOfSpeech: 'noun (f)', category: 'Home & Living', difficulty: 1, example: 'Allume la lampe, il fait sombre.'),
  VocabWord(french: 'le tapis', english: 'rug / carpet', partOfSpeech: 'noun (m)', category: 'Home & Living', difficulty: 1, example: 'Le tapis est rouge et bleu.'),
  VocabWord(french: "l'armoire", english: 'wardrobe / cupboard', partOfSpeech: 'noun (f)', category: 'Home & Living', difficulty: 2, example: "Mes vêtements sont dans l'armoire."),
  VocabWord(french: 'le jardin', english: 'garden', partOfSpeech: 'noun (m)', category: 'Home & Living', difficulty: 1, example: 'Les enfants jouent dans le jardin.'),
  VocabWord(french: 'le salon', english: 'living room', partOfSpeech: 'noun (m)', category: 'Home & Living', difficulty: 1, example: 'Le salon donne sur la rue.'),
  VocabWord(french: "l'escalier", english: 'stairs', partOfSpeech: 'noun (m)', category: 'Home & Living', difficulty: 1, example: "Prenez l'escalier à droite."),
  VocabWord(french: 'le toit', english: 'roof', partOfSpeech: 'noun (m)', category: 'Home & Living', difficulty: 2, example: 'Le toit est en ardoise.'),
  VocabWord(french: 'le mur', english: 'wall', partOfSpeech: 'noun (m)', category: 'Home & Living', difficulty: 1, example: 'Les murs sont blancs.'),
  VocabWord(french: 'le sol', english: 'floor / ground', partOfSpeech: 'noun (m)', category: 'Home & Living', difficulty: 2, example: 'Le sol est en bois.'),
];

// ─── Category 6: Colors & Descriptions ──────────────────────────────────────

const _colorsDescriptions = [
  VocabWord(french: 'rouge', english: 'red', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'La rose est rouge.'),
  VocabWord(french: 'bleu / bleue', english: 'blue', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'Le ciel est bleu.'),
  VocabWord(french: 'vert / verte', english: 'green', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'La pelouse est verte.'),
  VocabWord(french: 'jaune', english: 'yellow', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'Le soleil est jaune.'),
  VocabWord(french: 'noir / noire', english: 'black', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'Elle porte une robe noire.'),
  VocabWord(french: 'blanc / blanche', english: 'white', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'La neige est blanche.'),
  VocabWord(french: 'grand / grande', english: 'big / tall', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'C\'est une grande ville.'),
  VocabWord(french: 'petit / petite', english: 'small / little', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'Le petit chat est mignon.'),
  VocabWord(french: 'beau / belle', english: 'beautiful / handsome', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'Quelle belle journée !'),
  VocabWord(french: 'bon / bonne', english: 'good', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'Ce repas est très bon.'),
  VocabWord(french: 'mauvais / mauvaise', english: 'bad', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'Le temps est mauvais aujourd\'hui.'),
  VocabWord(french: 'nouveau / nouvelle', english: 'new', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'J\'ai un nouvel ordinateur.'),
  VocabWord(french: 'vieux / vieille', english: 'old', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'C\'est un vieux quartier.'),
  VocabWord(french: 'jeune', english: 'young', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'Elle est très jeune.'),
  VocabWord(french: 'facile', english: 'easy', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'Ce test est facile.'),
  VocabWord(french: 'difficile', english: 'difficult', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'La grammaire française est difficile.'),
  VocabWord(french: 'chaud / chaude', english: 'hot / warm', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: "L'été est très chaud cette année."),
  VocabWord(french: 'froid / froide', english: 'cold', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: "L'hiver est froid au Canada."),
  VocabWord(french: 'heureux / heureuse', english: 'happy', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'Je suis heureux de vous voir.'),
  VocabWord(french: 'triste', english: 'sad', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'Ne sois pas triste, tout va bien.'),
  VocabWord(french: 'orange', english: 'orange', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 1, example: 'Les carottes sont orange.'),
  VocabWord(french: 'gris / grise', english: 'gray', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 2, example: 'Le ciel est gris aujourd\'hui.'),
  VocabWord(french: 'violet / violette', english: 'purple', partOfSpeech: 'adjective', category: 'Colors & Descriptions', difficulty: 2, example: 'La lavande est violette.'),
];

// ─── Category 7: Daily Life ─────────────────────────────────────────────────

const _dailyLife = [
  VocabWord(french: 'le travail', english: 'work / job', partOfSpeech: 'noun (m)', category: 'Daily Life', difficulty: 1, example: 'Je vais au travail en bus.'),
  VocabWord(french: "l'école", english: 'school', partOfSpeech: 'noun (f)', category: 'Daily Life', difficulty: 1, example: "L'école commence à huit heures."),
  VocabWord(french: 'le temps', english: 'time / weather', partOfSpeech: 'noun (m)', category: 'Daily Life', difficulty: 1, example: 'Je n\'ai pas le temps.'),
  VocabWord(french: "l'argent", english: 'money', partOfSpeech: 'noun (m)', category: 'Daily Life', difficulty: 1, example: "L'argent ne fait pas le bonheur."),
  VocabWord(french: 'le téléphone', english: 'telephone', partOfSpeech: 'noun (m)', category: 'Daily Life', difficulty: 1, example: 'Mon téléphone sonne.'),
  VocabWord(french: "l'ordinateur", english: 'computer', partOfSpeech: 'noun (m)', category: 'Daily Life', difficulty: 1, example: 'Je travaille sur mon ordinateur.'),
  VocabWord(french: 'le livre', english: 'book', partOfSpeech: 'noun (m)', category: 'Daily Life', difficulty: 1, example: 'Ce livre est passionnant.'),
  VocabWord(french: 'le journal', english: 'newspaper', partOfSpeech: 'noun (m)', category: 'Daily Life', difficulty: 1, example: 'Il lit le journal tous les matins.'),
  VocabWord(french: 'la clé', english: 'key', partOfSpeech: 'noun (f)', category: 'Daily Life', difficulty: 1, example: "J'ai perdu mes clés."),
  VocabWord(french: 'le sac', english: 'bag', partOfSpeech: 'noun (m)', category: 'Daily Life', difficulty: 1, example: 'Elle a un sac très élégant.'),
  VocabWord(french: 'les vêtements', english: 'clothes', partOfSpeech: 'noun (m pl)', category: 'Daily Life', difficulty: 1, example: 'Ses vêtements sont à la mode.'),
  VocabWord(french: 'la musique', english: 'music', partOfSpeech: 'noun (f)', category: 'Daily Life', difficulty: 1, example: "J'écoute de la musique classique."),
  VocabWord(french: 'le film', english: 'movie / film', partOfSpeech: 'noun (m)', category: 'Daily Life', difficulty: 1, example: 'Ce film a gagné plusieurs prix.'),
  VocabWord(french: 'le sport', english: 'sport', partOfSpeech: 'noun (m)', category: 'Daily Life', difficulty: 1, example: 'Le sport est bon pour la santé.'),
  VocabWord(french: 'le jeu', english: 'game', partOfSpeech: 'noun (m)', category: 'Daily Life', difficulty: 1, example: 'Les enfants jouent à un jeu.'),
  VocabWord(french: 'le petit-déjeuner', english: 'breakfast', partOfSpeech: 'noun (m)', category: 'Daily Life', difficulty: 1, example: 'Le petit-déjeuner est à sept heures.'),
  VocabWord(french: 'le déjeuner', english: 'lunch', partOfSpeech: 'noun (m)', category: 'Daily Life', difficulty: 1, example: "Qu'est-ce qu'on mange pour le déjeuner ?"),
  VocabWord(french: 'le dîner', english: 'dinner / supper', partOfSpeech: 'noun (m)', category: 'Daily Life', difficulty: 1, example: 'Le dîner est servi à vingt heures.'),
  VocabWord(french: 'la lettre', english: 'letter', partOfSpeech: 'noun (f)', category: 'Daily Life', difficulty: 1, example: "J'ai reçu une lettre de mon ami."),
  VocabWord(french: 'le ménage', english: 'housework / cleaning', partOfSpeech: 'noun (m)', category: 'Daily Life', difficulty: 2, example: 'Je fais le ménage le samedi.'),
];

// ─── Category 8: Nature & Weather ───────────────────────────────────────────

const _natureWeather = [
  VocabWord(french: 'le soleil', english: 'sun', partOfSpeech: 'noun (m)', category: 'Nature & Weather', difficulty: 1, example: 'Le soleil brille aujourd\'hui.'),
  VocabWord(french: 'la lune', english: 'moon', partOfSpeech: 'noun (f)', category: 'Nature & Weather', difficulty: 1, example: 'La lune est pleine ce soir.'),
  VocabWord(french: 'la pluie', english: 'rain', partOfSpeech: 'noun (f)', category: 'Nature & Weather', difficulty: 1, example: 'La pluie tombe depuis ce matin.'),
  VocabWord(french: 'la neige', english: 'snow', partOfSpeech: 'noun (f)', category: 'Nature & Weather', difficulty: 1, example: 'Les enfants adorent la neige.'),
  VocabWord(french: 'le vent', english: 'wind', partOfSpeech: 'noun (m)', category: 'Nature & Weather', difficulty: 1, example: 'Le vent souffle très fort.'),
  VocabWord(french: 'le ciel', english: 'sky', partOfSpeech: 'noun (m)', category: 'Nature & Weather', difficulty: 1, example: 'Le ciel est dégagé ce matin.'),
  VocabWord(french: 'la mer', english: 'sea', partOfSpeech: 'noun (f)', category: 'Nature & Weather', difficulty: 1, example: 'La mer Méditerranée est chaude en été.'),
  VocabWord(french: 'la forêt', english: 'forest', partOfSpeech: 'noun (f)', category: 'Nature & Weather', difficulty: 1, example: 'Nous nous promenons dans la forêt.'),
  VocabWord(french: 'la fleur', english: 'flower', partOfSpeech: 'noun (f)', category: 'Nature & Weather', difficulty: 1, example: 'Les fleurs du jardin sont magnifiques.'),
  VocabWord(french: "l'arbre", english: 'tree', partOfSpeech: 'noun (m)', category: 'Nature & Weather', difficulty: 1, example: "L'arbre est centenaire."),
  VocabWord(french: "l'animal", english: 'animal', partOfSpeech: 'noun (m)', category: 'Nature & Weather', difficulty: 1, example: 'Cet animal vit dans la savane.'),
  VocabWord(french: 'le chien', english: 'dog', partOfSpeech: 'noun (m)', category: 'Nature & Weather', difficulty: 1, example: 'Le chien aboie dans le jardin.'),
  VocabWord(french: 'le chat', english: 'cat', partOfSpeech: 'noun (m)', category: 'Nature & Weather', difficulty: 1, example: 'Le chat dort sur le canapé.'),
  VocabWord(french: "l'oiseau", english: 'bird', partOfSpeech: 'noun (m)', category: 'Nature & Weather', difficulty: 1, example: "L'oiseau chante dans l'arbre."),
  VocabWord(french: 'le nuage', english: 'cloud', partOfSpeech: 'noun (m)', category: 'Nature & Weather', difficulty: 1, example: 'Les nuages cachent le soleil.'),
  VocabWord(french: "l'orage", english: 'thunderstorm', partOfSpeech: 'noun (m)', category: 'Nature & Weather', difficulty: 2, example: "L'orage a coupé l'électricité."),
  VocabWord(french: 'la tempête', english: 'storm', partOfSpeech: 'noun (f)', category: 'Nature & Weather', difficulty: 2, example: 'La tempête a renversé des arbres.'),
  VocabWord(french: "l'étoile", english: 'star', partOfSpeech: 'noun (f)', category: 'Nature & Weather', difficulty: 1, example: "On voit beaucoup d'étoiles à la campagne."),
  VocabWord(french: 'la rivière', english: 'river', partOfSpeech: 'noun (f)', category: 'Nature & Weather', difficulty: 2, example: 'La rivière traverse le village.'),
  VocabWord(french: 'le champ', english: 'field', partOfSpeech: 'noun (m)', category: 'Nature & Weather', difficulty: 2, example: 'Les champs de blé sont dorés en été.'),
];

// ─── Category 9: Health & Body ──────────────────────────────────────────────

const _healthBody = [
  VocabWord(french: 'la tête', english: 'head', partOfSpeech: 'noun (f)', category: 'Health & Body', difficulty: 1, example: "J'ai mal à la tête."),
  VocabWord(french: 'le corps', english: 'body', partOfSpeech: 'noun (m)', category: 'Health & Body', difficulty: 1, example: 'Le sport est bon pour le corps.'),
  VocabWord(french: 'la main', english: 'hand', partOfSpeech: 'noun (f)', category: 'Health & Body', difficulty: 1, example: 'Elle écrit de la main gauche.'),
  VocabWord(french: 'le pied', english: 'foot', partOfSpeech: 'noun (m)', category: 'Health & Body', difficulty: 1, example: 'Il marche pieds nus sur la plage.'),
  VocabWord(french: 'les yeux', english: 'eyes', partOfSpeech: 'noun (m pl)', category: 'Health & Body', difficulty: 1, example: 'Elle a les yeux verts.'),
  VocabWord(french: 'la bouche', english: 'mouth', partOfSpeech: 'noun (f)', category: 'Health & Body', difficulty: 1, example: 'Ouvrez la bouche, s\'il vous plaît.'),
  VocabWord(french: 'le cœur', english: 'heart', partOfSpeech: 'noun (m)', category: 'Health & Body', difficulty: 1, example: 'Le cœur bat plus vite quand on court.'),
  VocabWord(french: 'le dos', english: 'back (body)', partOfSpeech: 'noun (m)', category: 'Health & Body', difficulty: 1, example: "J'ai mal au dos après avoir porté des cartons."),
  VocabWord(french: 'le médecin', english: 'doctor', partOfSpeech: 'noun (m)', category: 'Health & Body', difficulty: 1, example: 'Le médecin prescrit des médicaments.'),
  VocabWord(french: "l'hôpital", english: 'hospital', partOfSpeech: 'noun (m)', category: 'Health & Body', difficulty: 1, example: "L'hôpital est près de chez moi."),
  VocabWord(french: 'la pharmacie', english: 'pharmacy', partOfSpeech: 'noun (f)', category: 'Health & Body', difficulty: 1, example: 'La pharmacie est ouverte jusqu\'à 22h.'),
  VocabWord(french: 'le médicament', english: 'medicine / medication', partOfSpeech: 'noun (m)', category: 'Health & Body', difficulty: 2, example: 'Prenez ce médicament trois fois par jour.'),
  VocabWord(french: 'malade', english: 'sick / ill', partOfSpeech: 'adjective', category: 'Health & Body', difficulty: 1, example: 'Elle est malade et reste au lit.'),
  VocabWord(french: 'la douleur', english: 'pain', partOfSpeech: 'noun (f)', category: 'Health & Body', difficulty: 2, example: 'La douleur est très forte.'),
  VocabWord(french: 'la santé', english: 'health', partOfSpeech: 'noun (f)', category: 'Health & Body', difficulty: 1, example: 'La santé est plus importante que la richesse.'),
  VocabWord(french: 'le bras', english: 'arm', partOfSpeech: 'noun (m)', category: 'Health & Body', difficulty: 1, example: 'Elle a un bracelet au bras gauche.'),
  VocabWord(french: 'la jambe', english: 'leg', partOfSpeech: 'noun (f)', category: 'Health & Body', difficulty: 1, example: "Je me suis cassé la jambe en skiant."),
  VocabWord(french: "l'oreille", english: 'ear', partOfSpeech: 'noun (f)', category: 'Health & Body', difficulty: 1, example: "J'ai les oreilles bouchées."),
  VocabWord(french: 'le nez', english: 'nose', partOfSpeech: 'noun (m)', category: 'Health & Body', difficulty: 1, example: 'J\'ai le nez qui coule.'),
  VocabWord(french: 'le dentiste', english: 'dentist', partOfSpeech: 'noun (m/f)', category: 'Health & Body', difficulty: 2, example: 'Je vais chez le dentiste deux fois par an.'),
];

// ─── Category 10: Work & School ─────────────────────────────────────────────

const _workSchool = [
  VocabWord(french: 'le professeur', english: 'teacher / professor', partOfSpeech: 'noun (m/f)', category: 'Work & School', difficulty: 1, example: 'Le professeur explique la leçon.'),
  VocabWord(french: "l'étudiant / l'étudiante", english: 'student', partOfSpeech: 'noun', category: 'Work & School', difficulty: 1, example: "L'étudiante prépare son examen."),
  VocabWord(french: 'le bureau', english: 'desk / office', partOfSpeech: 'noun (m)', category: 'Work & School', difficulty: 1, example: 'Je travaille dans un grand bureau.'),
  VocabWord(french: "l'examen", english: 'exam / test', partOfSpeech: 'noun (m)', category: 'Work & School', difficulty: 1, example: "L'examen de français est difficile."),
  VocabWord(french: 'la leçon', english: 'lesson', partOfSpeech: 'noun (f)', category: 'Work & School', difficulty: 1, example: 'Aujourd\'hui, la leçon porte sur le passé composé.'),
  VocabWord(french: 'les devoirs', english: 'homework', partOfSpeech: 'noun (m pl)', category: 'Work & School', difficulty: 1, example: "J'ai beaucoup de devoirs ce soir."),
  VocabWord(french: 'le diplôme', english: 'diploma / degree', partOfSpeech: 'noun (m)', category: 'Work & School', difficulty: 2, example: "Elle a reçu son diplôme avec mention."),
  VocabWord(french: "l'entreprise", english: 'company / business', partOfSpeech: 'noun (f)', category: 'Work & School', difficulty: 1, example: "L'entreprise recrute des ingénieurs."),
  VocabWord(french: 'le patron / la patronne', english: 'boss / employer', partOfSpeech: 'noun', category: 'Work & School', difficulty: 2, example: 'Mon patron est très compétent.'),
  VocabWord(french: 'le salaire', english: 'salary / wage', partOfSpeech: 'noun (m)', category: 'Work & School', difficulty: 2, example: 'Le salaire est versé le premier du mois.'),
  VocabWord(french: 'le métier', english: 'profession / trade', partOfSpeech: 'noun (m)', category: 'Work & School', difficulty: 1, example: 'Quel métier veux-tu faire ?'),
  VocabWord(french: 'la réunion', english: 'meeting', partOfSpeech: 'noun (f)', category: 'Work & School', difficulty: 2, example: 'La réunion commence à neuf heures.'),
  VocabWord(french: 'le courrier', english: 'mail / email', partOfSpeech: 'noun (m)', category: 'Work & School', difficulty: 2, example: "J'ai envoyé le courrier ce matin."),
  VocabWord(french: 'le dossier', english: 'file / folder', partOfSpeech: 'noun (m)', category: 'Work & School', difficulty: 2, example: 'Le dossier est sur mon bureau.'),
  VocabWord(french: 'le stage', english: 'internship', partOfSpeech: 'noun (m)', category: 'Work & School', difficulty: 2, example: "Elle fait un stage dans une banque."),
  VocabWord(french: "l'université", english: 'university', partOfSpeech: 'noun (f)', category: 'Work & School', difficulty: 2, example: "L'université de la Sorbonne est prestigieuse."),
  VocabWord(french: 'la note', english: 'grade / mark', partOfSpeech: 'noun (f)', category: 'Work & School', difficulty: 1, example: "Il a eu une bonne note à l'examen."),
  VocabWord(french: 'le collègue', english: 'colleague', partOfSpeech: 'noun (m/f)', category: 'Work & School', difficulty: 2, example: 'Mes collègues sont sympathiques.'),
  VocabWord(french: 'le cours', english: 'class / course', partOfSpeech: 'noun (m)', category: 'Work & School', difficulty: 1, example: 'Le cours de français dure une heure.'),
  VocabWord(french: "l'emploi", english: 'job / employment', partOfSpeech: 'noun (m)', category: 'Work & School', difficulty: 2, example: "Elle cherche un emploi dans l'informatique."),
];

// ─── Category 11: DELF A1 Essentials ────────────────────────────────────────

const _delfA1Essentials = [
  // Numbers
  VocabWord(french: 'un', english: 'one', partOfSpeech: 'number', category: 'DELF A1 Essentials', difficulty: 1, example: 'J\'ai un frère.'),
  VocabWord(french: 'deux', english: 'two', partOfSpeech: 'number', category: 'DELF A1 Essentials', difficulty: 1, example: 'J\'ai deux chats.'),
  VocabWord(french: 'trois', english: 'three', partOfSpeech: 'number', category: 'DELF A1 Essentials', difficulty: 1, example: 'Il y a trois chambres.'),
  VocabWord(french: 'quatre', english: 'four', partOfSpeech: 'number', category: 'DELF A1 Essentials', difficulty: 1, example: 'Nous sommes quatre à table.'),
  VocabWord(french: 'cinq', english: 'five', partOfSpeech: 'number', category: 'DELF A1 Essentials', difficulty: 1, example: 'Le billet coûte cinq euros.'),
  VocabWord(french: 'six', english: 'six', partOfSpeech: 'number', category: 'DELF A1 Essentials', difficulty: 1, example: 'Ils sont six dans la famille.'),
  VocabWord(french: 'sept', english: 'seven', partOfSpeech: 'number', category: 'DELF A1 Essentials', difficulty: 1, example: 'La semaine a sept jours.'),
  VocabWord(french: 'huit', english: 'eight', partOfSpeech: 'number', category: 'DELF A1 Essentials', difficulty: 1, example: 'Le film commence à huit heures.'),
  VocabWord(french: 'neuf', english: 'nine', partOfSpeech: 'number', category: 'DELF A1 Essentials', difficulty: 1, example: 'Ma nièce a neuf ans.'),
  VocabWord(french: 'dix', english: 'ten', partOfSpeech: 'number', category: 'DELF A1 Essentials', difficulty: 1, example: 'Il y a dix élèves dans la classe.'),
  // Days
  VocabWord(french: 'lundi', english: 'Monday', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Lundi, je vais au bureau.'),
  VocabWord(french: 'mardi', english: 'Tuesday', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Mardi, j\'ai un rendez-vous.'),
  VocabWord(french: 'mercredi', english: 'Wednesday', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Mercredi, les enfants ne vont pas à l\'école.'),
  VocabWord(french: 'jeudi', english: 'Thursday', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Jeudi, je fais du sport.'),
  VocabWord(french: 'vendredi', english: 'Friday', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Vendredi soir, on sort souvent.'),
  VocabWord(french: 'samedi', english: 'Saturday', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Samedi, je fais les courses.'),
  VocabWord(french: 'dimanche', english: 'Sunday', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Dimanche, on se repose.'),
  // Months
  VocabWord(french: 'janvier', english: 'January', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Janvier est le premier mois.'),
  VocabWord(french: 'février', english: 'February', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Février a 28 jours.'),
  VocabWord(french: 'mars', english: 'March', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Le printemps commence en mars.'),
  VocabWord(french: 'avril', english: 'April', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Avril est souvent pluvieux.'),
  VocabWord(french: 'mai', english: 'May', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Le premier mai est un jour férié.'),
  VocabWord(french: 'juin', english: 'June', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: "L'été commence en juin."),
  VocabWord(french: 'juillet', english: 'July', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Juillet est le mois des vacances.'),
  VocabWord(french: 'août', english: 'August', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Août est très chaud.'),
  VocabWord(french: 'septembre', english: 'September', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: "La rentrée est en septembre."),
  VocabWord(french: 'octobre', english: 'October', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Octobre voit les feuilles tomber.'),
  VocabWord(french: 'novembre', english: 'November', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Novembre est gris et froid.'),
  VocabWord(french: 'décembre', english: 'December', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: "Noël est en décembre."),
  // Nationalities
  VocabWord(french: 'français / française', english: 'French', partOfSpeech: 'adjective / noun', category: 'DELF A1 Essentials', difficulty: 1, example: 'Je suis français.'),
  VocabWord(french: 'anglais / anglaise', english: 'English', partOfSpeech: 'adjective / noun', category: 'DELF A1 Essentials', difficulty: 1, example: 'Elle est anglaise.'),
  VocabWord(french: 'italien / italienne', english: 'Italian', partOfSpeech: 'adjective / noun', category: 'DELF A1 Essentials', difficulty: 1, example: 'La cuisine italienne est excellente.'),
  VocabWord(french: 'espagnol / espagnole', english: 'Spanish', partOfSpeech: 'adjective / noun', category: 'DELF A1 Essentials', difficulty: 1, example: 'Il parle espagnol couramment.'),
  VocabWord(french: 'allemand / allemande', english: 'German', partOfSpeech: 'adjective / noun', category: 'DELF A1 Essentials', difficulty: 1, example: "L'allemand est une langue difficile."),
  VocabWord(french: 'américain / américaine', english: 'American', partOfSpeech: 'adjective / noun', category: 'DELF A1 Essentials', difficulty: 1, example: "C'est un film américain."),
  VocabWord(french: 'chinois / chinoise', english: 'Chinese', partOfSpeech: 'adjective / noun', category: 'DELF A1 Essentials', difficulty: 1, example: 'Elle apprend le chinois.'),
  VocabWord(french: 'japonais / japonaise', english: 'Japanese', partOfSpeech: 'adjective / noun', category: 'DELF A1 Essentials', difficulty: 2, example: "J'aime la cuisine japonaise."),
  VocabWord(french: 'belge', english: 'Belgian', partOfSpeech: 'adjective / noun', category: 'DELF A1 Essentials', difficulty: 2, example: 'Le chocolat belge est réputé.'),
  VocabWord(french: 'suisse', english: 'Swiss', partOfSpeech: 'adjective / noun', category: 'DELF A1 Essentials', difficulty: 2, example: 'Les Alpes suisses sont magnifiques.'),
  // Professions
  VocabWord(french: 'médecin', english: 'doctor', partOfSpeech: 'noun (m/f)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Elle veut devenir médecin.'),
  VocabWord(french: 'avocat / avocate', english: 'lawyer', partOfSpeech: 'noun', category: 'DELF A1 Essentials', difficulty: 2, example: "L'avocat défend son client."),
  VocabWord(french: 'ingénieur', english: 'engineer', partOfSpeech: 'noun (m/f)', category: 'DELF A1 Essentials', difficulty: 2, example: "Mon frère est ingénieur informatique."),
  VocabWord(french: 'enseignant / enseignante', english: 'teacher', partOfSpeech: 'noun', category: 'DELF A1 Essentials', difficulty: 2, example: "L'enseignante prépare ses cours avec soin."),
  VocabWord(french: 'commerçant / commerçante', english: 'shopkeeper / merchant', partOfSpeech: 'noun', category: 'DELF A1 Essentials', difficulty: 2, example: 'Le commerçant ouvre sa boutique à 9h.'),
  VocabWord(french: 'cuisinier / cuisinière', english: 'cook / chef', partOfSpeech: 'noun', category: 'DELF A1 Essentials', difficulty: 2, example: 'Le cuisinier prépare un délicieux repas.'),
  VocabWord(french: 'infirmier / infirmière', english: 'nurse', partOfSpeech: 'noun', category: 'DELF A1 Essentials', difficulty: 1, example: "L'infirmière prend soin des patients."),
  VocabWord(french: 'chauffeur', english: 'driver', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 2, example: 'Le chauffeur de bus est très aimable.'),
  VocabWord(french: 'artiste', english: 'artist', partOfSpeech: 'noun (m/f)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Cet artiste peint des paysages magnifiques.'),
  VocabWord(french: 'musicien / musicienne', english: 'musician', partOfSpeech: 'noun', category: 'DELF A1 Essentials', difficulty: 2, example: 'Le musicien joue du violon.'),
  // Hobbies
  VocabWord(french: 'la lecture', english: 'reading', partOfSpeech: 'noun (f)', category: 'DELF A1 Essentials', difficulty: 1, example: 'La lecture est son loisir préféré.'),
  VocabWord(french: 'le sport', english: 'sport', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Elle fait du sport trois fois par semaine.'),
  VocabWord(french: 'la musique', english: 'music', partOfSpeech: 'noun (f)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Il écoute de la musique tous les jours.'),
  VocabWord(french: 'le cinéma', english: 'cinema / movies', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Nous allons au cinéma ce soir.'),
  VocabWord(french: 'la danse', english: 'dance', partOfSpeech: 'noun (f)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Ma fille fait de la danse classique.'),
  VocabWord(french: 'la peinture', english: 'painting', partOfSpeech: 'noun (f)', category: 'DELF A1 Essentials', difficulty: 2, example: 'La peinture est un art magnifique.'),
  VocabWord(french: 'la photographie', english: 'photography', partOfSpeech: 'noun (f)', category: 'DELF A1 Essentials', difficulty: 2, example: 'La photographie est sa passion.'),
  VocabWord(french: 'la cuisine', english: 'cooking', partOfSpeech: 'noun (f)', category: 'DELF A1 Essentials', difficulty: 1, example: "J'adore faire la cuisine le week-end."),
  VocabWord(french: 'le voyage', english: 'travel', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 1, example: 'Le voyage est une façon de découvrir le monde.'),
  VocabWord(french: 'le jardinage', english: 'gardening', partOfSpeech: 'noun (m)', category: 'DELF A1 Essentials', difficulty: 2, example: 'Le jardinage le détend après le travail.'),
];

// ─── Aggregated master list ─────────────────────────────────────────────────

const List<VocabWord> allVocabWords = [
  ..._greetingsPoliteness,
  ..._familyPeople,
  ..._foodDrink,
  ..._travelTransport,
  ..._homeLiving,
  ..._colorsDescriptions,
  ..._dailyLife,
  ..._natureWeather,
  ..._healthBody,
  ..._workSchool,
  ..._delfA1Essentials,
];

// ─── Quick access by category ───────────────────────────────────────────────

Map<String, List<VocabWord>> get vocabByCategory {
  final map = <String, List<VocabWord>>{};
  for (final word in allVocabWords) {
    map.putIfAbsent(word.category, () => []).add(word);
  }
  return map;
}

// ─── DELF level vocab lists ─────────────────────────────────────────────────

List<VocabWord> get delfA1Vocab =>
    allVocabWords.where((w) => w.difficulty <= 1).toList();

List<VocabWord> get delfA2Vocab =>
    allVocabWords.where((w) => w.difficulty <= 2).toList();

List<VocabWord> get delfB1Vocab =>
    allVocabWords.where((w) => w.difficulty <= 3).toList();

List<VocabWord> get delfB2Vocab =>
    allVocabWords.where((w) => w.difficulty <= 4).toList();

List<VocabWord> get delfC1Vocab =>
    allVocabWords.where((w) => w.difficulty <= 5).toList();

// ─── Helper: vocab by part of speech ───────────────────────────────────────

Map<String, List<VocabWord>> get vocabByPartOfSpeech {
  final map = <String, List<VocabWord>>{};
  for (final word in allVocabWords) {
    map.putIfAbsent(word.partOfSpeech, () => []).add(word);
  }
  return map;
}

// ─── Helper: search ─────────────────────────────────────────────────────────

List<VocabWord> searchVocab(String query) {
  final q = query.toLowerCase().trim();
  if (q.isEmpty) return allVocabWords;
  return allVocabWords.where((w) {
    return w.french.toLowerCase().contains(q) ||
        w.english.toLowerCase().contains(q);
  }).toList();
}

// ─── Count helper ───────────────────────────────────────────────────────────

int get vocabCount => allVocabWords.length;
