class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price, :merchant_id
  validates_numericality_of :unit_price, greater_than: 0

  def self.find_all_by_name(name)
    where("name ILIKE ?", "%#{name}%")
  end

  def self.find_all_by_min_price(price)
    where("unit_price >= ?", price)
  end

  def self.find_all_by_max_price(price)
    where("unit_price <= ?", price)
  end

  def self.find_all_by_price_range(price)
    where("unit_price >= ? AND unit_price <= ?", price[0], price[1])
  end
end