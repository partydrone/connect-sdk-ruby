module OpConnect
  class APIRequest
    class Actor
      attr_reader :id, :account, :jti, :user_agent, :ip

      def initialize(options = {})
        @id = options["id"]
        @account = options["account"]
        @jti = options["jti"]
        @user_agent = options["user_agent"]
        @ip = options["ip"]
      end
    end
  end
end
