require "minitest/autorun"
require "minitest/pride"
require "minitest/spec"

require_relative "../lib/option"

module Minitest::Assertions

  def assert_some(value, option, msg = nil)
    assert (option.is_a?(Some) && option.or_nil == value), "Expected Some(#{value})"
  end

  def assert_none(value, option, msg = nil)
    assert option == None, "Expected None"
  end
end

OptionClass.infect_an_assertion :assert_some, :must_be_some
OptionClass.infect_an_assertion :assert_none, :must_be_none

def subject_value
  12
end
