# frozen_string_literal: true

require "test_helper"

describe OpConnect do
  subject { OpConnect }

  before do
    subject.setup
  end

  it "has a version number" do
    _(::OpConnect::VERSION).wont_be_nil
  end

  it "sets defaults" do
    OpConnect::Configurable.keys.each do |key|
      default = OpConnect::Default.send(key)
      actual = OpConnect.instance_variable_get(:"@#{key}")

      if default.nil?
        _(actual).must_be_nil
      else
        _(actual).must_equal default
      end
    end
  end

  describe ".client" do
    it "creates a OpConnect::Client" do
      _(subject.client).must_be_kind_of OpConnect::Client
    end

    it "caches the client when the same arguments are passed" do
      _(subject.client).must_equal subject.client
    end

    it "returns a fresh client when options are not the same" do
      client = subject.client
      subject.access_token = "some-random-token"
      client_two = subject.client
      client_three = subject.client

      _(client).wont_equal client_two
      _(client_two).must_equal client_three
    end
  end
end
