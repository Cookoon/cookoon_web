class Stripe::WebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized
  protect_from_forgery except: [:source_chargeable, :charge_succeeded]

  def source_chargeable
    # Process webhook data in `params`
    # TODO : proceed Reservation payment

    # Impossible d'identifier une réservation avec l'objet retourné
    # Action manuelle via stripe Dashboard

    # customer = params['data']['customer']
    # company = Company.find_by_stripe_customer_id(customer)
    # ====DOUTE AUTOUR DE LA SELECTION DE RESA===
      # reservation = company.quotes.confirmed.last.reservations.last
    # ===========================================
    # source = company.retrieve_stripe_sources('source').data.first.id
    # reservation.payment({source: source}).proceed
    render json: { message: "OK" }, status: :ok
  end

  def charge_succeeded
    # TODO : Transition reservation to paid
    # charge_id = params['data']['object']['id']
    # reservation = Pro::Reservation.find_by_stripe_charge_id(charge_id)
    # reservation.sepa_captured! or other status

    render json: { message: "OK" }, status: :ok
  end
end
