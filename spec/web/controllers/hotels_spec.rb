# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../../apps/web/controllers/hotels/index'

RSpec.describe Web::Controllers::Hotels::Index do
  let(:action) { Web::Controllers::Hotels::Index.new(hotels_service: hotels_service) }
  let(:empty_params) { {} }
  let(:params) { { hotels: 'usRW', destination: 123 } }
  let(:hotels_service) { instance_double(Web::Services::Hotels) }
  let(:hotel) do
    Entities::Hotel.new(
      id: 'usRW',
      destination_id: 123,
      name: 'ABC'
    )
  end
  let(:hotels) { [hotel] }

  before do
    allow(hotels_service).to receive(:list).and_return(hotels)
  end

  it 'returns 400 status in case of empty params' do
    response = action.call(empty_params)
    expect(response[0]).to be(400)
  end

  it 'returns 200 status in case of valid params and invokes correct service' do
    expect(hotels_service).to receive(:list).with('usRW', 123).once
    response = action.call(params)
    expect(response[0]).to be(200)
  end

  it 'returns the correct hotels json' do
    response = action.call(params)
    expect(response[1]['Content-Type']).to eq('application/json; charset=utf-8')
    expect(response[2][0]).to eq(JSON.generate({ hotels: [hotel.to_h] }))
  end
end

# rubocop:enable Metrics/BlockLength
