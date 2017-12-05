class TrelloReservationService
  RESERVATION_BOARD_ID = '5a25793534f1ae1cfe4ee2f3'
  PENDING_LIST_ID = '5a2579418ee80817fe7bc895'
  PAID_LIST_ID = '5a257963d78c51fb153efcc9'
  ACCEPTED_LIST_ID = '5a257967cdb5c264f6b366b3'
  REFUSED_LIST_ID = '5a25796e043080a82bbb7d00'
  CANCELLED_LIST_ID = '5a2579740c812810b01aeea0'
  ONGOING_LIST_ID = '5a25798044d805dc0874fac0'
  PASSED_LIST_ID = '5a257983040c2a29948c4a1e'

  def initialize(attributes)
    @reservation = attributes[:reservation]
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
  end

  def create_trello_card_and_save_reservation
    create_trello_card
    @card ? save_card_id_in_reservation : false
  end

  def displayable_errors
    @errors.any? ? @errors.join(' ') : 'Erreur'
  end

  private

  def save_card_id_in_reservation
    @reservation.trello_card_id = @card.id
    @reservation.save
  end

  def create_trello_card
    @card = Trello::Card.create(
      list_id: PENDING_LIST_ID,
      name: "#{@cookoon.name} - #{@reservation.date.strftime('%d/%m/%Y')}",
      desc: description
    )
  rescue Trello::Error => e
    Rails.logger.error('Failed to create Trello Card')
    Rails.logger.error(e.message)
    false
  end

  def description
    desc_string = "**locataire : #{@tenant.full_name} [#{@tenant.id}]** \n"
    desc_string << "email: #{@tenant.email} \n"
    desc_string << "téléphone: #{@tenant.phone_number} \n"
    desc_string << "**propriétaire : #{@host.full_name} [#{@host.id}]** \n"
    desc_string << "email: #{@host.email} \n"
    desc_string << "téléphone: #{@host.phone_number} \n"
    desc_string << "\n"
    desc_string << "**prix payé par le locataire :** #{@reservation.price_for_rent_with_fees} € \n"
    desc_string << "**somme versée à l'hôte :** #{@reservation.payout_price_for_host} € \n"

    if @reservation.catering
      desc_string << "\n"
      desc_string << '**SERVICE TRAITEUR À PRÉVOIR**'
    end

    desc_string
  end
end
