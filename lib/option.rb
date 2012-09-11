class SomeClass

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

  def foreach(&blk)
    flat_map(&blk)

    nil
  end

  def or_nil
    get
  end

  def empty?
    false
  end

  def map(&blk)
    Option(flat_map(&blk))
  end

  def flat_map(&blk)
    blk.call(get)
  end

  def exists?(&blk)
    !! flat_map(&blk)
  end

  def ==(that)
    or_nil == that.or_nil
  end
end

class NoneClass

  def to_a
    []
  end

  def get
    raise IndexError, "None.get"
  end

  def get_or_else(&blk)
    blk.call
  end

  def foreach(&blk)
    nil
  end

  def or_nil
    nil
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

  def exists?(&blk)
    false
  end

  def ==(that)
    self.or_nil == self.or_nil
  end
end

None = NoneClass.new
Some = SomeClass

def Some(value)
  Some.new(value)
end

def Option(value)
  value.nil? ? None : Some(value)
end
