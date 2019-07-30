require 'minitest/autorun'
require_relative 'my_enum'

class MyEnumTest < MiniTest::Test
  def setup
    $database = []
  end

  def test_it_generates_query_method
    foo = Foo.new(status: 1)
    assert_equal :active, foo.status
    assert foo.active?
  end

  def test_it_works_with_multiple_enums
    foo = Foo.new(status: 2, another_status: 3)
    assert foo.canceled?
    assert foo.moge?
  end

  def test_it_generates_mutation_method
    foo = Foo.new(status: 1)
    foo.canceled!
    assert foo.canceled?
  end

  def test_it_generates_scope_method
    Foo.create(status: 1)
    Foo.create(status: 1)
    Foo.create(status: 2)

    assert_equal 2, Foo.active.size
    assert_equal 1, Foo.canceled.size
  end

  def test_it_generates_negative_scope_method
    Foo.create(status: 1)
    Foo.create(status: 1)
    Foo.create(status: 2)

    assert_equal 1, Foo.not_active.size
    assert_equal 2, Foo.not_canceled.size
  end

  def test_it_works_with_array_value
    bar = Bar.new
    bar.deleted!
    assert_equal :deleted, bar.status
    assert bar.deleted?
  end
end

class Foo
  include MyEnum

  attr_reader :status, :another_status
  def initialize(status:, another_status: 1)
    @status = status
    @another_status = another_status
  end

  def self.create(status: , another_status: 1)
    $database << new(status: status, another_status: another_status)
  end

  enum status: {active: 1, canceled: 2, deleted: 3}
  enum another_status: {hoge: 1, fuga: 2, moge: 3}
end

class Bar
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
