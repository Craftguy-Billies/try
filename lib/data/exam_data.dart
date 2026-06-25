
import '../models/exam_question.dart';

class ExamData {
  static final List<ExamQuestion> allQuestions = [
    // ===== BASICS / GREETINGS (A1) =====
    const ExamQuestion(id: 'q1', type: ExamQuestionType.multipleChoice, prompt: 'What does "bonjour" mean?', correctAnswer: 'Hello', options: ['Hello', 'Goodbye', 'Thank you', 'Sorry'], difficulty: 1, category: 'greetings'),
    const ExamQuestion(id: 'q2', type: ExamQuestionType.multipleChoice, prompt: 'What does "merci" mean?', correctAnswer: 'Thank you', options: ['Please', 'Thank you', 'You\'re welcome', 'Goodbye'], difficulty: 1, category: 'greetings'),
    const ExamQuestion(id: 'q3', type: ExamQuestionType.multipleChoice, prompt: 'How do you say "goodbye" in French?', correctAnswer: 'Au revoir', options: ['Bonjour', 'Au revoir', 'Merci', 'Pardon'], difficulty: 1, category: 'greetings'),
    const ExamQuestion(id: 'q4', type: ExamQuestionType.multipleChoice, prompt: 'What does "s\'il vous plaît" mean?', correctAnswer: 'Please', options: ['Please', 'Thank you', 'Excuse me', 'Good night'], difficulty: 1, category: 'greetings'),
    const ExamQuestion(id: 'q5', type: ExamQuestionType.multipleChoice, prompt: '"Oui" means:', correctAnswer: 'Yes', options: ['No', 'Yes', 'Maybe', 'Never'], difficulty: 1, category: 'greetings'),
    const ExamQuestion(id: 'q6', type: ExamQuestionType.multipleChoice, prompt: 'How do you say "excuse me" in French?', correctAnswer: 'Excusez-moi', options: ['Merci', 'Pardon', 'Excusez-moi', 'Bonjour'], difficulty: 1, category: 'greetings'),
    const ExamQuestion(id: 'q7', type: ExamQuestionType.multipleChoice, prompt: 'What is the French word for "good evening"?', correctAnswer: 'Bonsoir', options: ['Bonsoir', 'Bonjour', 'Bonne nuit', 'Bon appétit'], difficulty: 1, category: 'greetings'),
    const ExamQuestion(id: 'q8', type: ExamQuestionType.multipleChoice, prompt: '"Comment allez-vous?" means:', correctAnswer: 'How are you?', options: ['Where are you?', 'How are you?', 'What is your name?', 'How old are you?'], difficulty: 1, category: 'greetings'),
    const ExamQuestion(id: 'q9', type: ExamQuestionType.multipleChoice, prompt: 'What is "de rien" in English?', correctAnswer: 'You\'re welcome', options: ['Thank you', 'You\'re welcome', 'Nothing', 'Goodbye'], difficulty: 1, category: 'greetings'),
    const ExamQuestion(id: 'q10', type: ExamQuestionType.multipleChoice, prompt: '"Enchanté" means:', correctAnswer: 'Nice to meet you', options: ['Good luck', 'Nice to meet you', 'Have a good day', 'See you soon'], difficulty: 1, category: 'greetings'),

    // ===== FAMILY (A1) =====
    const ExamQuestion(id: 'q11', type: ExamQuestionType.multipleChoice, prompt: '"Le père" means:', correctAnswer: 'The father', options: ['The mother', 'The father', 'The brother', 'The son'], difficulty: 1, category: 'family'),
    const ExamQuestion(id: 'q12', type: ExamQuestionType.multipleChoice, prompt: '"La sœur" means:', correctAnswer: 'The sister', options: ['The mother', 'The daughter', 'The sister', 'The aunt'], difficulty: 1, category: 'family'),
    const ExamQuestion(id: 'q13', type: ExamQuestionType.multipleChoice, prompt: '"Le mari" means:', correctAnswer: 'The husband', options: ['The wife', 'The husband', 'The father', 'The son'], difficulty: 1, category: 'family'),
    const ExamQuestion(id: 'q14', type: ExamQuestionType.multipleChoice, prompt: 'What is "la famille" in English?', correctAnswer: 'Family', options: ['Friends', 'Family', 'People', 'Children'], difficulty: 1, category: 'family'),
    const ExamQuestion(id: 'q15', type: ExamQuestionType.multipleChoice, prompt: '"Le grand-père" means:', correctAnswer: 'Grandfather', options: ['Grandmother', 'Grandfather', 'Uncle', 'Father'], difficulty: 1, category: 'family'),

    // ===== FOOD (A1) =====
    const ExamQuestion(id: 'q16', type: ExamQuestionType.multipleChoice, prompt: '"Le pain" means:', correctAnswer: 'Bread', options: ['Wine', 'Bread', 'Cheese', 'Meat'], difficulty: 1, category: 'food'),
    const ExamQuestion(id: 'q17', type: ExamQuestionType.multipleChoice, prompt: '"Le fromage" means:', correctAnswer: 'Cheese', options: ['Bread', 'Butter', 'Cheese', 'Milk'], difficulty: 1, category: 'food'),
    const ExamQuestion(id: 'q18', type: ExamQuestionType.multipleChoice, prompt: '"L\'eau" means:', correctAnswer: 'Water', options: ['Wine', 'Water', 'Juice', 'Milk'], difficulty: 1, category: 'food'),
    const ExamQuestion(id: 'q19', type: ExamQuestionType.multipleChoice, prompt: '"Manger" means:', correctAnswer: 'To eat', options: ['To drink', 'To eat', 'To cook', 'To buy'], difficulty: 1, category: 'food'),
    const ExamQuestion(id: 'q20', type: ExamQuestionType.multipleChoice, prompt: '"Le petit-déjeuner" means:', correctAnswer: 'Breakfast', options: ['Lunch', 'Dinner', 'Breakfast', 'Snack'], difficulty: 1, category: 'food'),

    // ===== DAILY LIFE (A1) =====
    const ExamQuestion(id: 'q21', type: ExamQuestionType.multipleChoice, prompt: '"La maison" means:', correctAnswer: 'House', options: ['Apartment', 'House', 'Room', 'Building'], difficulty: 1, category: 'daily'),
    const ExamQuestion(id: 'q22', type: ExamQuestionType.multipleChoice, prompt: '"Le matin" means:', correctAnswer: 'Morning', options: ['Evening', 'Morning', 'Night', 'Afternoon'], difficulty: 1, category: 'daily'),
    const ExamQuestion(id: 'q23', type: ExamQuestionType.multipleChoice, prompt: '"Dormir" means:', correctAnswer: 'To sleep', options: ['To wake up', 'To sleep', 'To dream', 'To rest'], difficulty: 1, category: 'daily'),
    const ExamQuestion(id: 'q24', type: ExamQuestionType.multipleChoice, prompt: '"La cuisine" means:', correctAnswer: 'Kitchen / cooking', options: ['Bathroom', 'Bedroom', 'Kitchen / cooking', 'Living room'], difficulty: 1, category: 'daily'),

    // ===== TRAVEL (A2) =====
    const ExamQuestion(id: 'q25', type: ExamQuestionType.multipleChoice, prompt: '"L\'avion" means:', correctAnswer: 'Airplane', options: ['Train', 'Airplane', 'Car', 'Bus'], difficulty: 2, category: 'travel'),
    const ExamQuestion(id: 'q26', type: ExamQuestionType.multipleChoice, prompt: '"La gare" means:', correctAnswer: 'Train station', options: ['Airport', 'Bus stop', 'Train station', 'Port'], difficulty: 2, category: 'travel'),
    const ExamQuestion(id: 'q27', type: ExamQuestionType.multipleChoice, prompt: '"Voyager" means:', correctAnswer: 'To travel', options: ['To work', 'To travel', 'To visit', 'To drive'], difficulty: 2, category: 'travel'),
    const ExamQuestion(id: 'q28', type: ExamQuestionType.multipleChoice, prompt: '"Le billet" means:', correctAnswer: 'Ticket', options: ['Passport', 'Ticket', 'Map', 'Suitcase'], difficulty: 2, category: 'travel'),

    // ===== GRAMMAR: ARTICLES (A1) =====
    const ExamQuestion(id: 'q29', type: ExamQuestionType.fillBlank, prompt: 'Complete: ___ chat est noir. (the cat is black)', correctAnswer: 'Le', options: ['Le', 'La', 'Les', 'L\''], difficulty: 1, category: 'basics', explanation: 'Chat is masculine, so use "le".'),
    const ExamQuestion(id: 'q30', type: ExamQuestionType.fillBlank, prompt: 'Complete: ___ maison est grande. (the house is big)', correctAnswer: 'La', options: ['Le', 'La', 'Les', 'L\''], difficulty: 1, category: 'basics', explanation: 'Maison is feminine, so use "la".'),
    const ExamQuestion(id: 'q31', type: ExamQuestionType.fillBlank, prompt: 'Complete: ___ enfants jouent. (the children play)', correctAnswer: 'Les', options: ['Le', 'La', 'Les', 'Un'], difficulty: 1, category: 'basics', explanation: 'Enfants is plural, use "les".'),
    const ExamQuestion(id: 'q32', type: ExamQuestionType.fillBlank, prompt: 'Complete: J\'ai ___ livre. (I have a book)', correctAnswer: 'un', options: ['un', 'une', 'le', 'la'], difficulty: 1, category: 'basics', explanation: 'Livre is masculine, indefinite article is "un".'),
    const ExamQuestion(id: 'q33', type: ExamQuestionType.fillBlank, prompt: 'Complete: J\'ai ___ voiture. (I have a car)', correctAnswer: 'une', options: ['un', 'une', 'le', 'la'], difficulty: 1, category: 'basics', explanation: 'Voiture is feminine, indefinite article is "une".'),

    // ===== GRAMMAR: VERBS (A1-A2) =====
    const ExamQuestion(id: 'q34', type: ExamQuestionType.fillBlank, prompt: 'Je ___ français. (I am French)', correctAnswer: 'suis', options: ['suis', 'es', 'est', 'sont'], difficulty: 1, category: 'basics', explanation: 'First person singular of être (to be).'),
    const ExamQuestion(id: 'q35', type: ExamQuestionType.fillBlank, prompt: 'Tu ___ un chien? (Do you have a dog?)', correctAnswer: 'as', options: ['as', 'a', 'avons', 'avez'], difficulty: 1, category: 'basics', explanation: 'Second person singular of avoir (to have).'),
    const ExamQuestion(id: 'q36', type: ExamQuestionType.fillBlank, prompt: 'Nous ___ au cinéma. (We go to the cinema)', correctAnswer: 'allons', options: ['allons', 'allez', 'vont', 'va'], difficulty: 2, category: 'basics', explanation: 'First person plural of aller (to go).'),
    const ExamQuestion(id: 'q37', type: ExamQuestionType.fillBlank, prompt: 'Elles ___ à Paris. (They live in Paris)', correctAnswer: 'habitent', options: ['habite', 'habites', 'habitent', 'habitez'], difficulty: 1, category: 'basics', explanation: 'Third person plural of habiter.'),
    const ExamQuestion(id: 'q38', type: ExamQuestionType.fillBlank, prompt: 'Je ___ un café. (I want a coffee)', correctAnswer: 'veux', options: ['veux', 'veut', 'voulez', 'veulent'], difficulty: 2, category: 'basics', explanation: 'First person singular of vouloir.'),
    const ExamQuestion(id: 'q39', type: ExamQuestionType.fillBlank, prompt: 'Il ___ manger. (He can eat)', correctAnswer: 'peut', options: ['peux', 'peut', 'pouvons', 'peuvent'], difficulty: 2, category: 'basics', explanation: 'Third person singular of pouvoir.'),
    const ExamQuestion(id: 'q40', type: ExamQuestionType.fillBlank, prompt: 'Vous ___ anglais? (Do you speak English?)', correctAnswer: 'parlez', options: ['parle', 'parles', 'parlez', 'parlent'], difficulty: 1, category: 'basics', explanation: 'Second person plural / formal of parler.'),


    const ExamQuestion(id: 'q41', type: ExamQuestionType.multipleChoice, prompt: '"Aujourd\'hui" means:', correctAnswer: 'Today', options: ['Yesterday', 'Today', 'Tomorrow', 'Now'], difficulty: 1, category: 'daily'),
    const ExamQuestion(id: 'q42', type: ExamQuestionType.multipleChoice, prompt: '"Demain" means:', correctAnswer: 'Tomorrow', options: ['Yesterday', 'Today', 'Tomorrow', 'Now'], difficulty: 1, category: 'daily'),
    const ExamQuestion(id: 'q43', type: ExamQuestionType.multipleChoice, prompt: '"Le soir" means:', correctAnswer: 'Evening', options: ['Morning', 'Night', 'Evening', 'Afternoon'], difficulty: 1, category: 'daily'),
    const ExamQuestion(id: 'q44', type: ExamQuestionType.multipleChoice, prompt: '"Toujours" means:', correctAnswer: 'Always', options: ['Sometimes', 'Always', 'Never', 'Often'], difficulty: 1, category: 'basics'),
    const ExamQuestion(id: 'q45', type: ExamQuestionType.multipleChoice, prompt: '"Jamais" means:', correctAnswer: 'Never', options: ['Always', 'Sometimes', 'Often', 'Never'], difficulty: 1, category: 'basics'),
    const ExamQuestion(id: 'q46', type: ExamQuestionType.multipleChoice, prompt: '"La mer" means:', correctAnswer: 'Sea', options: ['Mountain', 'River', 'Sea', 'Lake'], difficulty: 2, category: 'weather'),
    const ExamQuestion(id: 'q47', type: ExamQuestionType.multipleChoice, prompt: '"La montagne" means:', correctAnswer: 'Mountain', options: ['Mountain', 'Hill', 'Valley', 'Forest'], difficulty: 2, category: 'weather'),
    const ExamQuestion(id: 'q48', type: ExamQuestionType.multipleChoice, prompt: '"Le ciel" means:', correctAnswer: 'Sky', options: ['Sun', 'Sky', 'Cloud', 'Star'], difficulty: 1, category: 'weather'),
    const ExamQuestion(id: 'q49', type: ExamQuestionType.multipleChoice, prompt: '"Chaud" means:', correctAnswer: 'Hot', options: ['Cold', 'Warm', 'Hot', 'Cool'], difficulty: 1, category: 'weather'),
    const ExamQuestion(id: 'q50', type: ExamQuestionType.multipleChoice, prompt: '"Froid" means:', correctAnswer: 'Cold', options: ['Hot', 'Cold', 'Wet', 'Dry'], difficulty: 1, category: 'weather'),
    const ExamQuestion(id: 'q51', type: ExamQuestionType.multipleChoice, prompt: '"La santé" means:', correctAnswer: 'Health', options: ['Disease', 'Health', 'Medicine', 'Hospital'], difficulty: 2, category: 'health'),
    const ExamQuestion(id: 'q52', type: ExamQuestionType.multipleChoice, prompt: '"Le médecin" means:', correctAnswer: 'Doctor', options: ['Nurse', 'Doctor', 'Patient', 'Pharmacist'], difficulty: 1, category: 'health'),
    const ExamQuestion(id: 'q53', type: ExamQuestionType.multipleChoice, prompt: '"L\'hôpital" means:', correctAnswer: 'Hospital', options: ['Hotel', 'Hospital', 'School', 'Pharmacy'], difficulty: 2, category: 'health'),
    const ExamQuestion(id: 'q54', type: ExamQuestionType.multipleChoice, prompt: '"Le travail" means:', correctAnswer: 'Work', options: ['Travel', 'Work', 'Study', 'Play'], difficulty: 1, category: 'work'),
    const ExamQuestion(id: 'q55', type: ExamQuestionType.multipleChoice, prompt: '"L\'école" means:', correctAnswer: 'School', options: ['Office', 'School', 'Hospital', 'Church'], difficulty: 1, category: 'work'),
    const ExamQuestion(id: 'q56', type: ExamQuestionType.multipleChoice, prompt: '"Apprendre" means:', correctAnswer: 'To learn', options: ['To teach', 'To learn', 'To understand', 'To know'], difficulty: 2, category: 'work'),
    const ExamQuestion(id: 'q57', type: ExamQuestionType.multipleChoice, prompt: '"Comprendre" means:', correctAnswer: 'To understand', options: ['To learn', 'To know', 'To understand', 'To read'], difficulty: 2, category: 'work'),
    const ExamQuestion(id: 'q58', type: ExamQuestionType.multipleChoice, prompt: '"Acheter" means:', correctAnswer: 'To buy', options: ['To sell', 'To buy', 'To pay', 'To look'], difficulty: 1, category: 'shopping'),
    const ExamQuestion(id: 'q59', type: ExamQuestionType.multipleChoice, prompt: '"L\'argent" means:', correctAnswer: 'Money', options: ['Gold', 'Money', 'Silver', 'Price'], difficulty: 1, category: 'shopping'),
    const ExamQuestion(id: 'q60', type: ExamQuestionType.multipleChoice, prompt: '"Cher" (as in expensive) means:', correctAnswer: 'Expensive', options: ['Cheap', 'Expensive', 'Good', 'Bad'], difficulty: 2, category: 'shopping'),
  ];
}
