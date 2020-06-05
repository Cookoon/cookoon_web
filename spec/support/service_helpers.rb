module ServiceHelpers
  def create_cookoon_reservation_services(number_of_people)
    cookoon = create(:cookoon, price_cents: 9000)
    @reservation = create(:reservation, cookoon: cookoon, people_count: number_of_people, type_name: 'diner', category: 'customer')
    @service_special = create(:service, reservation: @reservation, category: 'special')
    @service_sommelier = create(:service, reservation: @reservation, category: 'sommelier')
    @service_parking = create(:service, reservation: @reservation, category: 'parking')
    @service_corporate = create(:service, reservation: @reservation, category: 'corporate')
    @service_catering = create(:service, reservation: @reservation, category: 'catering')
    @service_breakfast = create(:service, reservation: @reservation, category: 'breakfast')
    @service_flowers = create(:service, reservation: @reservation, category: 'flowers')
    @service_wine = create(:service, reservation: @reservation, category: 'wine')
  end

  def test_the_services_prices
    # @results : hash of results defined in spec/models/service.rb
    expect(@service_special.price_cents).to eq(@results[:service_special_price_cents])
    expect(@service_sommelier.price_cents).to eq(@results[:service_sommelier_price_cents])
    expect(@service_parking.price_cents).to eq(@results[:service_parking_price_cents])
    expect(@service_corporate.price_cents).to eq(@results[:service_corporate_price_cents])
    expect(@service_catering.price_cents).to eq(@results[:service_catering_price_cents])
    expect(@service_breakfast.price_cents).to eq(@results[:service_breakfast_price_cents])
    expect(@service_flowers.price_cents).to eq(@results[:service_flowers_price_cents])
    expect(@service_wine.price_cents).to eq(@results[:service_wine_price_cents])
  end
end
