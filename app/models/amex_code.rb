class AmexCode < ApplicationRecord
  PHONE_REGEXP = /\A(\+\d+)?([\s\-\.]?\(?\d+\)?)+\z/

  belongs_to :reservation, optional: true

  validates :code, presence: true, uniqueness: true, length: { is: 8 }
  validates :email, presence: true
  validates :first_name, presence: true, on: :update
  validates :last_name, presence: true, on: :update
  validates :phone_number, presence: true, format: { with: PHONE_REGEXP }, on: :update
  validates :reservation, presence: true, on: :update

  def already_used?
    reservation.present? || first_name.present? || last_name.present? || phone_number.present?
  end

  def full_name
    if first_name.present? && last_name.present?
      "#{first_name.capitalize} #{last_name.capitalize}"
    else
      'Membre Cookoon'
    end
  end

  def full_email
    Mail::Address.new("#{full_name} <#{email}>")
  end

end
