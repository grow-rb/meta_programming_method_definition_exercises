require 'minitest/autorun'
require_relative 'my_enum'

class MyEnumOrTest < MiniTest::Test
  def setup
    $database = []
  end

  def test_or
    Foo.create(status: 0)
    Foo.create(status: 1)
    Foo.create(status: 2)
    assert_equal 2, Foo.canceled_or_deleted.size
  end
end

class Foo
  include MyEnum

  attr_reader :status
  def initialize(status: nil)
    @status = status
  end

  def self.create(status: nil)
    $database << new(status: status)
  end

  enum status: [:active, :canceled, :deleted]
end
