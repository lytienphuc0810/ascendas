# frozen_string_literal: true

module Web
  module Services
    class Hotels
      def get(hotels, destination)
        Hanami.logger.debug(hotels)
        Hanami.logger.debug(destination)

        @body1 = JSON.parse(Faraday.get(ENV['URL_SOURCE_1']).body)
        @body2 = JSON.parse(Faraday.get(ENV['URL_SOURCE_2']).body)
        @body3 = JSON.parse(Faraday.get(ENV['URL_SOURCE_3']).body)

        get_hotels(hotels, destination).map { |h| Hanami::Utils::Hash.deep_serialize(h) }
      end

      private

      def filter_hotel(hotel_id, destination_id, filter_hotel_id, filter_destination_id)
        filter_hotel_id == hotel_id && (filter_destination_id.nil? || destination_id == filter_destination_id.to_i)
      end

      def get_hotels(hotel_ids = [], destination)
        # todo
        hotel_ids.uniq.map do |hotel_id|
          source1 = @body1.select do |o|
            filter_hotel(o['Id'], o['DestinationId'], hotel_id, destination)
          end.first
          source2 = @body2.select do |o|
            filter_hotel(o['hotel_id'], o['destination_id'], hotel_id, destination)
          end.first
          source3 = @body3.select do |o|
            filter_hotel(o['id'], o['destination'], hotel_id, destination)
          end.first

          unless source1.nil? && source2.nil? && source3.nil?
            aggreate_hotel_sources(source1, source2,
                                   source3)
          end
        end.compact
      end

      def nilify(val)
        val == '' ? nil : val
      end

      def get_sanitized_value(val1 = nil, val2 = nil, val3 = nil)
        result = nilify(val1) || nilify(val2) || nilify(val3)
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
        rooms = (source2&.dig('images', 'rooms') || []).map { |o|
          Entities::Image.new(
            link: o['link'],
            description: o['caption']
          )
        } + (source3&.dig('images', 'rooms') || []).map do |o|
              Entities::Image.new(
                link: o['url'],
                description: o['description']
              )
            end
        site = (source2&.dig('images', 'site') || []).map do |o|
          Entities::Image.new(
            link: o['link'],
            description: o['caption']
          )
        end
        amenities = (source3&.dig('images', 'amenities') || []).map do |o|
          Entities::Image.new(
            link: o['url'],
            description: o['description']
          )
        end

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
