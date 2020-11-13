class AmexCode < ApplicationRecord
  belongs_to :user, required: false

  validates :code, presence: true, uniqueness: true, length: { minimum: 12 }
  validates :user, uniqueness: true, if: :user_is_present?

  def user_is_present?
    user.present?
  end
end
