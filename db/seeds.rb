puts 'Destroying'
Reservation.destroy_all
Perk.destroy_all
Cookoon.destroy_all
PerkSpecification.destroy_all
AmexCode.destroy_all
User.destroy_all
Company.destroy_all
Dish.destroy_all
Menu.destroy_all
Chef.destroy_all
ChefPerk.destroy_all
ChefPerkSpecification.destroy_all

puts 'Seeding Companies'
Company.create!(name: "Réceptions Nouvelles", address: "30 rue des Dames, 75017 Paris", siren: 821316239, siret: 82131623900010, vat: "FR 28 821316239", referent_email: 'gregory@cookoon.fr')
puts 'Companies done'

perks_specification_attributes = [
  { name: "Écran", icon_name: "fas fa-tv" },
  { name: "Système son", icon_name: "fas fa-music" },
  { name: "Cuisine équipée", icon_name: "fas fa-utensils" },
  { name: "Ascenseur", icon_name: "fas fa-level-up-alt" },
  { name: "Barbecue", icon_name: "fas fa-hotdog" },
  { name: "Cheminée", icon_name: "fas fa-fire" },
  { name: "Chromecast", icon_name: "fab fa-chrome" },
  { name: "Apple TV", icon_name: "fab fa-apple" },
  { name: "Jacuzzi", icon_name: "fas fa-swimming-pool" },
  { name: "Sauna", icon_name: "fas fa-hot-tub" },
  { name: "Rooftop", icon_name: "fas fa-chess-rook" },
  { name: "Piscine", icon_name: "fas fa-swimmer" },
  { name: "Oeuvres d'art", icon_name: "fas fa-palette" },
  { name: "Accessible handicapé", icon_name: "fas fa-wheelchair" }
]
puts "Seeding Perks Specification"
perks_specification_attributes.each { |attributes| PerkSpecification.create! attributes }
puts "Perks Specification done"

users_attributes = [
  { email: 'quentin@cookoon.fr', password: 'plopplop', first_name: 'Quentin', last_name: 'Pernez', description: 'Un bon user', phone_number: '0636686565', photo_url: "https://ca.slack-edge.com/T0A4A3AQZ-U0A5L9L8K-7eda5a7e311c-512", admin: true, address: "8 rue de la Vrillière, Paris", invitation_limit: 100, company: Company.first },
  { email: 'charles@cookoon.fr', password: 'plopplop', first_name: 'Charles', last_name: 'Pernet', description: 'Un user heureux', phone_number: '0660283574', photo_url: "https://ca.slack-edge.com/T0A4A3AQZ-U5C18PEJZ-13810bfae838-512", admin: true, address: "8 rue de la Vrillière, Paris", invitation_limit: 100, company: Company.first },
  { email: 'gregory@cookoon.fr', password: 'plopplop', first_name: 'Gregory', last_name: 'Escure', description: 'Un bon user', phone_number: '0636686565', photo_url: "https://ca.slack-edge.com/T0A4A3AQZ-U0A5L9L8K-7eda5a7e311c-512", admin: true, address: "8 rue de la Vrillière, Paris", invitation_limit: 100, company: Company.first },
  { email: 'francois@cookoon.fr', password: 'azerty', first_name: 'François', last_name: 'Catuhe', description: 'Un bon user', phone_number: '0636686565', photo_url: "https://ca.slack-edge.com/T0A4A3AQZ-U0A5L9L8K-7eda5a7e311c-512", admin: true, address: "8 rue de la Vrillière, Paris", invitation_limit: 100, company: Company.first },
  { email: 'laura@cookoon.fr', password: 'plopplop', first_name: 'Laura', last_name: 'Escure', description: 'Un bon user', phone_number: '0636686565', photo_url: "https://ca.slack-edge.com/T0A4A3AQZ-U0A5L9L8K-7eda5a7e311c-512", admin: true, address: "8 rue de la Vrillière, Paris", invitation_limit: 100, company: Company.first }
]

puts "Seeding Users"
# users_attributes.each { |attributes| User.create! attributes }
users_attributes.each do |user_attribute|
  user = User.new(user_attribute)
  user.build_job(job_title: "Développeur", company: "Cookoon", linkedin_profile: "https://www.linkedin.com/in/alice-fabre-676211182/")
  user.build_personal_taste(favorite_wines: "Roederer Brut Premier / Côte Rôtie, Stéphane Ogier", favorite_restaurants: "Guy Savoy, Michel Sarran, Frédéric Simonin")
  user.build_motivation(content: "Je suis un épicurien.")
  user.save
end
puts "Users done"

puts "Seeding Amex Codes"
amex_codes_attributes = [
  { code: SecureRandom.hex(4), email: 'a@test.fr' },
  { code: SecureRandom.hex(4), email: 'b@test.fr' },
  { code: SecureRandom.hex(4), email: 'c@test.fr' },
  { code: SecureRandom.hex(4), email: 'd@test.fr' },
  { code: SecureRandom.hex(4), email: 'e@test.fr' },
  { code: SecureRandom.hex(4), email: 'f@test.fr' },
  { code: SecureRandom.hex(4), email: 'g@test.fr' },
  { code: SecureRandom.hex(4), email: 'h@test.fr' },
]
AmexCode.create! amex_codes_attributes
puts "Amex Codes done"

cookoons_attributes = [
  {
    user: User.first,
    name: "Salon cozy",
    surface: 50,
    price_cents: 2500,
    price_currency: "EUR",
    address: "140 rue du Temple, 75003 Paris",
    capacity: "15",
    capacity_standing: "30",
    category: 'Appartement',
    status: :approved,
    description: "Au sommet d'un des plus hauts immeubles des batignolles, l'appartement de Laura & Grégory offre une vue à 180 ° sur tout Paris, de Montmartre à la Tour Eiffel. Il pourra ainsi aussi bien accueillir une réunion de travail pour 6 personnes, un dîner entre amis ou un tête à tête romantique.",
    photo_urls: [
                  "https://images.unsplash.com/photo-1527030280862-64139fba04ca?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                  "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                  "https://images.unsplash.com/photo-1502672023488-70e25813eb80?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                  "https://images.unsplash.com/photo-1556912167-f556f1f39fdf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"
                ],
    long_photo_url: "https://images.unsplash.com/photo-1575379047099-155c957f7bab?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
    main_photo_url: "https://images.unsplash.com/photo-1551516594-56cb78394645?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
    citation: "Un écrin de verdure dans Paris",
    architect_name: "Alice Fabre",
    architect_title: "Architecte - décorateur",
    architect_build_year: 2020,
    architect_url: "htpps://membre.cookoon.club",
    amex: true
  },
  {
    user: User.first,
    name: "Vue sur les toits des Batignolles",
    surface: 70,
    price_cents: 3000,
    price_currency: "EUR",
    address: "83 rue des Dames, 75017 Paris",
    capacity: "15",
    capacity_standing: "30",
    category: 'Appartement',
    status: :approved,
    description: "Au sommet d'un des plus hauts immeubles des batignolles, l'appartement de Laura & Grégory offre une vue à 180 ° sur tout Paris, de Montmartre à la Tour Eiffel. Il pourra ainsi aussi bien accueillir une réunion de travail pour 6 personnes, un dîner entre amis ou un tête à tête romantique.",
    photo_urls: [
                  "https://images.unsplash.com/photo-1484154218962-a197022b5858?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                  "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                  "https://images.unsplash.com/photo-1493150134366-cacb0bdc03fe?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                  "https://images.unsplash.com/photo-1565538810643-b5bdb714032a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"
                ],
    long_photo_url: "https://images.unsplash.com/photo-1508502726440-477c94bc369e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
    main_photo_url: "https://images.unsplash.com/photo-1561024172-0ae2ebd65018?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
    citation: "Une vue splendide sur les toits de Paris",
  },
  {
    user: User.second,
    name: "Grand Salon 1930 - Silicon Sentier",
    surface: 100,
    price_cents: 3000,
    price_currency: "EUR",
    address: "85 rue d'Aboukir, 75002 Paris",
    capacity: "15",
    capacity_standing: "30",
    category: 'Appartement',
    status: :approved,
    description: "La rue Montorgueil, Numa, les Start up et l'appartement de Marie & Guillaume, nous sommes dans le Sentier. A quelques minutes du métro (Sentier, ligne 3), l'appartement a bénéficié des talents d'architecte d'intérieur de Marie qui a su conférer un style année 30 modernisé à son intérieur. Ici tout est ouvert, la cuisine est séparée du salon par un bar qui cotoie également la partie salle à manger. Un lieu idéal pour une journée de formation, un rdv professionnel mais également un dîner entre amis.",
    photo_urls: [
                  "https://images.unsplash.com/photo-1469022563428-aa04fef9f5a2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                  "https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                  "https://images.unsplash.com/photo-1497366754035-f200968a6e72?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                  "https://images.unsplash.com/photo-1556909172-54557c7e4fb7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"
                ],
    long_photo_url: "https://images.unsplash.com/photo-1513161455079-7dc1de15ef3e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
    main_photo_url: "https://images.unsplash.com/photo-1513694203232-719a280e022f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
    citation: "Un espace propice à la floraison de nouvelles idées",
    architect_name: "Grégory Escure",
    architect_title: "Architecte - décorateur",
    architect_build_year: 2020,
    architect_url: "htpps://membre.cookoon.club"
  },
  {
    user: User.second,
    name: "Salle de réunion - République",
    surface: 120,
    price_cents: 3000,
    price_currency: "EUR",
    address: "174 rue du Temple, 75003 Paris",
    capacity: "15",
    capacity_standing: "30",
    category: 'Appartement',
    status: :approved,
    description: "En plein Paris, au métro République, nous trouvons les locaux de l'agence Le Rendez-Vous à Paris. A quelques minutes du métro (République ou Temple), le bureau bénéficie d'une situation particulièrement priviligée quand on cherche à se retrouver pour une réunion de travail. Entre Marais et République, le bureau est entouré de restaurants et de commerces. Vous y trouverez tout ce dont vous avez besoin pour vos journées de travail hors-les-murs ou de formation.",
    photo_urls: [
                  "https://images.unsplash.com/photo-1499916078039-922301b0eb9b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                  "https://images.unsplash.com/photo-1536376072261-38c75010e6c9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                  "https://images.unsplash.com/photo-1497262693247-aa258f96c4f5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                  "https://images.unsplash.com/photo-1556910585-09baa3a3998e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"
                ],
    long_photo_url: "https://images.unsplash.com/photo-1502005229762-cf1b2da7c5d6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
    main_photo_url: "https://images.unsplash.com/photo-1559310278-18a9192d909f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
    citation: "Un espace vivant",
    amex: true
  },
]

perks_attributes = [
  { perk_specification: PerkSpecification.first },
  { perk_specification: PerkSpecification.last },
]

puts "Seeding Cookoons"
# Cookoon.create! cookoons_attributes
cookoons_attributes.each do |cookoon_attribute|
  cookoon = Cookoon.new(cookoon_attribute)
  cookoon.perks.build(perk_specification: PerkSpecification.first)
  cookoon.perks.build(perk_specification: PerkSpecification.last)
  cookoon.save
end
puts "Cookoons done"

chef_attributes = [
  {
    name: 'Hélène Darroze',
    description: "Elle officie dans son restaurant gastronomique du 6e arrondissement de Paris, le Marsan (qui portait auparavant son nom).
      Sa cuisine est récompensée d'une note de 15/20 au Gault-Millau et l'obtention de deux étoiles au Guide Michelin en 2003.
      Cela en fait une des seules cheffes étoilées en activité avec Anne-Sophie Pic et Julia Sedefdjian.",
    photo_urls: ["https://images.unsplash.com/photo-1514326640560-7d063ef2aed5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60", "https://images.unsplash.com/photo-1542197745-c70e10f66af8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"],
    min_price: 500,
    references: "Restaurant : Hélène Darroze",
    main_photo_url: "https://static.lexpress.fr/medias_11664/w_2048,h_1146,c_crop,x_0,y_0/w_1000,h_563,c_fill,g_north/v1509987362/helene-darroze-portrait_5972444.jpg",
    citation: "Je suis un super Chef",
    gender: "female",
    amex: true
  },
  {
    name: 'Gordon Ramsay',
    description: "Également présentateur de plusieurs émissions télévisées consacrées à la cuisine ou à la restauration,
      telles que The F Word, MasterChef, ou encore la célèbre émission Ramsay's Kitchen Nightmares
      (diffusée en France sous le nom de Cauchemar en cuisine), il compte parmi les trois cuisiniers ayant été gratifiés
      de trois étoiles en une fois par l'édition britannique du Guide Michelin.",
    photo_urls: ["https://images.unsplash.com/photo-1514326640560-7d063ef2aed5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60", "https://images.unsplash.com/photo-1542197745-c70e10f66af8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"],
    min_price: 500,
    references: "Restaurant : le Gordon\nPublications: Mes meilleures recettes",
    main_photo_url: "https://upload.wikimedia.org/wikipedia/commons/6/6f/Gordon_Ramsay.jpg",
    citation: "Je suis un super Chef",
    gender: "male"
  },
  {
    name: 'Baptiste Renouard',
    description: "Avant la 10ème édition de Top Chef, Baptiste a travaillé avec des chefs prestigieux tel que Paolo Boscaro, Yannick Alléno et Frédéric Simonin.
      À seulement 13 ans il effectua un stage chez Robuchon puis le retrouvera à nouveau plus tard, ce qui provoquera un déclic sur l'art de la restauration.
      Pendant son passage à Top Chef, il ouvre son propre restaurant, Ochre, et poursuit son rêve de décrocher une étoile au guide Michelin.",
    photo_urls: ["https://images.unsplash.com/photo-1514326640560-7d063ef2aed5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60", "https://images.unsplash.com/photo-1542197745-c70e10f66af8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"],
    min_price: 500,
    references: "",
    main_photo_url: "https://res.cloudinary.com/cookoon/image/upload/v1598366705/pp9fhlmnzyi4p4yvikga.jpg",
    citation: "Je suis un super Chef",
    gender: "male",
    amex: true
  }
]

puts 'Seeding Chefs'
Chef.create! chef_attributes
puts 'Chefs done'

menu_attributes = [
  {
    chef: Chef.first,
    status: "active",
    unit_price_cents: 5000,
    meal_type: "seated_meal",
    description: <<-DESCRIPTION
      Menu d'hiver
    DESCRIPTION
  },
  {
    chef: Chef.first,
    status: "active",
    unit_price_cents: 3000,
    description: "Menu de printemps",
    meal_type: "seated_meal"
  },
  {
    chef: Chef.first,
    status: "amex",
    unit_price_cents: 3000,
    description: "Menu Amex I",
    meal_type: "seated_meal"
  },
  {
    chef: Chef.second,
    status: "active",
    unit_price_cents: 3500,
    description: "Menu d'été",
    meal_type: "seated_meal"
  },
  {
    chef: Chef.second,
    status: "active",
    unit_price_cents: 5000,
    description: "Cocktail d'automne",
    meal_type: "standing_meal"
  },
  {
    chef: Chef.last,
    status: "active",
    unit_price_cents: 3500,
    description: "Menu I",
    meal_type: "seated_meal"
  },
  {
    chef: Chef.last,
    status: "active",
    unit_price_cents: 5000,
    description: "Menu II",
    meal_type: "seated_meal"
  },
  {
    chef: Chef.last,
    status: "amex",
    unit_price_cents: 5000,
    description: "Menu Amex II",
    meal_type: "seated_meal"
  },
]

puts 'Seeding Menus'
Menu.create! menu_attributes
puts 'Menus done'

dish_attributes = [
  {
    name: "La sardine",
    category: "Entrée",
    order: 1,
    menu: Menu.first,
  },
  {
    name: "Le canard",
    category: "Plat",
    order: 2,
    menu: Menu.first,
  },
  {
    name: "La passion cuisinée comme ma grand-mère",
    category: "Dessert",
    order: 3,
    menu: Menu.first,
  },
  {
    name: "Le maquereau",
    category: "Entrée",
    order: 1,
    menu: Menu.second,
  },
  {
    name: "Le bar cuisinée comme ma grand-mère",
    category: "Plat",
    order: 2,
    menu: Menu.second,
  },
  {
    name: "Le chocolat",
    category: "Dessert",
    order: 3,
    menu: Menu.second,
  },
  {
    name: "La sardine amex",
    category: "Entrée",
    order: 1,
    menu: Menu.third,
  },
  {
    name: "Le canard amex",
    category: "Plat",
    order: 2,
    menu: Menu.third,
  },
  {
    name: "La passion amex",
    category: "Dessert",
    order: 3,
    menu: Menu.third,
  },
  {
    name: "La Saint-Jacques cuisinée comme ma grand-mère",
    category: "Entrée",
    order: 1,
    menu: Menu.fourth,
  },
  {
    name: "Le boeuf",
    category: "Plat",
    order: 2,
    menu: Menu.fourth,
  },
  {
    name: "Le tiramisu",
    category: "Dessert",
    order: 3,
    menu: Menu.fourth,
  },
  {
    name: "La tomate",
    category: "Entrée",
    order: 1,
    menu: Menu.fifth,
  },
  {
    name: "L'agneau",
    category: "Plat",
    order: 2,
    menu: Menu.fifth,
  },
  {
    name: "La poire",
    category: "Dessert",
    order: 3,
    menu: Menu.fifth,
  },
  {
    name: "Les gambas",
    category: "Entrée",
    order: 1,
    menu: Menu.find(Menu.last.id - 2),
  },
  {
    name: "Le saumon",
    category: "Plat",
    order: 2,
    menu: Menu.find(Menu.last.id - 2),
  },
  {
    name: "Le chocolat",
    category: "Dessert",
    order: 3,
    menu: Menu.find(Menu.last.id - 2),
  },
  {
    name: "Les crevettes",
    category: "Entrée",
    order: 1,
    menu: Menu.find(Menu.last.id - 1),
  },
  {
    name: "L'agneau",
    category: "Plat",
    order: 2,
    menu: Menu.find(Menu.last.id - 1),
  },
  {
    name: "La pomme",
    category: "Dessert",
    order: 3,
    menu: Menu.find(Menu.last.id - 1),
  },
  {
    name: "Les crevettes amex",
    category: "Entrée",
    order: 1,
    menu: Menu.last,
  },
  {
    name: "L'agneau amex",
    category: "Plat",
    order: 2,
    menu: Menu.last,
  },
  {
    name: "La pomme amex",
    category: "Dessert",
    order: 3,
    menu: Menu.last,
  }
]

puts 'Seeding Dishes'
Dish.create! dish_attributes
puts 'Dishes done'

chef_perk_specification_attributes = [
  {
    name: "Une étoile Michelin",
    image_url: "https://res.cloudinary.com/cookoon-dev/image/upload/v1594833585/Logo_Michelin_1etoile_tivpy2.png"
  },
  {
    name: "Deux étoiles Michelin",
    image_url: "https://res.cloudinary.com/cookoon-dev/image/upload/v1594833585/Logo_Michelin_2etoiles_ezcpaa.png"
  },
  {
    name: "Trois étoiles Michelin",
    image_url: "https://res.cloudinary.com/cookoon-dev/image/upload/v1594833585/Logo_Michelin_3etoiles_fxkghq.png"
  },
  {
    name: "Jury Top Chef",
    image_url: "https://res.cloudinary.com/cookoon-dev/image/upload/v1594833585/Logo_TopChef_2_q3blhl.png"
  },
  {
    name: "Candidat Top Chef",
    image_url: "https://res.cloudinary.com/cookoon-dev/image/upload/v1594833585/Logo_TopChef_qklaxx.png"
  },
  {
    name: "Institut Paul Bocuse",
    image_url: "https://res.cloudinary.com/cookoon-dev/image/upload/v1594833585/Logo_PaulBocuse_tpanrs.png"
  },
]

puts 'seeding Chef perk specifications'
ChefPerkSpecification.create! chef_perk_specification_attributes
puts 'Chef perk specifications done'

chef_perk_attributes = [
  {
    chef: Chef.first,
    chef_perk_specification: ChefPerkSpecification.fourth,
  },
  {
    chef: Chef.first,
    chef_perk_specification: ChefPerkSpecification.first,
  },
  {
    chef: Chef.first,
    chef_perk_specification: ChefPerkSpecification.last,
  },
  {
    chef: Chef.second,
    chef_perk_specification: ChefPerkSpecification.last,
  },
  {
    chef: Chef.second,
    chef_perk_specification: ChefPerkSpecification.second,
  },
  {
    chef: Chef.third,
    chef_perk_specification: ChefPerkSpecification.last,
  },
  {
    chef: Chef.third,
    chef_perk_specification: ChefPerkSpecification.second,
  },
]

puts 'seeding Chef perks'
ChefPerk.create! chef_perk_attributes
puts 'Chef perks done'
