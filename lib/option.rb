module OptionHelpers
  class OptionMatcher
    attr_reader :return_value

    def initialize(option)
      @option = option
      @return_value = nil
    end

    def case(type)
      if type.is_a?(OptionType)
        if @option.present?
          option_val = @option.get
          if option_val.is_a?(type.type)
            @return_value = yield(option_val)
          end
        end
      elsif type == SomeClass
        if @option.present?
          @return_value = yield(@option.get)
        end
      elsif type.is_a?(NoneClass)
          if !@option.present?
            @return_value = yield(@option)
          end
      else
        raise TypeError, "can't match an Option against a #{type.to_s}"
      end
    end

    def else
      @return_value = yield(@option)
    end
  end

  class OptionType
    attr_reader :type

    def initialize(type)
      @type = type
    end

    class << self
      def for_class(klass)
        case klass
          when Class
            option_type_cache[klass] ||= OptionType.new(klass)
          else
            raise TypeError, "Must be a Class"
        end
      end

      private

      def option_type_cache
        @option_type_cache ||= {}
      end
    end
  end
end

class OptionClass

  def or_nil
  end

  class << self
    def [](type)
      OptionHelpers::OptionType.for_class(type)
    end
  end

  def ==(that)
    case that
      when OptionClass then or_nil == that.or_nil
      else or_nil == that
    end
  end

  def match
    matcher = OptionHelpers::OptionMatcher.new(self)
    yield matcher
    matcher.return_value
  end

  private

  def assert_option(result)
    case result
      when OptionClass then return result
      else raise TypeError, "Must be an Option"
    end
  end
end

class SomeClass < OptionClass

  def initialize(value)
    @value = value
  end

  def to_a
    [get]
  end

  def get
    @value
  end

  def get_or_else(&blk)
    get
  end

  def each(&blk)
    blk.call(get)

    nil
  end

  def or_nil
    get
  end

  def present?
    true
  end

  def empty?
    false
  end

  def map(&blk)
    self.class.new(blk.call(get))
  end

  def flat_map(&blk)
    assert_option(blk.call(get))
  end

  def fold(if_empty, &blk)
    blk.call(get)
  end

  def exists?(&blk)
    !! blk.call(get)
  end

  def include?(value)
    get == value
  end

  def filter(&blk)
    exists?(&blk) ? self : None
  end

  def inside(&blk)
    blk.call(get)
    self
  end

  def or_else(&blk)
    self
  end

  def flatten
    case get
      when OptionClass then get.flatten
      else self
    end
  end

  def error(*argv)
    self
  end
end

class NoneClass < OptionClass
  def [](type)
    raise TypeError, "can't specify a type of NoneClass"
  end

  def dup
    raise TypeError, "can't dup NoneClass"
  end

  def clone
    raise TypeError, "can't clone NoneClass"
  end

  def to_a
    []
  end

  def get
    raise IndexError, "None.get"
  end

  def get_or_else(&blk)
    blk.call
  end

  def each(&blk)
    nil
  end

  def or_nil
    nil
  end

  def present?
    false
  end

  def empty?
    true
  end

  def map(&blk)
    flat_map(&blk)
  end

  def flat_map(&blk)
    self
  end

  def fold(if_empty, &blk)
    if_empty.call
  end

  def exists?(&blk)
    false
  end

  def include?(value)
    false
  end

  def filter(&blk)
    self
  end

  def inside(&blk)
    self
  end

  def or_else(&blk)
    assert_option(blk.call)
  end

  def flatten
    self
  end

  def error(*argv)
    argv.empty? ? raise : raise(*argv)
  end
end

None = NoneClass.new
Some = SomeClass

def Some(value)
  SomeClass.new(value)
end

def Option(value=nil)
  value.nil? ? None : Some(value)
end
