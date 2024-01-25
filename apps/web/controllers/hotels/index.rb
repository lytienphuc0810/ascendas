# frozen_string_literal: true

module Web
  module Controllers
    module Hotels
      class Index
        include Web::Action

        def initialize(hotels_service: Web::Services::Hotels.new)
          @hotels_service = hotels_service
        end

        params do
          optional(:hotels).filled(:array?)
          optional(:destination).filled(:str?)
        end

        def call(params)
          if params[:hotels].nil? && params[:destination].nil?
            self.status = 400
            return
          end

          hotels = @hotels_service.get(params[:hotels], params[:destination])

          self.body = {
            hotels: hotels.map { |h| Hanami::Utils::Hash.deep_serialize(h) }
          }.to_json
        end
      end
    end
  end
end
