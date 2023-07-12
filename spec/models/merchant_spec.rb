require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :invoices }
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe "class methods" do
    describe "#find_by_name" do
      it "returns the first merchant that matches the search criteria (in case-insensitive alphabetical order)" do
        merchant1 = create(:merchant, name: "Walmart")
        merchant2 = create(:merchant, name: "Bob's Store")
        merchant3 = create(:merchant, name: "Mike's Store")
        merchant4 = create(:merchant, name: "McDonalds")
        merchant5 = create(:merchant, name: "Tom's Store")
        merchant6 = create(:merchant, name: "boB's STORE")
        
        expect(Merchant.find_by_name("store")).to eq(merchant2)
        expect(Merchant.find_by_name("bob")).to eq(merchant2)
        expect(Merchant.find_by_name("ALDS")).to eq(merchant4)
      end
    end
  end
end
