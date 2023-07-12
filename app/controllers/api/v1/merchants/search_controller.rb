class Api::V1::Merchants::SearchController < ApplicationController
  def show
    name = params[:name].downcase
    merchant = Merchant.find_by_name(name)
    # merchant = Merchant.where("lower(name) LIKE ?", "%#{name}%").first
    require 'pry'; binding.pry
    render json: MerchantSerializer.new(merchant)
  end
end