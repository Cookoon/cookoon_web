# This task can safely be removed once new automatic mailers are set.
namespace :users do
  desc 'Generate new invitations token and send links to admins'
  task generate_invitation_link: :environment do
    base_url = 'https://app.cookoon.fr/users/invitation/accept?invitation_token='
    quentin = User.find_by(email: 'quentin@cookoon.fr')
    users = User.where.not(invitation_token: nil)
    dict = {}
    users.each do |user|
      invited = User.invite!({ email: user.email, skip_invitation: true }, quentin)
      dict[user.email] = "#{base_url}#{invited.raw_invitation_token}"
    end
    p dict
  end
end
