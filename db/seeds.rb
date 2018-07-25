puts 'Destroying'
Inventory.destroy_all
Reservation.destroy_all
Cookoon.destroy_all
CookoonSearch.destroy_all
User.destroy_all

users_attributes = [
  { email: 'quentin@cookoon.fr', password: 'plopplop', first_name: 'Quentin', last_name: 'Pernez', description: 'Un bon user', phone_number: '0636686565', photo_url: "https://ca.slack-edge.com/T0A4A3AQZ-U0A5L9L8K-7eda5a7e311c-512", admin: true },
  { email: 'charles@cookoon.fr', password: 'plopplop', first_name: 'Charles', last_name: 'Pernet', description: 'Un user heureux', phone_number: '0660283574', photo_url: "https://ca.slack-edge.com/T0A4A3AQZ-U5C18PEJZ-13810bfae838-512", admin: true },
  { email: 'gregory@cookoon.fr', password: 'plopplop', first_name: 'Gregory', last_name: 'Escure', description: 'Un bon user', phone_number: '0636686565', photo_url: "https://ca.slack-edge.com/T0A4A3AQZ-U0A5L9L8K-7eda5a7e311c-512", admin: true },
  { email: 'francois@cookoon.fr', password: 'azerty', first_name: 'François', last_name: 'Catuhe', description: 'Un bon user', phone_number: '0636686565', photo_url: "https://ca.slack-edge.com/T0A4A3AQZ-U0A5L9L8K-7eda5a7e311c-512", admin: true },
  { email: 'laura@cookoon.fr', password: 'plopplop', first_name: 'Laura', last_name: 'Escure', description: 'Un bon user', phone_number: '0636686565', photo_url: "https://ca.slack-edge.com/T0A4A3AQZ-U0A5L9L8K-7eda5a7e311c-512", admin: true }
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
    status: :approved,
    description: "Au sommet d'un des plus hauts immeubles des batignolles, l'appartement de Laura & Grégory offre une vue à 180 ° sur tout Paris, de Montmartre à la Tour Eiffel. Il pourra ainsi aussi bien accueillir une réunion de travail pour 6 personnes, un dîner entre amis ou un tête à tête romantique.",
    photo_urls: ["http://res.cloudinary.com/cookoon-dev/image/upload/v1530622600/rm6kobv8rpjwha7jpz2o.jpg"]
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
    status: :approved,
    description: "Au sommet d'un des plus hauts immeubles des batignolles, l'appartement de Laura & Grégory offre une vue à 180 ° sur tout Paris, de Montmartre à la Tour Eiffel. Il pourra ainsi aussi bien accueillir une réunion de travail pour 6 personnes, un dîner entre amis ou un tête à tête romantique.",
    photo_urls: ["http://res.cloudinary.com/cookoon-dev/image/upload/v1530622600/rm6kobv8rpjwha7jpz2o.jpg"]
  },
  {
    user: User.second,
    name: "Grand Salon 1930 - Silicon Sentier",
    surface: 100,
    price_cents: 3000,
    price_currency: "EUR",
    address: "85 rue d'Aboukir, 75002 Paris",
    capacity: "8",
    category: 'Appartement',
    status: :approved,
    description: "La rue Montorgueil, Numa, les Start up et l'appartement de Marie & Guillaume, nous sommes dans le Sentier. A quelques minutes du métro (Sentier, ligne 3), l'appartement a bénéficié des talents d'architecte d'intérieur de Marie qui a su conférer un style année 30 modernisé à son intérieur. Ici tout est ouvert, la cuisine est séparée du salon par un bar qui cotoie également la partie salle à manger. Un lieu idéal pour une journée de formation, un rdv professionnel mais également un dîner entre amis.",
    photo_urls: ["http://res.cloudinary.com/cookoon-dev/image/upload/v1530622600/rm6kobv8rpjwha7jpz2o.jpg"]
  },
  {
    user: User.second,
    name: "Salle de réunion - République",
    surface: 120,
    price_cents: 3000,
    price_currency: "EUR",
    address: "174 rue du Temple, 75003 Paris",
    capacity: "10",
    category: 'Appartement',
    status: :approved,
    description: "En plein Paris, au métro République, nous trouvons les locaux de l'agence Le Rendez-Vous à Paris. A quelques minutes du métro (République ou Temple), le bureau bénéficie d'une situation particulièrement priviligée quand on cherche à se retrouver pour une réunion de travail. Entre Marais et République, le bureau est entouré de restaurants et de commerces. Vous y trouverez tout ce dont vous avez besoin pour vos journées de travail hors-les-murs ou de formation.",
    photo_urls: ["http://res.cloudinary.com/cookoon-dev/image/upload/v1530622600/rm6kobv8rpjwha7jpz2o.jpg"]
  },
]
puts "Seeding Cookoons"
cookoons_attributes.each do |attributes|
  Cookoon.create! attributes
end
puts "Cookoons done"

puts 'Pro section'

puts 'Seeding Companies'
Company.create!(name: "Réceptions Nouvelles", address: "12 rue Lincoln, 75008 Paris", siren: 821316239, siret: 82131623900010, vat: "FR 28 821316239")
puts 'Companies done'

puts 'Seeding Pro::Quotes'
Pro::Quote.create(user: User.find(4), company: Company.first, start_at: 1.day.from_now, duration: 2, people_count: 4)
puts 'Pro::Quotes done'
