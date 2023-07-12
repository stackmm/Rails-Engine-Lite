class Api::V1::Items::MerchantController < ApplicationController
  before_action :verify_item
  
  def index
    item = Item.find(params[:item_id])
    merchant = Merchant.find(item.merchant_id)
    render json: MerchantSerializer.new(merchant)
  end

  private
  def verify_item
    render json: {error: "Item not found"}, status: 404 unless Item.exists?(params[:item_id])
  end
end