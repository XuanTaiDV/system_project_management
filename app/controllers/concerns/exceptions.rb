module Exceptions
  def self.exception_to_error(exception)
    attribute = case exception
                when Unauthorized
                  { code: 401, message: "Unauthorized" }
                when Forbidden
                  { code: 403, message: "Forbidden" }
                when Conflict
                  { code: 409, message: "Conflict" }
                when BadRequest, ActiveRecord::RecordInvalid
                  { code: 400, message: exception.message }
                when UnprocessableEntity
                  { code: 422, message: "Unprocessable entity" }
                else
                  { code: 500, message: "Internal server error" }
                end

    OpenStruct.new(**attribute)
  end

  class Unauthorized < StandardError; end
  class Forbidden < StandardError; end
  class Conflict < StandardError; end
  class BadRequest < StandardError; end
  class UnprocessableEntity < StandardError; end
end
