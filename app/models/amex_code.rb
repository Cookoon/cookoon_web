class AmexCode < ApplicationRecord
  belongs_to :reservation, optional: true

  validates :code, presence: true, uniqueness: true, length: { is: 8 }
  validates :email, presence: true
  validates :first_name, presence: true, on: :update
  validates :last_name, presence: true, on: :update
  validates :phone_number, presence: true, on: :update
  validates :reservation, presence: true, on: :update

  def already_used?
    reservation.present? || first_name.present? || last_name.present? || phone_number.present?
  end

end
