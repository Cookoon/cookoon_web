class Company < ApplicationRecord
  include Stripe::Customerable

  has_many :users, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :address, presence: true
  validates :siren, numericality: { only_integer: true }, length: { is: 9 }, allow_nil: true
  validates :siret, numericality: { only_integer: true }, length: { is: 14 }, allow_nil: true
  validates :referent_email, presence: true

  after_create :stripe_prepare

  alias_attribute :to_s, :name
  alias_attribute :customerable_label, :name

  private

  def stripe_prepare
    if stripe_customer_id.blank?
      create_stripe_customer
      source = create_sepa_source
      link_stripe_source_for_sepa(source.id)
    end
    persist_sepa_source
  end
end
