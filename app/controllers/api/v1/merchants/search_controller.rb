class Api::V1::Merchants::SearchController < ApplicationController
  before_action :verify_params

  def show
    merchant = Merchant.find_by_name(params[:name])
    render json: MerchantSerializer.new(merchant)
  end

  private
  def verify_params
    if params[:name].nil?
      render json: {error: "No search term provided"}, status: :bad_request
    elsif Merchant.find_by_name(params[:name]).nil?
      render json: {error: "Merchant not found"}, status: 404
    elsif params[:name].empty?
      render json: {error: "No name provided"}, status: 400
    else
      return
    end
  end
end
