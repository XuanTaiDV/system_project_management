module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Exception do |e|
      handle_exception(e)
    end
  end


  def handle_exception(exception)
    error = Exceptions.exception_to_error(exception)

    render json: { message: error.message, details: error.details }.compact, status: error.code
  end

end
