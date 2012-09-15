require "minitest/autorun"
require "minitest/spec"

require "option"

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
    expected = nil
    None.foreach { |v| expected = v }

    expected.must_be_nil
  end

  it "#or_nil should return nil" do
    None.or_nil.must_be_nil
  end

  it "#present? should be false" do
    None.present?.must_equal(false)
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

  it "#exists? should return false" do
    None.exists? {}.must_equal(false)
  end

  it "#fold should invoke the default proc" do
    None.fold(proc { value }) { |v| v.to_f }.must_equal(value)
  end

  it "#filter with a true predicate returns itself" do
    Option(value).filter { |i| i == 12 }.must_equal(Option(value))
  end

  it "#filter with a false predicate returns None" do
    Option(value).filter { |i| i == 1 }.must_equal(None)
  end

  it "should be aliased to None" do
    None.must_be_instance_of(NoneClass)
  end
end

describe SomeClass do

  it "#to_a returns the value wrapped in an array" do
    Some(value).to_a.must_equal([value])
  end

  it "#get returns the inner value" do
    Some(value).get.must_equal(value)
  end

  it "#get_or_else does not execute the block;" do
    expected = nil
    Some(value).get_or_else { expected = true }

    expected.must_be_nil
  end

  it "#get_or_else returns the value" do
    Some(value).get_or_else { }.must_equal(value)
  end

  it "#foreach executes the block passing the inner value" do
    expected = nil
    Some(value).foreach { |v| expected = v }

    expected.must_equal(value)
  end

  it "#or_nil should return the inner value" do
    Some(value).or_nil.must_equal(value)
  end

  it "#present? should be true" do
    Some(value).present?.must_equal(true)
  end

  it "#empty? should be false" do
    Some(value).empty?.must_equal(false)
  end

  it "#map should return the result of the proc over the value in an Option" do
    Some(value).map { |v| v * 2 }.must_equal(Some(24))
  end

  it "#flat_map should raise TypeError if the returned value is not an Option" do
    lambda { Some(value).flat_map { |v| v * 2 } }.must_raise TypeError
  end

  it "#flat_map should return an Option value from the block" do
    Some(value).flat_map { |v| Option(v * 2) }.must_equal(Some(24))
  end

  it "#flat_map can return None from the block" do
    Some(value).flat_map { |_| None }.must_equal(None)
  end

  it "#exists? should return true when the block evaluates true" do
    Some(value).exists? { |v| v % 2 == 0 }.must_equal(true)
  end

  it "#exists? should return false when the block evaluates false" do
    Some(value).exists? { |v| v % 2 != 0 }.must_equal(false)
  end

  it "#fold should map the proc over the value and return it" do
    Some(value).fold(proc { value * 2 }) { |v| v * 3 }.must_equal(36)
  end

  it "#filter should return itself" do
    None.filter { |i| i == 0 }.must_equal(None)
  end

  it "should wrap the creation of a Some" do
    Some(value).must_be_instance_of(SomeClass)
  end

  it "should be aliased to Some" do
    Some.new(value).must_equal(Some(value))
  end
end

describe OptionClass do

  it "must return a some if the passed value is not nil" do
    Option(value).must_equal(Some(value))
  end

  it "must return a None if the passed value is nil" do
    Option(nil).must_equal(None)
  end
end
