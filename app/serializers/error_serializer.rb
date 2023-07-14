class ErrorSerializer
  def initialize(error, status)
    @error = error
    @status = status
  end

  def serialized_json
    {
      errors: [
        {
          status: @status,
          title: @error.message
        }
      ]
    }
  end
end