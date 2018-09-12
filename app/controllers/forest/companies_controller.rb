module Forest
  class CompaniesController < ForestLiana::ApplicationController
    def invite_user
      attrs = params.dig('data', 'attributes', 'values')
      attributes = {
        company_id: params.dig('data', 'attributes', 'ids').first,
        email: attrs['Email'],
        first_name: attrs['First name'],
        last_name: attrs['Last name']
      }
      inviter = ::User.find_by(email: 'gregory@cookoon.fr')
      ::User.pro_invite!(attributes, inviter)

      render json: { html: '<h1>Invitaion envoyée!</h1>' }
    end
  end
end
