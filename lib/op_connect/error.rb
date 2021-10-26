module OpConnect
  class Error < StandardError
    class << self
      def from_response(response)
        status = response.status

        if (klass = case status
            when 400 then OpConnect::BadRequest
            when 401 then OpConnect::Unauthorized
            when 403 then OpConnect::Forbidden
            when 404 then OpConnect::NotFound
            when 413 then OpConnect::PayloadTooLarge
            when 400..499 then OpConnect::ClientError
            when 500 then OpConnect::InternalServerError
            when 503 then OpConnect::ServiceUnavailable
            when 500..599 then OpConnect::ServerError
            end)
          klass.new(response)
        end
      end
    end

    def initialize(response = nil)
      @response = response
      super(build_error_message)
    end

    private

    def build_error_message
      return nil if @response.nil?

      message = "#{@response.method.to_s.upcase} "
      message << "#{@response.url}: "
      message << "#{@response.status} - "
      message << @response.body["message"].to_s if @response.body["message"]
      message << "\n\n#{@response.body}\n\n"

      message
    end
  end

  class ClientError < Error; end

  class BadRequest < ClientError; end

  class Unauthorized < ClientError; end

  class Forbidden < ClientError; end

  class NotFound < ClientError; end

  class PayloadTooLarge < ClientError; end

  class ServerError < Error; end

  class InternalServerError < ServerError; end

  class ServiceUnavailable < ServerError; end
end
