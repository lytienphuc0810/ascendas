require_relative '../../../apps/web/services/hotels'

RSpec.describe Web::Services::Hotels do
  let(:action) { Web::Services::Hotels.new }
  let(:params) { Hash[] }

  it "is successful" do
    
    expect(300).to be(200)
  end
end