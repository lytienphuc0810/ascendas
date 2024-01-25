require 'hanami/model'

# frozen_string_literal: true

module Entities
  class Location < Hanami::Entity
    attributes do
      attribute :lat, Types::Float
      attribute :lng, Types::Float
      attribute :address, Types::String
      attribute :city, Types::String
      attribute :country, Types::String
    end
  end

  class Image < Hanami::Entity
    attributes do
      attribute :link, Types::String
      attribute :description, Types::String
    end
  end

  class ImageContainer < Hanami::Entity
    attributes do
      attribute :rooms, Types::Collection(Image)
      attribute :site, Types::Collection(Image)
      attribute :amenities, Types::Collection(Image)
    end
  end

  class Amenity < Hanami::Entity
    attributes do
      attribute :general, Types::Collection(Types::String)
      attribute :room, Types::Collection(Types::String)
    end
  end

  class Hotel < Hanami::Entity
    attr_accessor :id, :name, :destination_id

    attributes do
      attribute :id, Types::Strict::String
      attribute :destination_id, Types::String
      attribute :name, Types::String
      attribute :location, Types::Entity(Location)
      attribute :description, Types::String
      attribute :amenities, Types::Entity(Amenity)
      attribute :images, Types::Entity(ImageContainer)
      attribute :booking_conditions, Types::Collection(Types::String)
    end
  end
end
