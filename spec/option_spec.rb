require "spec_helper"

describe NoneClass do

  it "#dup results in a TypeError" do
    _ { None.dup }.must_raise TypeError
  end

  it "#clone results in a TypeError" do
    _ { None.clone }.must_raise TypeError
  end

  it "#to_a returns an empty array" do
    _(None.to_a).must_equal([])
  end

  it "#get raises IndexError" do
    _ { None.get }.must_raise IndexError
  end

  it "#get_or_else executes the block" do
    _(None.get_or_else { "Some" }).must_equal "Some"
  end

  it "#each does not execute the block" do
    expected = nil
    None.each { |v| expected = v }

    _(expected).must_be_nil
  end

  it "#or_nil should return nil" do
    _(None.or_nil).must_be_nil
  end

  it "#present? should be false" do
    _(None.present?).must_equal(false)
  end

  it "#empty? should be true" do
    _(None.empty?).must_equal(true)
  end

  it "#map should return itself" do
    _(None.map {}).must_be_none
  end

  it "#flat_map should return itself" do
    _(None.flat_map {}).must_be_none
  end

  it "#exists? should return false" do
    _(None.exists? {}).must_equal(false)
  end

  it "#include? should return false" do
    _(None.include?(subject_value)).must_equal(false)
  end

  it "#fold should invoke the default proc" do
    _(None.fold(proc { subject_value }) { |v| v.to_f }).must_equal(subject_value)
  end

  it "#filter with a true predicate returns itself" do
    _(Option(subject_value).filter { |i| i == 12 }).must_be_some(subject_value)
  end

  it "#filter with a false predicate returns None" do
    _(Option(subject_value).filter { |i| i == 1 }).must_be_none
  end

  it "should be aliased to None" do
    _(None).must_be_instance_of(NoneClass)
  end

  it "#inside should return itself without invoking the block" do
    expected = nil
    None.inside { |v| expected = subject_value }
    _(expected).must_be_nil
  end

  it "#or_else should invoke the block and return an Option" do
    _(None.or_else { Some(subject_value) }).must_be_some(subject_value)
  end

  it "#or_else should raise a TypeError if an Option is not returned" do
    _ { None.or_else { subject_value } }.must_raise TypeError
  end

  it "#flatten should return itself" do
    _(None.flatten).must_be_none
  end

  it "#error should raise a RuntimeError with the given message" do
    _ { None.error("error") }.must_raise RuntimeError, "error"
  end

  it "#error should raise the error passed to it" do
    _ { None.error(ArgumentError.new("name")) }.must_raise ArgumentError, "name"
  end

  it "should assemble an Error from the arguments passed in" do
    _ { None.error(StandardError, "this is a problem") }.must_raise StandardError, "this is a problem"
  end
end

describe SomeClass do

  it "#to_a returns the value wrapped in an array" do
    _(Some(subject_value).to_a).must_equal([subject_value])
  end

  it "#get returns the inner value" do
    _(Some(subject_value).get).must_equal(subject_value)
  end

  it "#get_or_else does not execute the block;" do
    expected = nil
    Some(subject_value).get_or_else { expected = true }

    _(expected).must_be_nil
  end

  it "#get_or_else returns the value" do
    _(Some(subject_value).get_or_else { }).must_equal(subject_value)
  end

  it "#each executes the block passing the inner value" do
    expected = nil
    Some(subject_value).each { |v| expected = v }

    _(expected).must_equal(subject_value)
  end

  it "#or_nil should return the inner value" do
    _(Some(subject_value).or_nil).must_equal(subject_value)
  end

  it "#present? should be true" do
    _(Some(subject_value).present?).must_equal(true)
  end

  it "#empty? should be false" do
    _(Some(subject_value).empty?).must_equal(false)
  end

  it "#map should return the result of the proc over the value in a Some" do
    _(Some(subject_value).map { |v| v * 2 }).must_be_some(24)
  end

  it "#flat_map should raise TypeError if the returned value is not an Option" do
    _ { Some(subject_value).flat_map { |v| v * 2 } }.must_raise TypeError
  end

  it "#flat_map should return an Option value from the block" do
    _(Some(subject_value).flat_map { |v| Option(v * 2) }).must_be_some(24)
  end

  it "#flat_map can return None from the block" do
    _(Some(subject_value).flat_map { |_| None }).must_be_none
  end

  it "#exists? should return true when the block evaluates true" do
    _(Some(subject_value).exists? { |v| v % 2 == 0 }).must_equal(true)
  end

  it "#exists? should return false when the block evaluates false" do
    _(Some(subject_value).exists? { |v| v % 2 != 0 }).must_equal(false)
  end

  it "#include? should return true when the passed value and the boxed value are the same" do
    _(Some(subject_value).include?(subject_value)).must_equal(true)
  end

  it "#include? should return false when the passed value and the boxed value are not the same" do
    _(Some(subject_value).include?(subject_value + 1)).must_equal(false)
  end

  it "#fold should map the proc over the value and return it" do
    _(Some(subject_value).fold(proc { value * 2 }) { |v| v * 3 }).must_equal(36)
  end

  it "#filter should return itself" do
    _(None.filter { |i| i == 0 }).must_be_none
  end

  it "#inside should invoke the proc and return itself" do
    expected = nil
    _(Some(subject_value).inside { |v| expected = v }).must_be_some(subject_value)
    _(expected).must_equal(subject_value)
  end

  it "#or_else should return itself" do
    _(Some(subject_value).or_else { None }).must_be_some(subject_value)
  end

  it "should wrap the creation of a Some" do
    _(Some(subject_value)).must_be_instance_of(SomeClass)
  end

  it "should be aliased to Some" do
    _(Some.new(subject_value)).must_be_some(subject_value)
  end

  it "#flatten" do
    inner_value = Some(Some(Some(subject_value))).flatten
    _(inner_value).must_be_some(subject_value)
    _(inner_value.or_nil).must_equal(subject_value)
  end

  it "#error should return the Some" do
    value = !!(Some(subject_value).error("error") rescue false)
    _(value).must_equal true
  end
end

describe OptionClass do

  it "must return a some if the passed value is not nil" do
    _(Option(subject_value)).must_be_some(subject_value)
  end

  it "must return a None if the passed value is nil" do
    _(Option(nil)).must_be_none
  end

  it "should do equality checks against the boxed value" do
    _(Option(subject_value)).must_equal(subject_value)
  end
end
