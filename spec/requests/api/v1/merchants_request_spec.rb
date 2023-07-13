require "rails_helper"

describe "Merchants API", type: :request do
  describe "/api/v1/merchants" do
    it "sends a list of merchants" do
      create_list(:merchant, 3)
  
      get "/api/v1/merchants"
  
      expect(response).to be_successful
  
      merchants = JSON.parse(response.body, symbolize_names: true)
  
      expect(merchants[:data]).to be_an(Array)
      expect(merchants[:data].count).to eq(3)
  
      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(String)
  
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to be_an(String)
  
        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_an(Hash)
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_an(String)
      end
    end
  end

  describe "/api/v1/merchants/:id" do
    it "can get one merchant by its id" do
      id = create(:merchant).id
  
      get "/api/v1/merchants/#{id}"
  
      merchant = JSON.parse(response.body, symbolize_names: true)
  
      expect(response).to be_successful
      expect(response.status).to eq(200)
  
      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_an(String)
  
      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data][:type]).to be_an(String)
  
      expect(merchant[:data]).to have_key(:attributes)
      expect(merchant[:data][:attributes]).to be_an(Hash)
      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_an(String)
    end
  end

  describe "/api/v1/merchants/merchant_id/items" do
    it "can get all items for a merchant" do
      merchant = create(:merchant)
      create_list(:item, 3, merchant_id: merchant.id)
  
      get "/api/v1/merchants/#{merchant.id}/items"
  
      items = JSON.parse(response.body, symbolize_names: true)
  
      expect(response).to be_successful
      expect(response.status).to eq(200)
      
      expect(items[:data]).to be_an(Array)
      expect(items[:data].count).to eq(3)
  
      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)
  
        expect(item).to have_key(:type)
        expect(item[:type]).to be_an(String)
  
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_an(Hash)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_an(String)
  
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_an(String)
  
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_an(Float)
  
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end

    it "rejects a request for a merchant's items if the merchant does not exist" do
      get "/api/v1/merchants/1/items"
  
      items = JSON.parse(response.body, symbolize_names: true)
  
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      
      expect(items[:errors][0][:title]).to eq("Couldn't find Merchant with 'id'=1")
      expect(items[:errors][0][:status]).to eq(404)
    end
  end

  describe "/api/v1/merchants/find" do
    it "can find a merchant which matches a search term" do
      merchant1 = create(:merchant, name: "Bob's Store")
      merchant2 = create(:merchant, name: "Mike's Store")
      merchant3 = create(:merchant, name: "Tom's Store")

      get "/api/v1/merchants/find?name=store"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_an(String)
  
      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data][:type]).to be_an(String)
  
      expect(merchant[:data]).to have_key(:attributes)
      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to eq(merchant1.name)
    end

    it "rejects a request for a merchant if the search term is not found (merchant does not exist)" do
      merchant1 = create(:merchant, name: "Bob's Burgers")
      merchant2 = create(:merchant, name: "Walmart")

      get "/api/v1/merchants/find?name=store"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end

    it "rejects a request for a merchant if the search term is not provided" do
      merchant1 = create(:merchant, name: "Bob's Burgers")
      merchant2 = create(:merchant, name: "Walmart")

      get "/api/v1/merchants/find"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it "rejects a request for a merchant if the name fragment is empty" do
      merchant1 = create(:merchant, name: "Bob's Burgers")
      merchant2 = create(:merchant, name: "Walmart")

      get "/api/v1/merchants/find?name="

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end
end
