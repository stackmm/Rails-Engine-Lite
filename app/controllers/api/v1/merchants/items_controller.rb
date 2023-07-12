class Api::V1::Merchants::ItemsController < ApplicationController
  before_action :verify_merchant

  def index
    items = Item.where(merchant_id: params[:merchant_id])
    render json: ItemSerializer.new(items)
  end

  private
  def verify_merchant
    render json: {error: "Merchant not found"}, status: 404 unless Merchant.exists?(params[:merchant_id])
  end
end