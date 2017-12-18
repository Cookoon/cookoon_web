class TrelloCookoonService
  include CloudinaryHelper
  include MoneyRails::ActionViewExtension

  TRELLO_LISTS_IDS = {
    under_review_list_id: '5a253938f1a56c25084f5400',
    approved_list_id: '5a2e482923c373d2c8769bd7',
    suspended_list_id: '5a2e4847258b5c7821ff7ddf'
  }.freeze

  def initialize(attributes)
    @cookoon = attributes[:cookoon]
    @owner = @cookoon.user
  end

  def create_trello_card
    create_card
    add_attached_map
    add_attached_pictures
    save_card
    card&.id
  end

  def move_card
    retrieve_card
    move_card_to_desired_list
  end

  private

  attr_accessor :cookoon
  attr_reader :card, :owner

  def create_card
    @card = Trello::Card.create(
      list_id: TRELLO_LISTS_IDS[:under_review_list_id],
      name: cookoon.name,
      desc: description
    )
  rescue Trello::Error => e
    Rails.logger.error('Failed to create Trello Card')
    Rails.logger.error(e.message)
    false
  end

  def add_attached_pictures
    return false unless card
    cookoon.photos.each do |photo|
      picture_url = cl_image_path(photo.path)
      card.add_attachment(picture_url)
    end
  rescue Trello::Error => e
    Rails.logger.error('Failed to add pictures')
    Rails.logger.error(e.message)
    false
  end

  def add_attached_map
    return false unless card
    google_base_url = "https://maps.googleapis.com/maps/api/staticmap?key=#{ENV['GOOGLE_API_KEY']}&size=600x400&zoom=15"
    map_url = google_base_url + "&markers=#{cookoon.latitude},#{cookoon.longitude}"
    card.add_attachment(map_url)
  rescue Trello::Error => e
    Rails.logger.error('Failed to add Map')
    Rails.logger.error(e.message)
    false
  end

  def save_card
    return false unless card
    card.save
  rescue Trello::Error => e
    Rails.logger.error('Failed to save Card')
    Rails.logger.error(e.message)
    false
  end

  def move_card_to_desired_list
    return unless card
    card.move_to_list(list_id)
  rescue Trello::Error
    Rails.logger.error("Failed to move Trello Card to #{cookoon.status}_list")
    false
  end

  def retrieve_card
    @card ||= Trello::Card.find(cookoon.trello_card_id)
  rescue Trello::Error
    Rails.logger.error('Failed to retrieve Trello Card')
    false
  end

  def list_id
    id = TRELLO_LISTS_IDS["#{cookoon.status}_list_id".to_sym]
    # prevent bug from tello api if id is nil
    id ? id : ''
  end

  def description
    desc_string = "**Nom : #{cookoon.name}** \n"
    desc_string << "**propriétaire : #{owner.full_name} [#{owner.id}]** \n"
    desc_string << "email: #{owner.email} \n"
    desc_string << "téléphone: #{owner.phone_number} \n"
    desc_string << "\n"
    desc_string << "**Adresse :** \n"
    desc_string << "#{cookoon.address} \n"
    desc_string << "\n"
    desc_string << "**Capacité :** \n"
    desc_string << "#{cookoon.capacity} personnes \n"
    desc_string << "\n"
    desc_string << "**Prix/H :** \n"
    desc_string << "#{humanized_money_with_symbol cookoon.price} \n"

    desc_string
  end
end
