require_relative '../../../apps/web/controllers/hotels/index'

RSpec.describe Web::Controllers::Hotels::Index do
  let(:action) { Web::Controllers::Hotels::Index.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    expect(response[0]).to be(200)
  end
end