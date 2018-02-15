class Guest < ApplicationRecord
  belongs_to :user

  validates :email, presence: true,
                    format: {
                      with: URI::MailTo::EMAIL_REGEXP
                    },
                    uniqueness: { scope: :user }
  validates :first_name, presence: true
  validates :last_name, presence: true

  def to_s
    "#{full_name} · #{email}"
  end

  def full_name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    else
      'Convive Cookoon'
    end
  end

  def full_email
    Mail::Address.new("#{full_name} <#{email}>")
  end

end
