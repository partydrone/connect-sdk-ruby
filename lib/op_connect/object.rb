require "ostruct"

module OpConnect
  class Object < SimpleDelegator
    def initialize(attributes)
      super to_ostruct(attributes)
    end

    private

    def to_ostruct(obj)
      if obj.is_a?(Hash)
        OpenStruct.new(obj.map { |key, value| [key, to_ostruct(value)] }.to_h)
      elsif obj.is_a?(Array)
        obj.map { |o| to_ostruct(o) }
      else
        obj
      end
    end
  end
end
