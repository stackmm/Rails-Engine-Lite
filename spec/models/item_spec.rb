require "rails_helper"

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "class methods" do
    describe "#find_all_by_name" do
      it "returns all items that match the search criteria" do
        item1 = create(:item, name: "Gold Potatoe")
        item2 = create(:item, name: "Silver potatoe")
        item3 = create(:item, name: "Bronze Egg")
        item4 = create(:item, name: "Titanium egg")
        item5 = create(:item, name: "Platinum Toaster")
        item6 = create(:item, name: "Ring World")
        item7 = create(:item, name: "Turing School")

        expect(Item.find_all_by_name("potatoe")).to eq([item1, item2])
        expect(Item.find_all_by_name("egg")).to eq([item3, item4])
        expect(Item.find_all_by_name("ring")).to eq([item6, item7])
      end
    end

    describe "#find_all_by_min_price" do
      it "returns all items that have a price equal to or greater than the search criteria" do
        item1 = create(:item, unit_price: 1.50)
        item2 = create(:item, unit_price: 25.20)
        item3 = create(:item, unit_price: 55.00)
        item4 = create(:item, unit_price: 75.00)
        item5 = create(:item, unit_price: 100.00)

        expect(Item.find_all_by_min_price(55)).to eq([item3, item4, item5])
        expect(Item.find_all_by_min_price(75.5)).to eq([item5])
        expect(Item.find_all_by_min_price(101)).to eq([])
      end
    end

    describe "#find_all_by_max_price" do
      it "returns all items that have a price less than or equal to the search criteria" do
        item1 = create(:item, unit_price: 1.50)
        item2 = create(:item, unit_price: 25.20)
        item3 = create(:item, unit_price: 55.00)
        item4 = create(:item, unit_price: 75.00)
        item5 = create(:item, unit_price: 100.00)

        expect(Item.find_all_by_max_price(55)).to eq([item1, item2, item3])
        expect(Item.find_all_by_max_price(75.5)).to eq([item1, item2, item3, item4])
        expect(Item.find_all_by_max_price(1.00)).to eq([])
      end
    end
  end
end