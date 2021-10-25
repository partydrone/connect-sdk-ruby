# frozen_string_literal: true

require "test_helper"

describe Connect do
  subject { Connect }

  before do
    subject.setup
  end

  it "has a version number" do
    _(::Connect::VERSION).wont_be_nil
  end

  it "sets defaults" do
    Connect::Configurable.keys.each do |key|
      default = Connect::Default.send(key)
      actual = Connect.instance_variable_get(:"@#{key}")

      if default.nil?
        _(actual).must_be_nil
      else
        _(actual).must_equal default
      end
    end
  end
end
