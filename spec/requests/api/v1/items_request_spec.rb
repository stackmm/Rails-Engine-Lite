require "rails_helper"

RSpec.describe "Items API", type: :request do
  describe "/api/v1/items" do 
    it "sends a list of items" do
      create_list(:item, 3)
  
      get "/api/v1/items"
  
      expect(response).to be_successful
      expect(response.status).to eq(200)
  
      items = JSON.parse(response.body, symbolize_names: true)
  
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
  end

  describe "/api/v1/items/:id" do
    it "can get one item by its id" do
      id = create(:item).id
  
      get "/api/v1/items/#{id}"
  
      item = JSON.parse(response.body, symbolize_names: true)
  
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(item.count).to eq(1)
  
      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to be_an(String)
  
      expect(item[:data]).to have_key(:type)
      expect(item[:data][:type]).to be_an(String)
  
      expect(item[:data]).to have_key(:attributes)
      expect(item[:data][:attributes]).to be_an(Hash)
  
      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_an(String)
  
      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_an(String)
  
      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_an(Float)
  
      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  describe "POST /api/v1/items" do
    it "can create a new item" do
      item_params = ({
                      name: "Gold Potatoe",
                      description: "A potatoe made of gold",
                      unit_price: 99.99,
                      merchant_id: create(:merchant).id
                    })
      
      headers = {"CONTENT_TYPE" => "application/json"}
  
      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
  
      created_item = Item.last
  
      expect(response).to be_successful
      expect(response.status).to eq(201)
  
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end

    it "rejects a request to create an item if the merchant does not exist" do
      item_params = {
                      name: "Gold Potatoe",
                      description: "A potatoe made of gold",
                      unit_price: 99.99,
                      merchant_id: 1
                    }
      
      headers = {"CONTENT_TYPE" => "application/json"}
  
      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end

    it "rejects a request to create an item if params are incomplete" do
      item_params = {
                      name: "Gold Potatoe",
                      description: "A potatoe made of gold",
                      merchant_id: create(:merchant).id
                    }
      
      headers = {"CONTENT_TYPE" => "application/json"}
  
      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
                    
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end

  describe "PATCH /api/v1/items/:id" do
    it "can update an existing item" do
      id = create(:item).id
      previous_name = Item.last.name
      item_params = { name: "Silver Potatoe" }
      headers = {"CONTENT_TYPE" => "application/json"}
  
      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)
  
      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq("Silver Potatoe")
    end
  
    it "rejects a request to update an item if merchant does not exist" do
      id = create(:item).id
  
      item_params = { merchant_id: 1 }
      headers = {"CONTENT_TYPE" => "application/json"}
  
      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
  
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  
    it "rejects a request to update an item if item does not exist" do
      item_params = { merchant_id: 1 }
      headers = {"CONTENT_TYPE" => "application/json"}
  
      patch "/api/v1/items/1", headers: headers, params: JSON.generate({item: item_params})
  
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end

  describe "DELETE /api/v1/items/:id" do
    it "can destroy an item" do
      item = create(:item)
  
      expect(Item.count).to eq(1)
  
      delete "/api/v1/items/#{item.id}"
  
      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "destroys an invoice if no items remaining" do
      merchant = create(:merchant)
      customer = create(:customer)
      item = create(:item, merchant_id: merchant.id)
      invoice = item.invoices.create!(merchant_id: merchant.id, customer_id: customer.id, status: :active)
      
      expect(Invoice.count).to eq(1)
      expect(invoice.items.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(Item.count).to eq(0)
      expect(Invoice.count).to eq(0)
      expect{Invoice.find(invoice.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "/api/v1/items/id/merchant" do
    it "can get the merchant data for a given item ID" do
      item = create(:item)
      merchant = Merchant.find(item.merchant_id)
  
      get "/api/v1/items/#{item.id}/merchant"
  
      merchant_data = JSON.parse(response.body, symbolize_names: true)
  
      expect(response).to be_successful
      expect(response.status).to eq(200)
  
      expect(merchant_data[:data]).to have_key(:id)
      expect(merchant_data[:data][:id]).to be_an(String)
  
      expect(merchant_data[:data]).to have_key(:type)
      expect(merchant_data[:data][:type]).to be_an(String)
  
      expect(merchant_data[:data]).to have_key(:attributes)
      expect(merchant_data[:data][:attributes]).to be_an(Hash)
      expect(merchant_data[:data][:attributes]).to have_key(:name)
      expect(merchant_data[:data][:attributes][:name]).to be_an(String)
    end
  
    it "rejects a request for merchant data if the item does not exist" do
      get "/api/v1/items/1/merchant"
  
      merchant_data = JSON.parse(response.body, symbolize_names: true)
  
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(merchant_data[:error]).to eq("Item not found")
    end
  end

  describe "/api/v1/items/find_all" do
    it "can find all items which match a search by name" do
      item1 = create(:item, name: "Gold Potatoe")
      item2 = create(:item, name: "Silver potatoe")
      item3 = create(:item, name: "Bronze Egg")
      item4 = create(:item, name: "Titanium egg")
      item5 = create(:item, name: "Platinum Toaster")

      get "/api/v1/items/find_all?name=potatoe"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data]).to be_an(Array)
      expect(items[:data].count).to eq(2)
      expect(items[:data][0][:attributes][:name]).to eq(item1.name)
      expect(items[:data][1][:attributes][:name]).to eq(item2.name)
    end

    it "can find all items when searched by min_price" do
      item1 = create(:item, unit_price: 1.50)
      item2 = create(:item, unit_price: 25.20)
      item3 = create(:item, unit_price: 55.00)
      item4 = create(:item, unit_price: 75.00)
      item5 = create(:item, unit_price: 100.00)

      get "/api/v1/items/find_all?min_price=55"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data]).to be_an(Array)
      expect(items[:data].count).to eq(3)
      expect(items[:data][0][:attributes][:unit_price]).to eq(item3.unit_price)
      expect(items[:data][1][:attributes][:unit_price]).to eq(item4.unit_price)
      expect(items[:data][2][:attributes][:unit_price]).to eq(item5.unit_price)
    end

    it "can find all items when searched by max_price" do
      item1 = create(:item, unit_price: 1.50)
      item2 = create(:item, unit_price: 25.20)
      item3 = create(:item, unit_price: 55.00)
      item4 = create(:item, unit_price: 75.00)
      item5 = create(:item, unit_price: 100.00)

      get "/api/v1/items/find_all?max_price=55"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data]).to be_an(Array)
      expect(items[:data].count).to eq(3)
      expect(items[:data][0][:attributes][:unit_price]).to eq(item1.unit_price)
      expect(items[:data][1][:attributes][:unit_price]).to eq(item2.unit_price)
      expect(items[:data][2][:attributes][:unit_price]).to eq(item3.unit_price)
    end

    it "can find all items when searched by min_price AND max_price" do
      item1 = create(:item, unit_price: 1.50)
      item2 = create(:item, unit_price: 25.20)
      item3 = create(:item, unit_price: 50.00)
      item4 = create(:item, unit_price: 55.00)
      item5 = create(:item, unit_price: 71.00)
      item6 = create(:item, unit_price: 75.00)

      get "/api/v1/items/find_all?max_price=75&min_price=51"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data]).to be_an(Array)
      expect(items[:data].count).to eq(3)
      expect(items[:data][0][:attributes][:unit_price]).to eq(item4.unit_price)
      expect(items[:data][1][:attributes][:unit_price]).to eq(item5.unit_price)
      expect(items[:data][2][:attributes][:unit_price]).to eq(item6.unit_price)
    end

    it "rejects a request for an item if both name and price are provided" do
      get "/api/v1/items/find_all?name=potatoe&max_price=75"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      get "/api/v1/items/find_all?name=potatoe&min_price=75"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it "rejects a request for an item if min_price is less than 0" do
      get "/api/v1/items/find_all?min_price=-1"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it "rejects a request for an item if max_price is less than 0" do
      get "/api/v1/items/find_all?max_price=-1"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it "rejects a request for an item if name and price are empty" do
      get "/api/v1/items/find_all"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end
end