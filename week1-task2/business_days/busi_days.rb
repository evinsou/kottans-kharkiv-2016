require 'holidays'
require 'byebug'

class BusnessDays
  include Enumerable

  def initialize(start: Date.today, region: :ca)
    @region = region
    @date_range = (start..Float::INFINITY).lazy
  end

  def reject(&block)
    @date_range.each do |cell|
      block.call(cell)
    end
  end
end
byebug
BusnessDays.new(start: Date.parse('2016-05-01'), region: :fr).reject { |d| d.wday == 5 }.take(5)


