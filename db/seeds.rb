puts "Destroying"
Reservation.destroy_all
Inventory.destroy_all
Cookoon.destroy_all
UserSearch.destroy_all
User.destroy_all

users_attributes = [
  {email: 'quentin@cookoon.fr', password: 'plopplop', first_name: 'Quentin', last_name: 'Pernez', description: 'Un bon user', phone_number: '0636686565', photo_url: "https://ca.slack-edge.com/T0A4A3AQZ-U0A5L9L8K-7eda5a7e311c-512" },
  {email: 'charles@cookoon.fr', password: 'plopplop', first_name: 'Charles', last_name: 'Pernet', description: 'Un user heureux', phone_number: '0660283574', photo_url: "https://ca.slack-edge.com/T0A4A3AQZ-U5C18PEJZ-13810bfae838-512" },
  {email: 'gregory@cookoon.fr', password: 'plopplop', first_name: 'Gregory', last_name: 'Escure', description: 'Un bon user', phone_number: '0636686565', photo_url: "https://ca.slack-edge.com/T0A4A3AQZ-U0A5L9L8K-7eda5a7e311c-512" },
  {email: 'laura@cookoon.fr', password: 'plopplop', first_name: 'Laura', last_name: 'Escure', description: 'Un bon user', phone_number: '0636686565', photo_url: "https://ca.slack-edge.com/T0A4A3AQZ-U0A5L9L8K-7eda5a7e311c-512" }
]
puts "Seeding Users"
users_attributes.each { |attributes| User.create! attributes }
puts "Users done"

cookoons_attributes = [
  {
    user: User.first,
    name: "Salon cozy",
    surface: 50,
    price_cents: 2500,
    price_currency: "EUR",
    address: "140 rue du Temple, 75003 Paris",
    capacity: "4",
    category: 'Appartement',
    description: "Au sommet d'un des plus hauts immeubles des batignolles, l'appartement de Laura & Grégory offre une vue à 180 ° sur tout Paris, de Montmartre à la Tour Eiffel. Il pourra ainsi aussi bien accueillir une réunion de travail pour 6 personnes, un dîner entre amis ou un tête à tête romantique.",
    photo_urls: ["http://cookoon.fr/img/marais/marais4.jpg", "http://cookoon.fr/img/marais/marais1.jpg", "http://cookoon.fr/img/marais/marais2.jpg", "http://cookoon.fr/img/marais/marais3.jpg"]
  },
  {
    user: User.first,
    name: "Vue sur les toits des Batignolles",
    surface: 70,
    price_cents: 3000,
    price_currency: "EUR",
    address: "83 rue des Dames, 75017 Paris",
    capacity: "6",
    category: 'Appartement',
    description: "Au sommet d'un des plus hauts immeubles des batignolles, l'appartement de Laura & Grégory offre une vue à 180 ° sur tout Paris, de Montmartre à la Tour Eiffel. Il pourra ainsi aussi bien accueillir une réunion de travail pour 6 personnes, un dîner entre amis ou un tête à tête romantique.",
    photo_urls: ["http://cookoon.fr/img/clichy/clichy1.jpg", "http://cookoon.fr/img/clichy/clichy2.jpg", "http://cookoon.fr/img/clichy/clichy3.jpg", "http://cookoon.fr/img/clichy/clichy4.jpg"]
  },
  {
    user: User.first,
    name: "Grand Salon 1930 - Silicon Sentier",
    surface: 100,
    price_cents: 3000,
    price_currency: "EUR",
    address: "85 rue d'Aboukir', 75002 Paris",
    capacity: "8",
    category: 'Appartement',
    description: "La rue Montorgueil, Numa, les Start up et l'appartement de Marie & Guillaume, nous sommes dans le Sentier. A quelques minutes du métro (Sentier, ligne 3), l'appartement a bénéficié des talents d'architecte d'intérieur de Marie qui a su conférer un style année 30 modernisé à son intérieur. Ici tout est ouvert, la cuisine est séparée du salon par un bar qui cotoie également la partie salle à manger. Un lieu idéal pour une journée de formation, un rdv professionnel mais également un dîner entre amis.",
    photo_urls: ["http://cookoon.fr/img/aboukir/aboukir.jpg", "http://cookoon.fr/img/aboukir/aboukir2.jpg", "http://cookoon.fr/img/aboukir/aboukir3.jpg", "http://cookoon.fr/img/aboukir/aboukir4.jpg", "http://cookoon.fr/img/aboukir/aboukir5.jpg"]
  },
  {
    user: User.first,
    name: "Salle de réunion - République",
    surface: 120,
    price_cents: 3000,
    price_currency: "EUR",
    address: "174 rue du Temple, 75003 Paris",
    capacity: "10",
    category: 'Appartement',
    description: "En plein Paris, au métro République, nous trouvons les locaux de l'agence Le Rendez-Vous à Paris. A quelques minutes du métro (République ou Temple), le bureau bénéficie d'une situation particulièrement priviligée quand on cherche à se retrouver pour une réunion de travail. Entre Marais et République, le bureau est entouré de restaurants et de commerces. Vous y trouverez tout ce dont vous avez besoin pour vos journées de travail hors-les-murs ou de formation.",
    photo_urls: ["http://cookoon.fr/img/republique/republique1.jpg", "http://cookoon.fr/img/republique/republique2.jpg", "http://cookoon.fr/img/republique/republique3.jpg"]
  },
  {
    user: User.first,
    name: "Maison de Campagne à Paris",
    surface: 200,
    price_cents: 4000,
    price_currency: "EUR",
    address: "15 Rue Paul Strauss, 75020 Paris",
    capacity: "10",
    category: 'Maison',
    description: "Situé au sein de la campagne à Paris, la maison de Jean Sébastien est l'idéal pour un repas, une réunion ou une journée de formation. Son jardin pourra également accueillir un brunch ou un bbq, l'été venu. Et peut-être Jean-Seb vous proposera une table d'hôtes?",
    photo_urls: ["http://cookoon.fr/img/bagnolet/bagnolet.jpg", "http://cookoon.fr/img/bagnolet/bagnolet2.jpg", "http://cookoon.fr/img/bagnolet/bagnolet3.jpg", "http://cookoon.fr/img/bagnolet/bagnolet4.jpg", "http://cookoon.fr/img/bagnolet/bagnolet5.jpg"]
  }
]
puts "Seeding Cookoons"
cookoons_attributes.each do |attributes|
  Cookoon.create! attributes
end
puts "Cookoons done"
