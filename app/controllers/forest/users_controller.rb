module Forest
  class UsersController < ForestLiana::ApplicationController
    def award_invitations
      ids = params.dig(:data, :attributes, :ids).map(&:to_i)
      invitation_quantity = params.dig(:data, :attributes, :values, :quantity).to_i
      message = params.dig(:data, :attributes, :values, :message)

      users = ::User.where(id: ids)
      users.each do |user|
        user.invitation_limit += invitation_quantity
        UserMailer.notify_invitations_awarded(user, invitation_quantity, message).deliver_later if user.invitation_accepted?
        user.save(validate: false)
      end

      render json: { html: '<h1>Messages sent!</h1>' }
    end

    def change_emailing_preferences
      ids = params.dig(:data, :attributes, :ids).map(&:to_i)
      preference = params.dig(:data, :attributes, :values, :emailing_preferences)
      users = ::User.where(id: ids)
      users.each do |user|
        case preference
        when 'Aucun e-mail'
          user.emailing_preferences = :no_emails
          render json: { html: '<h1>Emailing Preferences changed!</h1><p>This user will no longer receive email</p>' }
        when 'Tous les emails'
          user.emailing_preferences = :all_emails
          render json: { html: '<h1>Emailing Preferences changed!</h1><p>This user will receive emails again</p>' }
        else
          render json: { html: '<h1>Status inconnu</h1><p>Selectionnez un status existant</p>' }
        end
        user.save(validate: false)
      end
    end

    def grant_credit
      ids = params.dig(:data, :attributes, :ids).map(&:to_i)
      credit_amount_cents = params.dig(:data, :attributes, :values, :amount).to_i * 100
      message = params.dig(:data, :attributes, :values, :message)

      users = ::User.where(id: ids)
      users.each do |user|
        user.discount_balance_cents += credit_amount_cents
        UserMailer.notify_credit_granted(user, credit_amount_cents, message).deliver_later if user.invitation_accepted?
        user.save(validate: false)
      end

      render json: { html: '<h1>Messages sent!</h1>' }
    end
  end
end
