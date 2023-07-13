class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found # no merchant/item with that id in database
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid # params incomplete for create/update

  def record_not_found(error)
    render json: ErrorSerializer.new(error).serialized_json, status: 404
  end

  def record_invalid(error)
    render json: ErrorSerializer.new(error).invalid_serialized_json, status: 400
  end
end
