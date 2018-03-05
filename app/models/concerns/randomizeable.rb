module Randomizeable
  extend ActiveSupport::Concern

  included do
    scope :randomize, -> { order('RANDOM()') }
  end
end
