class TrelloReservationService
  include MoneyRails::ActionViewExtension
  include ActionView::Helpers::TranslationHelper
  include DatetimeHelper

  TRELLO_LISTS_IDS = {
    reservation_board_id: '5a25793534f1ae1cfe4ee2f3',
    pending_list_id: '5a2579418ee80817fe7bc895',
    paid_list_id: '5a257963d78c51fb153efcc9',
    accepted_list_id: '5a257967cdb5c264f6b366b3',
    refused_list_id: '5a25796e043080a82bbb7d00',
    cancelled_list_id: '5a2579740c812810b01aeea0',
    ongoing_list_id: '5a25798044d805dc0874fac0',
    passed_list_id: '5a257983040c2a29948c4a1e'
  }.freeze

  def initialize(attributes)
    @reservation = attributes[:reservation]
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
  end

  def create_trello_card
    create_card
    card&.id
  end

  def move_card
    retrieve_card
    move_card_to_desired_list
  end

  def enrich_and_move_card
    retrieve_card
    enrich_description
    move_card_to_desired_list
  end

  private

  attr_accessor :reservation
  attr_reader :card, :host, :tenant, :cookoon

  def enrich_description
    return unless card
    card.desc = description
    card.save
  end

  def move_card_to_desired_list
    return unless card
    card.move_to_list(list_id)
  rescue Trello::Error
    Rails.logger.error("Faild to move Trello Card to #{reservation.status}_list")
    false
  end

  def retrieve_card
    @card = Trello::Card.find(reservation.trello_card_id)
  rescue Trello::Error
    Rails.logger.error('Faild to retrieve Trello Card')
    false
  end

  def list_id
    id = TRELLO_LISTS_IDS["#{reservation.status}_list_id".to_sym]
    # prevent bug from tello api if id is nil
    id ? id : ''
  end

  def create_card
    @card = Trello::Card.create(
      list_id: TRELLO_LISTS_IDS[:pending_list_id],
      name: "#{cookoon.name} - #{display_datetime_for(reservation.date, join_expression: 'à', without_year: true)}",
      desc: description
    )
  rescue Trello::Error => e
    Rails.logger.error('Failed to create Trello Card')
    Rails.logger.error(e.message)
    false
  end

  def description
    desc_string = "**locataire : #{tenant.full_name} [#{tenant.id}]** \n"
    desc_string << "email: #{tenant.email} \n"
    desc_string << "téléphone: #{tenant.phone_number} \n"
    desc_string << "**propriétaire : #{host.full_name} [#{host.id}]** \n"
    desc_string << "email: #{host.email} \n"
    desc_string << "téléphone: #{host.phone_number} \n"
    desc_string << "\n"
    desc_string << "**prix payé par le locataire :** #{humanized_money_with_symbol reservation.price_with_fees} \n"
    desc_string << "**somme versée à l'hôte :** #{humanized_money_with_symbol reservation.payout_price_for_host} \n"

    if reservation.catering
      desc_string << "\n"
      desc_string << "**SERVICE TRAITEUR À PRÉVOIR** \n"
    end

    if reservation.cleaning
      desc_string << "\n"
      desc_string << "**SERVICE MENAGE À PRÉVOIR** \n"
    end

    if reservation.janitor
      desc_string << "\n"
      desc_string << "**SERVICE CONCIERGE À PRÉVOIR** \n"
    end

    desc_string
  end
end
