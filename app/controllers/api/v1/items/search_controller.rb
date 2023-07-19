class Api::V1::Items::SearchController < ApplicationController
  def index
    if params[:name] && params[:name].empty?
      render json: {error: "No name provided"}, status: 400
    elsif params[:name] && (params[:min_price] || params[:max_price])
      render json: {error: "Cannot search by name and price at the same time"}, status: 400
    elsif params[:name]
      items = Item.find_all_by_name(params[:name])
      render json: ItemSerializer.new(items)
    elsif params[:min_price].to_i < 0 || params[:max_price].to_i < 0
      render json: {errors: "Price cannot be less than 0"}, status: 400
    elsif params[:min_price] && params[:max_price]
      items = Item.find_all_by_price_range([params[:min_price], params[:max_price]])
      render json: ItemSerializer.new(items)
    elsif params[:min_price]
      items = Item.find_all_by_min_price(params[:min_price])
      render json: ItemSerializer.new(items)
    elsif params[:max_price]
      items = Item.find_all_by_max_price(params[:max_price])
      render json: ItemSerializer.new(items)
    elsif params[:name].nil? && params[:min_price].nil? && params[:max_price].nil?
      render json: {error: "No search terms provided"}, status: 400
    end
  end
end