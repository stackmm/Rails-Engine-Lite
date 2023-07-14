class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  def record_not_found(error)
    render json: ErrorSerializer.new(error, 404).serialized_json, status: 404
  end

  def record_invalid(error)
    render json: ErrorSerializer.new(error, 400).serialized_json, status: 400
  end
end
