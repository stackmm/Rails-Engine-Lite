class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices

  def self.find_by_name(name)
    where("lower(name) LIKE ?", "%#{name.downcase}%")
      .order(:name)
      .first
  end
end