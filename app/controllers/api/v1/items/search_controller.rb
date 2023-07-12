class Api::V1::Items::SearchController < ApplicationController
  def index

    # if params[:name] && (params[:min_price] || params[:max_price])
    if params[:name]
      items = Item.find_all_by_name(params[:name])
      render json: ItemSerializer.new(items)
    # elsif params[:min_price] && params[:max_price]
    #   items = Item.find_all_by_price_range(params[:min_price], params[:max_price])
    #   render json: ItemSerializer.new(items)
    elsif params[:min_price]
      items = Item.find_all_by_min_price(params[:min_price])
      render json: ItemSerializer.new(items)
    elsif params[:max_price]
      items = Item.find_all_by_max_price(params[:max_price])
      render json: ItemSerializer.new(items)
    # else
    #   render json: {error: "No search term provided"}, status: :bad_request
    end

    # sad path for when name, min price, max price are all empty
    # sad path for when min price is being than all prices in database
    # sad path for when name and min/max price are being sent
  end
end