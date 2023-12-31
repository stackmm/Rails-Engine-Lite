class Api::V1::ItemsController < ApplicationController
  before_action :verify_merchant, only: [:create, :update]
  
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: 201
  end

  def update
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end

  def destroy
    item = Item.find(params[:id])
    item.check_delete_invoice

    render json: ItemSerializer.new(Item.destroy(params[:id]))
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def verify_merchant 
    return if Merchant.exists?(item_params[:merchant_id]) || item_params[:merchant_id].nil?
    render json: {error: "Merchant not found"}, status: 404
  end
end