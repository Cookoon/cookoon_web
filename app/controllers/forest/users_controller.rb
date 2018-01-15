module Forest
  class UsersController < ForestLiana::ApplicationController
    def award_invitations
      ids = params.dig(:data, :attributes, :ids).map(&:to_i)
      invitation_quantity = params.dig(:data, :attributes, :values, :quantity).to_i

      users = ::User.where(id: ids)
      users.each do |user|
        user.invitation_limit += invitation_quantity
        if user.save
          UserMailer.notify_invitations_awarded(user, invitation_quantity).deliver_later
        else
          user.save(validate: false)
        end
      end

      render json: { html: '<h1>Congratulations Quentin!</h1><p>You are awesome, just stay who you are.</p>' }
    end
  end
end
