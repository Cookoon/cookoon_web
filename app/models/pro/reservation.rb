class Pro::Reservation < ApplicationRecord
  belongs_to :pro_quote
  belongs_to :cookoon
end
