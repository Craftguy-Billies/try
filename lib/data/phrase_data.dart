
import '../models/phrase.dart';

class PhraseData {
  static final List<Phrase> greetings = [
    const Phrase(id: 'p1', french: 'Bonjour', english: 'Hello / Good morning', pronunciation: 'bohn-zhoor', category: 'Greetings', formality: 'neutral'),
    const Phrase(id: 'p2', french: 'Bonsoir', english: 'Good evening', pronunciation: 'bohn-swahr', category: 'Greetings', formality: 'neutral'),
    const Phrase(id: 'p3', french: 'Salut', english: 'Hi / Bye', pronunciation: 'sah-lew', category: 'Greetings', formality: 'informal'),
    const Phrase(id: 'p4', french: 'Comment allez-vous?', english: 'How are you? (formal)', pronunciation: 'koh-mahn tah-lay voo', category: 'Greetings', formality: 'formal'),
    const Phrase(id: 'p5', french: 'Comment ça va?', english: 'How\'s it going?', pronunciation: 'koh-mahn sah vah', category: 'Greetings', formality: 'informal'),
    const Phrase(id: 'p6', french: 'Ça va bien, merci.', english: 'I\'m doing well, thanks.', pronunciation: 'sah vah byen mehr-see', category: 'Greetings', formality: 'neutral'),
    const Phrase(id: 'p7', french: 'Enchanté(e)', english: 'Nice to meet you', pronunciation: 'ahn-shahn-tay', category: 'Greetings', formality: 'neutral'),
    const Phrase(id: 'p8', french: 'Bonne journée!', english: 'Have a nice day!', pronunciation: 'bon zhoor-nay', category: 'Greetings', formality: 'neutral'),
    const Phrase(id: 'p9', french: 'Bonne soirée!', english: 'Have a good evening!', pronunciation: 'bon swah-ray', category: 'Greetings', formality: 'neutral'),
    const Phrase(id: 'p10', french: 'À bientôt!', english: 'See you soon!', pronunciation: 'ah byen-toh', category: 'Greetings', formality: 'neutral'),
    const Phrase(id: 'p11', french: 'À tout à l\'heure!', english: 'See you later!', pronunciation: 'ah too tah lur', category: 'Greetings', formality: 'informal'),
    const Phrase(id: 'p12', french: 'Bonne nuit!', english: 'Good night!', pronunciation: 'bon nwee', category: 'Greetings', formality: 'neutral'),
  ];

  static final List<Phrase> dining = [
    const Phrase(id: 'p13', french: 'Je voudrais...', english: 'I would like...', pronunciation: 'zhuh voo-dreh', category: 'Dining', formality: 'formal'),
    const Phrase(id: 'p14', french: 'L\'addition, s\'il vous plaît.', english: 'The bill, please.', pronunciation: 'lah-dee-syohn seel voo pleh', category: 'Dining', formality: 'formal'),
    const Phrase(id: 'p15', french: 'C\'est délicieux!', english: 'It\'s delicious!', pronunciation: 'say day-lee-syuh', category: 'Dining', formality: 'neutral'),
    const Phrase(id: 'p16', french: 'Je prends le menu du jour.', english: 'I\'ll have the daily special.', pronunciation: 'zhuh prahn luh muh-new dew zhoor', category: 'Dining', formality: 'neutral'),
    const Phrase(id: 'p17', french: 'Un café, s\'il vous plaît.', english: 'A coffee, please.', pronunciation: 'uhn kah-fay seel voo pleh', category: 'Dining', formality: 'formal'),
    const Phrase(id: 'p18', french: 'Je suis végétarien(ne).', english: 'I am vegetarian.', pronunciation: 'zhuh swee vay-zhay-tah-ryen', category: 'Dining', formality: 'neutral'),
    const Phrase(id: 'p19', french: 'Qu\'est-ce que vous recommandez?', english: 'What do you recommend?', pronunciation: 'kes-kuh voo ruh-koh-mahn-day', category: 'Dining', formality: 'formal'),
  ];

  static final List<Phrase> travel = [
    const Phrase(id: 'p20', french: 'Où sont les toilettes?', english: 'Where is the bathroom?', pronunciation: 'oo sohn lay twah-let', category: 'Travel', formality: 'neutral'),
    const Phrase(id: 'p21', french: 'Je suis perdu(e).', english: 'I am lost.', pronunciation: 'zhuh swee pehr-dew', category: 'Travel', formality: 'neutral'),
    const Phrase(id: 'p22', french: 'Pouvez-vous m\'aider?', english: 'Can you help me?', pronunciation: 'poo-vay voo may-day', category: 'Travel', formality: 'formal'),
    const Phrase(id: 'p23', french: 'Où est la gare?', english: 'Where is the train station?', pronunciation: 'oo ay lah gahr', category: 'Travel', formality: 'neutral'),
    const Phrase(id: 'p24', french: 'Un billet pour..., s\'il vous plaît.', english: 'A ticket to..., please.', pronunciation: 'uhn bee-yay poor seel voo pleh', category: 'Travel', formality: 'formal'),
    const Phrase(id: 'p25', french: 'Combien ça coûte?', english: 'How much does it cost?', pronunciation: 'kohm-byen sah koot', category: 'Travel', formality: 'neutral'),
    const Phrase(id: 'p26', french: 'À quelle heure part le train?', english: 'What time does the train leave?', pronunciation: 'ah kel ur par luh tran', category: 'Travel', formality: 'neutral'),
    const Phrase(id: 'p27', french: 'Je voudrais réserver une chambre.', english: 'I would like to book a room.', pronunciation: 'zhuh voo-dreh ray-zehr-vay ewn shahm-bruh', category: 'Travel', formality: 'formal'),
  ];

  static final List<Phrase> shopping = [
    const Phrase(id: 'p28', french: 'Combien ça coûte?', english: 'How much does it cost?', pronunciation: 'kohm-byen sah koot', category: 'Shopping', formality: 'neutral'),
    const Phrase(id: 'p29', french: 'C\'est trop cher.', english: 'It\'s too expensive.', pronunciation: 'say troh shehr', category: 'Shopping', formality: 'neutral'),
    const Phrase(id: 'p30', french: 'Avez-vous cette taille?', english: 'Do you have this size?', pronunciation: 'ah-vay voo set tigh', category: 'Shopping', formality: 'formal'),
    const Phrase(id: 'p31', french: 'Je peux essayer?', english: 'Can I try it on?', pronunciation: 'zhuh puh eh-say-yay', category: 'Shopping', formality: 'neutral'),
    const Phrase(id: 'p32', french: 'Je regarde seulement.', english: 'I\'m just looking.', pronunciation: 'zhuh ruh-gard suhl-mahn', category: 'Shopping', formality: 'neutral'),
    const Phrase(id: 'p33', french: 'Vous acceptez la carte bancaire?', english: 'Do you accept credit cards?', pronunciation: 'voo zak-sep-tay lah kart bahn-kehr', category: 'Shopping', formality: 'formal'),
  ];

  static final List<Phrase> emergency = [
    const Phrase(id: 'p34', french: 'Au secours!', english: 'Help!', pronunciation: 'oh skoor', category: 'Emergency', formality: 'neutral'),
    const Phrase(id: 'p35', french: 'Appelez un médecin!', english: 'Call a doctor!', pronunciation: 'ah-play uhn mayd-san', category: 'Emergency', formality: 'formal'),
    const Phrase(id: 'p36', french: 'Où est l\'hôpital le plus proche?', english: 'Where is the nearest hospital?', pronunciation: 'oo ay loh-pee-tahl luh ploo prosh', category: 'Emergency', formality: 'neutral'),
    const Phrase(id: 'p37', french: 'Je ne me sens pas bien.', english: 'I don\'t feel well.', pronunciation: 'zhuh nuh muh sahn pah byen', category: 'Emergency', formality: 'neutral'),
  ];

  static final List<Phrase> daily = [
    const Phrase(id: 'p38', french: 'Quelle heure est-il?', english: 'What time is it?', pronunciation: 'kel ur eh-teel', category: 'Daily Life', formality: 'neutral'),
    const Phrase(id: 'p39', french: 'Il est huit heures.', english: 'It\'s 8 o\'clock.', pronunciation: 'eel ay weet ur', category: 'Daily Life', formality: 'neutral'),
    const Phrase(id: 'p40', french: 'Je dois y aller.', english: 'I have to go.', pronunciation: 'zhuh dwah ee ah-lay', category: 'Daily Life', formality: 'neutral'),
    const Phrase(id: 'p41', french: 'À demain!', english: 'See you tomorrow!', pronunciation: 'ah duh-man', category: 'Daily Life', formality: 'neutral'),
    const Phrase(id: 'p42', french: 'Bonne chance!', english: 'Good luck!', pronunciation: 'bon shahns', category: 'Daily Life', formality: 'neutral'),
    const Phrase(id: 'p43', french: 'Félicitations!', english: 'Congratulations!', pronunciation: 'fay-lee-see-tah-syohn', category: 'Daily Life', formality: 'neutral'),
    const Phrase(id: 'p44', french: 'Désolé(e)', english: 'Sorry', pronunciation: 'day-zoh-lay', category: 'Daily Life', formality: 'neutral'),
    const Phrase(id: 'p45', french: 'Ce n\'est pas grave.', english: 'It\'s not a big deal.', pronunciation: 'suh nay pah grahv', category: 'Daily Life', formality: 'neutral'),
  ];

  static final List<Conversation> conversations = [
    Conversation(
      id: 'conv1', titleEn: 'At the Café', titleFr: 'Au Café',
      scenarioEn: 'Ordering coffee at a Parisian café', scenarioFr: 'Commander un café dans un café parisien',
      lines: [
        ConversationLine(speaker: 'Serveur', french: 'Bonjour, vous désirez?', english: 'Hello, what would you like?'),
        ConversationLine(speaker: 'Client', french: 'Bonjour, un café crème, s\'il vous plaît.', english: 'Hello, a café crème, please.'),
        ConversationLine(speaker: 'Serveur', french: 'Tout de suite. Et avec ceci?', english: 'Right away. Anything else?'),
        ConversationLine(speaker: 'Client', french: 'Non, merci. C\'est tout.', english: 'No, thank you. That\'s all.'),
        ConversationLine(speaker: 'Serveur', french: 'Voilà. Ça fera 4 euros.', english: 'Here you go. That will be 4 euros.'),
        ConversationLine(speaker: 'Client', french: 'Merci beaucoup!', english: 'Thank you very much!'),
      ],
    ),
    Conversation(
      id: 'conv2', titleEn: 'Asking for Directions', titleFr: 'Demander son Chemin',
      scenarioEn: 'A tourist asks for directions in Paris', scenarioFr: 'Un touriste demande son chemin à Paris',
      lines: [
        ConversationLine(speaker: 'Touriste', french: 'Pardon, pour aller au Louvre, s\'il vous plaît?', english: 'Excuse me, how do I get to the Louvre, please?'),
        ConversationLine(speaker: 'Passant', french: 'C\'est simple. Allez tout droit, puis tournez à gauche.', english: 'It\'s simple. Go straight ahead, then turn left.'),
        ConversationLine(speaker: 'Touriste', french: 'C\'est loin?', english: 'Is it far?'),
        ConversationLine(speaker: 'Passant', french: 'Non, c\'est à dix minutes à pied.', english: 'No, it\'s a ten-minute walk.'),
        ConversationLine(speaker: 'Touriste', french: 'Merci beaucoup!', english: 'Thank you very much!'),
      ],
    ),
    Conversation(
      id: 'conv3', titleEn: 'At the Restaurant', titleFr: 'Au Restaurant',
      scenarioEn: 'Dining at a French restaurant', scenarioFr: 'Dîner dans un restaurant français',
      lines: [
        ConversationLine(speaker: 'Serveur', french: 'Bonsoir, avez-vous réservé?', english: 'Good evening, do you have a reservation?'),
        ConversationLine(speaker: 'Client', french: 'Oui, au nom de Dubois.', english: 'Yes, under the name Dubois.'),
        ConversationLine(speaker: 'Serveur', french: 'Voici votre table. Voici le menu.', english: 'Here is your table. Here is the menu.'),
        ConversationLine(speaker: 'Client', french: 'Je voudrais le plat du jour, s\'il vous plaît.', english: 'I would like the daily special, please.'),
        ConversationLine(speaker: 'Serveur', french: 'Très bon choix! Et comme boisson?', english: 'Very good choice! And to drink?'),
        ConversationLine(speaker: 'Client', french: 'Un verre de vin rouge, merci.', english: 'A glass of red wine, thank you.'),
      ],
    ),
  ];
}
