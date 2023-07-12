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
  end
end