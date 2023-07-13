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

    describe "#find_all_by_price_range" do
      it "returns all items that have a price within the search criteria" do
        item1 = create(:item, unit_price: 1.50)
        item2 = create(:item, unit_price: 25.20)
        item3 = create(:item, unit_price: 55.00)
        item4 = create(:item, unit_price: 75.00)
        item5 = create(:item, unit_price: 100.00)

        expect(Item.find_all_by_price_range([25.20, 75])).to eq([item2, item3, item4])
        expect(Item.find_all_by_price_range([1.00, 1.50])).to eq([item1])
        expect(Item.find_all_by_price_range([0, 54.99])).to eq([item1, item2])
      end
    end
  end

  describe "instance methods" do
    describe "#check_delete_invoice" do
      it "deletes the item's invoice if that item is the only item on the invoice" do
        merchant = create(:merchant)
        customer = create(:customer)
        item1 = create(:item, merchant_id: merchant.id)
        item2 = create(:item, merchant_id: merchant.id)
        invoice = Invoice.create!(merchant_id: merchant.id, customer_id: customer.id, status: :active)
        InvoiceItem.create!(item_id: item1.id, invoice_id: invoice.id, quantity: 1, unit_price: 1.50)
        InvoiceItem.create!(item_id: item2.id, invoice_id: invoice.id, quantity: 2, unit_price: 2.50)
        
        expect(Invoice.count).to eq(1)
        expect(invoice.items.count).to eq(2)

        item1.check_delete_invoice
        expect(item1.invoices.count).to eq(1)

        item2.destroy
        expect(Invoice.count).to eq(1)
        expect(invoice.items.count).to eq(1)

        item1.check_delete_invoice
        expect(Invoice.count).to eq(0)
      end
    end
  end
end