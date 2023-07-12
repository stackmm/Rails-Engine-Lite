class Api::V1::Items::SearchController < ApplicationController
  def index
    items = Item.find_all_by_name(params[:name])
    render json: ItemSerializer.new(items)
  end
end