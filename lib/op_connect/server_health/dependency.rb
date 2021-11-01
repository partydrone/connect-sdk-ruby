module OpConnect
  class ServerHealth
    class Dependency
      attr_reader :service, :status, :message

      def initialize(options = {})
        @service = options["service"]
        @status = options["status"]
        @message = options["message"]
      end
    end
  end
end
