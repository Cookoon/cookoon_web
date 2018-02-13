class Guest < ApplicationRecord
  belongs_to :user

  validates :email, presence: true,
                    format: {
                      with: URI::MailTo::EMAIL_REGEXP
                    },
                    uniqueness: { scope: :user }
  validates :first_name, presence: true
  validates :last_name, presence: true
end
