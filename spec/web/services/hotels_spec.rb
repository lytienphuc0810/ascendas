require_relative '../../../apps/web/services/hotels'

RSpec.describe Web::Services::Hotels do
  let(:service) { Web::Services::Hotels.new }
  let(:acme) do
    '[{"Id": "iJhz", "DestinationId": 5432, "Name": "Beach Villas Singapore", "Latitude": 1.264751, "Longitude": 103.824006, "Address": " 8 Sentosa Gateway, Beach Villas ", "City": "Singapore", "Country": "SG", "PostalCode": "098269", "Description": "  This 5 star hotel is located on the coastline of Singapore.", "Facilities": ["Pool", "BusinessCenter", "WiFi ", "DryCleaning", " Breakfast"] }, {"Id": "SjyX", "DestinationId": 5432, "Name": "InterContinental Singapore Robertson Quay", "Latitude": null, "Longitude": null, "Address": " 1 Nanson Road", "City": "Singapore", "Country": "SG", "PostalCode": "238909", "Description": "desc.", "Facilities": ["Pool", "WiFi ", "Aircon", "BusinessCenter", "BathTub", "Breakfast", "DryCleaning", "Bar"]}]'
  end
  let(:paperflies) do
    '[{"hotel_id": "iJhz", "destination_id": 5432, "hotel_name": "Beach Villas Singapore", "location": {"address": "8 Sentosa Gateway, Beach Villas, 098269", "country": "Singapore" }, "details": "Surrounded by tropical gardens, these upscale villas in elegant Colonial-style buildings are part of the Resorts World Sentosa complex and a 2-minute walk from the Waterfront train station. Featuring sundecks and pool, garden or sea views, the plush 1- to 3-bedroom villas offer free Wi-Fi and flat-screens, as well as free-standing baths, minibars, and tea and coffeemaking facilities. Upgraded villas add private pools, fridges and microwaves; some have wine cellars. A 4-bedroom unit offers a kitchen and a living room. Theres 24-hour room and butler service. Amenities include posh restaurant, plus an outdoor pool, a hot tub, and free parking.", "amenities": {"general": ["outdoor pool", "indoor pool", "business center", "childcare"], "room": ["tv", "coffee machine", "kettle", "hair dryer", "iron"] }, "images": {"rooms": [{"link": "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg", "caption": "Double room" }, {"link": "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/3.jpg", "caption": "Double room" }], "site": [{"link": "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/1.jpg", "caption": "Front" }] }, "booking_conditions": ["test", "Pets are not allowed.", "WiFi is available in all areas and is free of charge.", "Free private parking is possible on site (reservation is not needed).", "test"] }]'
  end
  let(:patagonia) do
    '[{"id": "iJhz", "destination": 5432, "name": "Beach Villas Singapore", "lat": 1.264751, "lng": 103.824006, "address": "8 Sentosa Gateway, Beach Villas, 098269", "info": "Located at the western tip of Resorts World Sentosa, guests at the Beach Villas are guaranteed privacy while they enjoy spectacular views of glittering waters. Guests will find themselves in paradise with this series of exquisite tropical sanctuaries, making it the perfect setting for an idyllic retreat. Within each villa, guests will discover living areas and bedrooms that open out to mini gardens, private timber sundecks and verandahs elegantly framing either lush greenery or an expanse of sea. Guests are assured of a superior slumber with goose feather pillows and luxe mattresses paired with 400 thread count Egyptian cotton bed linen, tastefully paired with a full complement of luxurious in-room amenities and bathrooms boasting rain showers and free-standing tubs coupled with an exclusive array of ESPA amenities and toiletries. Guests also get to enjoy complimentary day access to the facilities at Asia’s flagship spa – the world-renowned ESPA.", "amenities": ["Aircon", "Tv", "Coffee machine", "Kettle", "Hair dryer", "Iron", "Tub"], "images": {"rooms": [{"url": "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg", "description": "Double room" }, {"url": "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/4.jpg", "description": "Bathroom" }], "amenities": [{"url": "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/0.jpg", "description": "RWS" }, {"url": "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/6.jpg", "description": "Sentosa Gateway" }] } }]'
  end
  let(:hotels) do
    [
      Entities::Hotel.new(
        description: 'This 5 star hotel is located on the coastline of Singapore.',
        destination_id: 5432,
        id: 'iJhz',
        name: 'Beach Villas Singapore',
        location: Entities::Location.new(
          address: '8 Sentosa Gateway, Beach Villas',
          city: 'Singapore',
          country: 'SG',
          lat: 1.264751,
          lng: 103.824006
        ),
        amenities: Entities::Amenity.new(
          general: ['pool',
                    'businesscenter',
                    'wifi',
                    'drycleaning',
                    'breakfast',
                    'outdoor pool',
                    'indoor pool',
                    'business center',
                    'childcare',
                    'aircon',
                    'tub'],
          room: ['tv', 'coffee machine', 'kettle', 'hair dryer', 'iron']
        ),
        images: Entities::ImageContainer.new(
          amenities: [Entities::Image.new({
                                            description: 'RWS',
                                            link: 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/0.jpg'
                                          }),
                      Entities::Image.new({
                                            description: 'Sentosa Gateway',
                                            link: 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/6.jpg'
                                          })],
          rooms: [Entities::Image.new({
                                        description: 'Double room',
                                        link: 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg'
                                      }),
                  Entities::Image.new({
                                        description: 'Double room',
                                        link: 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/3.jpg'
                                      }),
                  Entities::Image.new({
                                        description: 'Double room',
                                        link: 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg'
                                      }),
                  Entities::Image.new({
                                        description: 'Bathroom',
                                        link: 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/4.jpg'
                                      })],
          site: [Entities::Image.new({
                                       description: 'Front',
                                       link: 'https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/1.jpg'
                                     })]
        ),
        booking_conditions: ['test',
                             'Pets are not allowed.',
                             'WiFi is available in all areas and is free of charge.',
                             'Free private parking is possible on site (reservation is not needed).',
                             'test']
      )
    ]
  end

  before do
    allow_any_instance_of(Faraday::Connection).to receive(:get).with('https://5f2be0b4ffc88500167b85a0.mockapi.io/suppliers/acme').and_return(
      double('response', status: 200, body: acme)
    )
    allow_any_instance_of(Faraday::Connection).to receive(:get).with('https://5f2be0b4ffc88500167b85a0.mockapi.io/suppliers/paperflies').and_return(
      double('response', status: 200, body: paperflies)
    )
    allow_any_instance_of(Faraday::Connection).to receive(:get).with('https://5f2be0b4ffc88500167b85a0.mockapi.io/suppliers/patagonia').and_return(
      double('response', status: 200, body: patagonia)
    )
  end

  describe 'list' do
    it 'run' do
      result = service.list(['iJhz'], nil)
      expect(result).to eq(hotels)
    end
  end

  describe 'filter_hotel' do
    it 'run' do
    end
  end

  describe 'get_hotels' do
    it 'run' do
    end
  end

  describe 'nilify' do
    it 'run' do
    end
  end

  describe 'get_sanitized_value' do
    it 'run' do
    end
  end

  describe 'get_sanitized_amenities' do
    it 'run' do
    end
  end

  describe 'get_sanitized_images' do
    it 'run' do
    end
  end

  describe 'aggreate_hotel_sources' do
    it 'run' do
    end
  end
end
