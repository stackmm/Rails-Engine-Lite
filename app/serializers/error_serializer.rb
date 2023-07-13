class ErrorSerializer
  def initialize(error)
    @error = error
  end

  def serialized_json
    {
      errors: [
        {
          status: 404,
          title: @error.message
        }
      ]
    }
  end

  def invalid_serialized_json
    {
      errors: [
        {
          status: 400,
          title: @error.message
        }
      ]
    }
  end
end