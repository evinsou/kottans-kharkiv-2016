require 'byebug'

module Ebuberable
  def map
    return to_enum(:map) unless block_given?

    result = []
    each { |cell| result << yield(cell) }

    result
  end

  def select
    return to_enum(:select) unless block_given?

    result = []
    each { |cell| result << cell if yield(cell) }

    result
  end

  def reject
    return to_enum(:reject) unless block_given?

    result = []
    each { |cell| result << cell unless yield(cell) }

    result
  end

  def all?
    return to_enum(:all?) unless block_given?

    each { |elem| return unless block.call(elem) }
    # We returns true explicitly when true is a result for every element
    true
  end

  def grep(object)
    select { |cell| object === cell }
  end

  def reduce(acc, operator = nil, &block)
    if operator && block
      raise ArgumentError, "an operator symbol or a block should be present"
    end

    block ||= operator.to_proc

    each do |element|
      acc = block.call(acc, element)
    end
    acc
  end
end

class MyArray
  include Ebuberable
  include Comparable

  def initialize
    @data = []
  end

  def <<(new_element)
    @data << new_element
    @data.sort!

    self
  end

  def each
    return @data.each { |e| yield(e) } if block_given?

    Enumerator.new do |yielder, value|
      result = yield(value)
      yielder.yield(result)
    end
  end

  def sort
    @data.sort
  end
end

a = MyArray.new()
