module ReservationHelpers
  def create_reservation(number_of_people, menu)
    cookoon = create(:cookoon, price_cents: 5000)
    @reservation = create(:reservation, cookoon: cookoon, people_count: number_of_people, menu: menu, type_name: 'diner', category: 'customer')
  end

  def test_menu_and_total_prices
    # @results, @computed_prices : hash of results defined in spec/concerns/reservation/price_computer.rb
    expect(@computed_prices[:menu][:menu_price]).to eq(@results[:menu][:menu_price])
    expect(@computed_prices[:menu][:menu_tax]).to eq(@results[:menu][:menu_tax])
    expect(@computed_prices[:menu][:menu_with_tax]).to eq(@results[:menu][:menu_with_tax])
    expect(@computed_prices[:total][:total_price]).to eq(@results[:total][:total_price])
    expect(@computed_prices[:total][:total_tax]).to eq(@results[:total][:total_tax])
    expect(@computed_prices[:total][:total_with_tax]).to eq(@results[:total][:total_with_tax])
  end
end
