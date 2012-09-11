require "minitest/autorun"
require "minitest/spec"

require "rr"
require "rr/adapters/rr_methods"

require "option"

include RR::Adapters::RRMethods

def value
  12
end

describe NoneClass do

  it "#to_a returns an empty array" do
    None.to_a.must_equal([])
  end

  it "#get raises IndexError" do
    lambda { None.get }.must_raise IndexError
  end

  it "#get_or_else executes the block" do
    None.get_or_else { "Some" }.must_equal "Some"
  end

  it "#foreach does not execute the block" do
    blk = proc {}
    dont_allow(blk).call

    None.foreach(&blk)

    RR.verify
  end

  it "#or_nil should return nil" do
    None.or_nil.must_be_nil
  end

  it "#empty? should be true" do
    None.empty?.must_equal(true)
  end

  it "#map should return itself" do
    None.map {}.must_equal(None)
  end

  it "#flat_map should return itself" do
    None.flat_map {}.must_equal(None)
  end

  it "#exists should return false" do
    None.exists {}.must_equal(false)
  end
end

describe SomeClass do

  it "#to_a returns an empty array" do
    Some(value).to_a.must_equal([value])
  end

  it "#get returns the inner value" do
    Some(value).get.must_equal(value)
  end

  it "#get_or_else executes the block" do
    blk = proc { value }
    dont_allow(blk).call

    Some(value).get_or_else(&blk)

    RR.verify
  end

  it "#foreach execute the block passing the inner value" do
    blk = proc {}
    mock(blk).call(value)

    Some(value).foreach(&blk)

    RR.verify
  end

  it "#or_nil should return the inner value" do
    Some(value).or_nil.must_equal(value)
  end

  it "#empty? should be true" do
    Some(value).empty?.must_equal(false)
  end

  it "#map should return the result of the proc over the value in an Option" do
    Some(value).map { |v| v * 2 }.must_equal(Some(24))
  end

  it "#flat_map should return the result of the proc over the value" do
    Some(value).flat_map { |v| v * 2 }.must_equal(24)
  end

  it "#exists should return false" do
    Some(value).exists { |v| v % 2 == 0 }.must_equal(true)
  end
end

describe "Option" do

  it "must return a some if the passed value is not nil" do
    Option(value).must_equal(Some(value))
  end

  it "must return a None if the passed value is nil" do
    Option(nil).must_equal(None)
  end
end

describe "Some" do

  it "should be aliased to SomeClass" do
    Some.must_equal(SomeClass)
  end

  it "should wrap the creation of a Some" do
    mock(Some).new(value)

    Some(value)

    RR.verify
  end
end

describe "None" do

  it "should be aliased to NoneClass" do
    None.must_be_instance_of(NoneClass)
  end
end
