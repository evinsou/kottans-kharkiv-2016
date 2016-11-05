require 'byebug'

module Ebuberable

  def each(&block)
    size.times do |cell|
      block.call(cell)
    end
  end

  def map(&block)
    result = []

    each do |cell|
      result << block.call(cell)
    end

    result
  end

  def select(&block)
    result = []

    each do |cell|
#      next unless block.call(cell)

      result << cell if block.call(cell)
    end

    result
  end

  def reject(&block)
    result = []

    each do |cell|
#      next if block.call(cell)

      result << cell unless block.call(cell)
    end

    result
  end

  def grep
    
  end

  def all?(&block)
    result = []

    each do |cell|
      next unless block.call(cell)

      result << cell if block.call(cell)
    end

    size == result.size
  end

  def reduce(&block)
    
  end
end

class MyArray < Array
  include Ebuberable
end

a = MyArray.new

byebug
a.each
a.respond_to?(:map)
a.respond_to?(:map)


