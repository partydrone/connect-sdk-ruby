require "faraday"
require "op_connect/error"

module OpConnect
  # Faraday response middleware
  #
  module Response
    # This class raises an OpConnect-flavored exception based on HTTP status
    # codes returned by the API.
    #
    class RaiseError < Faraday::Middleware
      def on_complete(response)
        if (error = OpConnect::Error.from_response(response))
          raise error
        end
      end
    end
  end
end
