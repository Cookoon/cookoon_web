# rspec spec/models/service_spec.rb

require 'rails_helper'
require 'support/service_helpers'

RSpec.configure do |c|
  c.include ServiceHelpers
end

# Old code commented at the end of file
RSpec.describe Service, type: :model do

  # it 'prints the instances' do
  #   @reservation.services.each do |service|
  #     puts "#{service.class.to_s.upcase}: #{service.category.upcase}"
  #     p "#{service.name}: #{service.price}"
  #     puts "-------------"
  #   end
  # end

  it '.set_name_and_prices and .set_price to service after service creation' do
    create_cookoon_reservation_services(10) # method in spec/support/service_helpers
    # => create cookoon, @reservation, @service_special...

    puts "Test création des services pour un dîner de #{@reservation.people_count} personnes"

    @results = { service_special_price_cents: 0, service_sommelier_price_cents: 31250, service_parking_price_cents: 62083, service_corporate_price_cents: 27500, service_catering_price_cents: 37500, service_breakfast_price_cents: 51250, service_flowers_price_cents: 22500, service_wine_price_cents: 7500 }

    test_the_services_prices # method in spec/support/service_helpers
  end

  it '.set_name_and_prices and .set_price to service after service creation' do
    create_cookoon_reservation_services(25) # method in spec/support/service_helpers
    # => create cookoon, @reservation, @service_special...

    puts "Test création des services pour un dîner de #{@reservation.people_count} personnes"

    @results = { service_special_price_cents: 0, service_sommelier_price_cents: 62500, service_parking_price_cents: 114583, service_corporate_price_cents: 50000, service_catering_price_cents: 84583, service_breakfast_price_cents: 105000, service_flowers_price_cents: 22500, service_wine_price_cents: 7500 }

    test_the_services_prices # method in spec/support/service_helpers
  end

  it '.set_name_and_prices and .set_price to service after service creation' do
    create_cookoon_reservation_services(2) # method in spec/support/service_helpers
    # => create cookoon, @reservation, @service_special...

    puts "Test création des services pour un dîner de #{@reservation.people_count} personnes"

    @results = { service_special_price_cents: 0, service_sommelier_price_cents: 31250, service_parking_price_cents: 62083, service_corporate_price_cents: 15833, service_catering_price_cents: 12500, service_breakfast_price_cents: 22500, service_flowers_price_cents: 22500, service_wine_price_cents: 7500 }

    test_the_services_prices # method in spec/support/service_helpers
  end

  it '.set_name_and_prices and .set_price to service after service creation' do
    create_cookoon_reservation_services(125) # method in spec/support/service_helpers
    # => create cookoon, @reservation, @service_special...

    puts "Test création des services pour un dîner de #{@reservation.people_count} personnes"

    @results = { service_special_price_cents: 0, service_sommelier_price_cents: 218750, service_parking_price_cents: 482083, service_corporate_price_cents: 200000, service_catering_price_cents: 397083, service_breakfast_price_cents: 465000, service_flowers_price_cents: 22500, service_wine_price_cents: 7500 }

    test_the_services_prices # method in spec/support/service_helpers
  end

end


# require 'rails_helper'

# RSpec.describe Service, type: :model do
#   let(:cookoon) { create(:cookoon, price_cents: 9000) }
#   let(:reservation) { create(:reservation, cookoon: cookoon, people_count: 10, type_name: 'diner', category: 'customer') }
#   let!(:service_special) { create(:service, reservation: reservation, category: 'special') }
#   let!(:service_sommelier) { create(:service, reservation: reservation, category: 'sommelier') }
#   let!(:service_parking) { create(:service, reservation: reservation, category: 'parking') }
#   let!(:service_corporate) { create(:service, reservation: reservation, category: 'corporate') }
#   let!(:service_catering) { create(:service, reservation: reservation, category: 'catering') }
#   let!(:service_breakfast) { create(:service, reservation: reservation, category: 'breakfast') }
#   let!(:service_flowers) { create(:service, reservation: reservation, category: 'flowers') }
#   let!(:service_wine) { create(:service, reservation: reservation, category: 'wine') }

#   it '.set_name_and_prices and .set_price to service after service creation' do
#     puts "Test création des services pour un dîner de #{reservation.people_count} personnes"

#     results = { service_special_price_cents: 0, service_sommelier_price_cents: 31250, service_parking_price_cents: 61875, service_corporate_price_cents: 27500, service_catering_price_cents: 37500, service_breakfast_price_cents: 51000, service_flowers_price_cents: 22500, service_wine_price_cents: 7500 }

#     expect(service_special.price_cents).to eq(results[:service_special_price_cents])
#     expect(service_sommelier.price_cents).to eq(results[:service_sommelier_price_cents])
#     expect(service_parking.price_cents).to eq(results[:service_parking_price_cents])
#     expect(service_corporate.price_cents).to eq(results[:service_corporate_price_cents])
#     expect(service_catering.price_cents).to eq(results[:service_catering_price_cents])
#     expect(service_breakfast.price_cents).to eq(results[:service_breakfast_price_cents])
#     expect(service_flowers.price_cents).to eq(results[:service_flowers_price_cents])
#     expect(service_wine.price_cents).to eq(results[:service_wine_price_cents])
#   end
# end

# RSpec.describe Service, type: :model do
#   let(:cookoon) { create(:cookoon, price_cents: 9000) }
#   let(:reservation) { create(:reservation, cookoon: cookoon, people_count: 25, type_name: 'diner', category: 'customer') }
#   let!(:service_special) { create(:service, reservation: reservation, category: 'special') }
#   let!(:service_sommelier) { create(:service, reservation: reservation, category: 'sommelier') }
#   let!(:service_parking) { create(:service, reservation: reservation, category: 'parking') }
#   let!(:service_corporate) { create(:service, reservation: reservation, category: 'corporate') }
#   let!(:service_catering) { create(:service, reservation: reservation, category: 'catering') }
#   let!(:service_breakfast) { create(:service, reservation: reservation, category: 'breakfast') }
#   let!(:service_flowers) { create(:service, reservation: reservation, category: 'flowers') }
#   let!(:service_wine) { create(:service, reservation: reservation, category: 'wine') }

#   it '.set_name_and_prices and .set_price to service after service creation' do
#     puts "Test création des services pour un dîner de #{reservation.people_count} personnes"

#     results = { service_special_price_cents: 0, service_sommelier_price_cents: 62500, service_parking_price_cents: 114375, service_corporate_price_cents: 50000, service_catering_price_cents: 84375, service_breakfast_price_cents: 105000, service_flowers_price_cents: 22500, service_wine_price_cents: 7500 }

#     expect(service_special.price_cents).to eq(results[:service_special_price_cents])
#     expect(service_sommelier.price_cents).to eq(results[:service_sommelier_price_cents])
#     expect(service_parking.price_cents).to eq(results[:service_parking_price_cents])
#     expect(service_corporate.price_cents).to eq(results[:service_corporate_price_cents])
#     expect(service_catering.price_cents).to eq(results[:service_catering_price_cents])
#     expect(service_breakfast.price_cents).to eq(results[:service_breakfast_price_cents])
#     expect(service_flowers.price_cents).to eq(results[:service_flowers_price_cents])
#     expect(service_wine.price_cents).to eq(results[:service_wine_price_cents])
#   end
# end
