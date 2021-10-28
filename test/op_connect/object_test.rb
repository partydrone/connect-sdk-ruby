require "test_helper"

class ObjectTest < Minitest::Test
  def test_creating_object_from_hash
    assert_equal "bar", OpConnect::Object.new(foo: "bar").foo
  end

  def test_nested_hash
    assert_equal "foobar", OpConnect::Object.new(foo: {bar: {baz: "foobar"}}).foo.bar.baz
  end

  def test_nested_number
    assert_equal 1, OpConnect::Object.new(foo: {bar: 1}).foo.bar
  end

  def test_array
    object = OpConnect::Object.new(foo: [{bar: :baz}])
    assert_equal OpenStruct, object.foo.first.class
    assert_equal :baz, object.foo.first.bar
  end
end
