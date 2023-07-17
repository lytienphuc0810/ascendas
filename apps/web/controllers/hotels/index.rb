# frozen_string_literal: true

module Web
  module Controllers
    module Hotels
      class Index
        include Web::Action

        def initialize; end

        def call(params)
          response_1 = Faraday.get(ENV['URL_SOURCE_1'])
          @body_1 = JSON.parse(response_1.body)
          response_2 = Faraday.get(ENV['URL_SOURCE_2'])
          @body_2 = JSON.parse(response_2.body)
          response_3 = Faraday.get(ENV['URL_SOURCE_3'])
          @body_3 = JSON.parse(response_3.body)

          if params[:hotels].nil? && params[:destination].nil?
            self.status = 400
            return
          end

          hotels = []
          if !params[:hotels].nil? && params[:hotels].is_a?(Array)
            hotels = get_hotels(params[:hotels])
          elsif !params[:destination].nil?
            des_id = params[:destination].to_i
            ids = []
            @body_1.each do |o|
              ids.push(o['Id']) if des_id == o['DestinationId']
            end
            @body_2.each do |o|
              ids.push(o['hotel_id']) if des_id == o['destination_id']
            end
            @body_3.each do |o|
              ids.push(o['id']) if des_id == o['destination']
            end

            hotels = get_hotels(ids)
          end

          self.body = {
            hotels: hotels.map { |h| Hanami::Utils::Hash.deep_serialize(h) }
          }.to_json
        end

        private

        def get_hotels(ids=[])
          ids = ids.uniq
          hotels = []
          ids.each do |hotel_id|
            source1 = @body_1.select do |o|
              hotel_id == o['Id']
            end.first
            source2 = @body_2.select do |o|
              hotel_id == o['hotel_id']
            end.first
            source3 = @body_3.select do |o|
              hotel_id == o['id']
            end.first

            hotels.push(aggreate_hotel_sources(source1, source2, source3)) unless source1.nil? && source2.nil? && source3.nil?
          end
          hotels
        end

        def get_sanitized_value(val1 = nil, val2 = nil, val3 = nil)
          result = (val1 == '' ? nil : val1) || (val2 == '' ? nil : val2) || (val3 == '' ? nil : val3)
          result.respond_to?(:strip) ? result.strip : result
        end

        def get_sanitized_amenities(source1, source2, source3)
          general = ((source1&.dig('Facilities') || []) + (source2&.dig('amenities', 'general') || []) + (source3&.dig('amenities') || [])).map(&:downcase).map(&:strip).uniq
          room = (source2&.dig('amenities', 'room') || []).map(&:downcase).map(&:strip).uniq
          general = general.reject { |w| room.include? w }

          Entities::Amenity.new(
            general: general,
            room: room
          )
        end

        def get_sanitized_images(source2, source3)
          rooms = (source2&.dig('images', 'rooms') || []).map { |o| Entities::Image.new(
              link: o.dig('link'),
              description: o.dig('caption')
            )}  + (source3&.dig('images', 'rooms') || []).map { |o| Entities::Image.new(
              link: o.dig('url'),
              description: o.dig('description')
            )}
          site =  (source2&.dig('images', 'site') || []).map { |o| Entities::Image.new(
              link: o.dig('link'),
              description: o.dig('caption')
            )}
          amenities = (source3&.dig('images', 'amenities') || []).map { |o| Entities::Image.new(
              link: o.dig('url'),
              description: o.dig('description')
            )}

          Entities::ImageContainer.new(
            rooms: rooms,
            site: site,
            amenities: amenities
          )
        end

        def aggreate_hotel_sources(source1, source2, source3)
          Entities::Hotel.new(
            id: get_sanitized_value(source1&.dig('Id'), source2&.dig('hotel_id'), source3&.dig('id')),
            destination_id: get_sanitized_value(source1&.dig('DestinationId'), source2&.dig('destination_id'),
                                                source3&.dig('destination')),
            name: get_sanitized_value(source1&.dig('Name'), source2&.dig('hotel_name'), source3&.dig('name')),
            location: Entities::Location.new(
              lat: get_sanitized_value(source1&.dig('Latitude'), source3&.dig('lat')),
              lng: get_sanitized_value(source1&.dig('Longitude'), source3&.dig('lng')),
              address: get_sanitized_value(source1&.dig('Address')),
              city: get_sanitized_value(source1&.dig('City'), source2&.dig('location', 'address')),
              country: get_sanitized_value(source1&.dig('Country'), source2&.dig('location', 'country')),
              postal_code: source1&.dig('PostalCode')
            ),
            description: get_sanitized_value(source1&.dig('Description'), source2&.dig('details'),
                                             source3&.dig('info')),
            amenities: get_sanitized_amenities(source1, source2, source3),
            images: get_sanitized_images(source2, source3),
            booking_conditions: source2&.dig('booking_conditions')
          )
        end
      end
    end
  end
end
