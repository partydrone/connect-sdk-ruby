module OpConnect
  class ServerHealth
    autoload :Dependency, "op_connect/server_health/dependency"

    attr_reader :name, :version, :dependencies

    def initialize(options = {})
      @name = options["name"]
      @version = options["version"]
      @dependencies = options["dependencies"]&.collect! { |dependency| Dependency.new(dependency) } || []
    end
  end
end
