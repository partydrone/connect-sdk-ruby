module OpConnect
  class APIRequest
    autoload :Actor, "op_connect/api_request/actor"
    autoload :Resource, "op_connect/api_request/resource"

    attr_reader :request_id, :timestamp, :action, :result, :actor, :resource

    def initialize(options = {})
      @request_id = options["request_id"]
      @timestamp = options["timestamp"]
      @action = options["action"]
      @result = options["result"]
      @actor = Actor.new(options["actor"])
      @resource = Resource.new(options["resource"])
    end
  end
end
