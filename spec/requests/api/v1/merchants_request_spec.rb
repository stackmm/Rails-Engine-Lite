require "rails_helper"

describe "Merchants API" do
  it "sends a list of merchants" do
    get '/api/v1/merchants'
    test = Merchant.first
    require 'pry'; binding.pry
    expect(response).to be_successful

    merchants = JSON.parse(response.body)
  end
end