require_relative '../../../apps/web/controllers/hotels/index'

RSpec.describe Web::Controllers::Hotels::Index do
  let(:action) { Web::Controllers::Hotels::Index.new }
  let(:empty_params) { Hash[] }

  it "returns 400 status in case of empty params" do
    response = action.call(params)
    expect(response[0]).to be(400)
  end
end