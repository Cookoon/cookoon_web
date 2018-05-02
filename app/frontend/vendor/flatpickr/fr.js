export const French = {
  firstDayOfWeek: 1,
  weekdays: {
    shorthand: ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'],
    longhand: [
      'Dimanche',
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi'
    ]
  },
  months: {
    shorthand: [
      'Janv',
      'Févr',
      'Mars',
      'Avr',
      'Mai',
      'Juin',
      'Juil',
      'Août',
      'Sept',
      'Oct',
      'Nov',
      'Déc'
    ],
    longhand: [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre'
    ]
  },
  ordinal: function(nth) {
    if (nth > 1) return 'ème';
    return 'er';
  },
  rangeSeparator: ' au ',
  weekAbbreviation: 'Sem',
  scrollTitle: 'Défiler pour augmenter la valeur',
  toggleTitle: 'Cliquer pour basculer'
};
