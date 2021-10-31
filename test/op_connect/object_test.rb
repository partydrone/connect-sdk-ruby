require "test_helper"

describe OpConnect::Object do
  subject { OpConnect::Object }

  it "creates an object from a hash" do
    _(subject.new(foo: "bar").foo).must_equal "bar"
  end

  it "handles nested hashes" do
    _(subject.new(foo: {bar: {baz: "foobar"}}).foo.bar.baz).must_equal "foobar"
  end

  it "handles numbers" do
    _(subject.new(foo: {bar: 1}).foo.bar).must_equal 1
  end

  it "handles arrays" do
    object = subject.new(foo: [{bar: :baz}])

    _(object.foo.first).must_be_kind_of OpenStruct
    _(object.foo.first.bar).must_equal :baz
  end
end
